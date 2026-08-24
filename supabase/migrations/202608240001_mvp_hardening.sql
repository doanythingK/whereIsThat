-- Follow-up for environments that already applied 202608230001_mvp.sql.
-- Keep this migration idempotent so dev and prod promotion use the same SQL.

create table if not exists public.notification_events (
  id uuid primary key default gen_random_uuid(),
  recipient_user_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  delivered_at timestamptz,
  failed_at timestamptz,
  error_message text
);

alter table public.notification_events enable row level security;
grant select on public.notification_events to authenticated;
drop policy if exists notification_event_self on public.notification_events;
create policy notification_event_self on public.notification_events
for select using (recipient_user_id = auth.uid());

create or replace function public.queue_member_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' and new.deleted_at is null then
    insert into public.notification_events(recipient_user_id, event_type, payload)
    select sm.user_id, 'space_member_joined', jsonb_build_object('space_id', new.space_id)
    from public.space_members sm
    where sm.space_id = new.space_id
      and sm.deleted_at is null
      and sm.user_id <> new.user_id;
  elsif tg_op = 'UPDATE'
    and new.deleted_at is null
    and old.role is distinct from new.role then
    insert into public.notification_events(recipient_user_id, event_type, payload)
    select sm.user_id, 'space_member_role_changed', jsonb_build_object('space_id', new.space_id)
    from public.space_members sm
    where sm.space_id = new.space_id and sm.deleted_at is null;
  end if;
  return new;
end;
$$;

drop trigger if exists queue_member_notification_trigger on public.space_members;
create trigger queue_member_notification_trigger
after insert or update of role, deleted_at on public.space_members
for each row execute procedure public.queue_member_notification();

create or replace function public.queue_shared_change_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare target_space_id uuid;
declare target_event_type text;
begin
  if tg_table_name = 'shopping_items' then
    target_space_id := new.space_id;
    target_event_type := 'shopping_item_changed';
  elsif tg_table_name = 'checklist_member_checks' then
    select c.space_id into target_space_id
    from public.checklist_items ci
    join public.checklists c on c.id = ci.checklist_id
    where ci.id = new.checklist_item_id and c.visibility = 'shared';
    target_event_type := 'shared_checklist_changed';
  else
    select c.space_id into target_space_id
    from public.checklist_items ci
    join public.checklists c on c.id = ci.checklist_id
    where ci.id = new.id and c.visibility = 'shared';
    target_event_type := 'shared_checklist_changed';
  end if;
  if target_space_id is null then return new; end if;
  insert into public.notification_events(recipient_user_id, event_type, payload)
  select sm.user_id, target_event_type, jsonb_build_object('space_id', target_space_id)
  from public.space_members sm
  where sm.space_id = target_space_id
    and sm.deleted_at is null
    and sm.user_id is distinct from auth.uid();
  return new;
end;
$$;

drop trigger if exists queue_shopping_notification_trigger on public.shopping_items;
create trigger queue_shopping_notification_trigger
after insert or update on public.shopping_items
for each row execute procedure public.queue_shared_change_notification();
drop trigger if exists queue_checklist_notification_trigger on public.checklist_items;
create trigger queue_checklist_notification_trigger
after insert or update on public.checklist_items
for each row execute procedure public.queue_shared_change_notification();
drop trigger if exists queue_checklist_member_notification_trigger on public.checklist_member_checks;
create trigger queue_checklist_member_notification_trigger
after insert or update on public.checklist_member_checks
for each row execute procedure public.queue_shared_change_notification();

grant select on public.app_config to anon;

alter table public.items drop constraint if exists private_item_creator;

create or replace function public.is_space_member(target_space_id uuid, target_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.space_members sm
    join public.profiles p on p.id = sm.user_id
    where sm.space_id = target_space_id
      and sm.user_id = target_user_id
      and sm.deleted_at is null
      and p.deleted_at is null
  );
$$;

create or replace function public.is_space_admin(target_space_id uuid, target_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.space_members sm
    join public.profiles p on p.id = sm.user_id
    where sm.space_id = target_space_id
      and sm.user_id = target_user_id
      and sm.role = 'admin'
      and sm.deleted_at is null
      and p.deleted_at is null
  );
$$;

create or replace function public.validate_location_floor_plan_space()
returns trigger
language plpgsql
as $$
begin
  if not exists (
    select 1 from public.floor_plans
    where id = new.floor_plan_id
      and space_id = new.space_id
      and deleted_at is null
  ) then
    raise exception 'location_floor_plan_space_mismatch';
  end if;
  return new;
end;
$$;

create or replace function public.validate_private_item_owner()
returns trigger
language plpgsql
as $$
begin
  if new.visibility = 'private'
     and new.owner_user_id is not null
     and not exists (
       select 1 from public.space_members sm
       join public.profiles p on p.id = sm.user_id
       where sm.space_id = new.space_id
         and sm.user_id = new.owner_user_id
         and sm.deleted_at is null
         and p.deleted_at is null
     ) then
    raise exception 'private_item_owner_not_member';
  end if;
  return new;
end;
$$;

drop trigger if exists validate_private_item_owner_trigger on public.items;
create trigger validate_private_item_owner_trigger
before insert or update on public.items
for each row execute procedure public.validate_private_item_owner();

create or replace function public.restore_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare deleted_at_value timestamptz;
begin
  select deleted_at into deleted_at_value
  from public.profiles where id = auth.uid();
  if deleted_at_value is null then return; end if;
  if deleted_at_value + interval '30 days' <= now() then
    raise exception 'retention_period_expired';
  end if;
  update public.profiles
    set deleted_at = null, updated_at = now()
    where id = auth.uid();
end;
$$;

create or replace function public.accept_space_invite(invite_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare invite_row public.space_invites%rowtype;
declare target_member_count integer;
begin
  select * into invite_row from public.space_invites
  where upper(code) = upper(invite_code) for update;
  if not exists (
    select 1 from public.profiles
    where id = auth.uid() and deleted_at is null
  ) then
    raise exception 'account_deletion_pending';
  end if;
  if invite_row.id is null
     or invite_row.revoked_at is not null
     or invite_row.expires_at <= now()
     or exists (
       select 1 from public.spaces
       where id = invite_row.space_id and deleted_at is not null
     )
     or (invite_row.max_uses is not null and invite_row.use_count >= invite_row.max_uses) then
    raise exception 'invite_invalid';
  end if;
  select count(*) into target_member_count
  from public.space_members
  where space_id = invite_row.space_id and deleted_at is null;
  if target_member_count >= 20 then
    raise exception 'space_member_limit_reached';
  end if;
  insert into public.space_members(space_id, user_id, role)
  values (invite_row.space_id, auth.uid(), 'member')
  on conflict (space_id, user_id) do update set deleted_at = null;
  update public.space_invites
    set use_count = use_count + 1
    where id = invite_row.id;
  return invite_row.space_id;
end;
$$;

create or replace function public.set_item_primary_photo(
  target_item_id uuid,
  target_photo_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare item_space uuid;
declare item_visibility text;
declare item_creator uuid;
declare item_owner uuid;
begin
  select space_id, visibility, created_by, owner_user_id
    into item_space, item_visibility, item_creator, item_owner
    from public.items
    where id = target_item_id and deleted_at is null;
  if not public.is_space_member(item_space, auth.uid())
     or (item_visibility = 'private'
         and coalesce(item_creator <> auth.uid(), true)
         and coalesce(item_owner <> auth.uid(), true)) then
    raise exception 'not_allowed';
  end if;
  if not exists (
    select 1 from public.item_photos
    where id = target_photo_id and item_id = target_item_id
  ) then
    raise exception 'photo_not_found';
  end if;
  update public.item_photos set is_primary = false
  where item_id = target_item_id;
  update public.item_photos set is_primary = true
  where id = target_photo_id and item_id = target_item_id;
end;
$$;

drop function if exists public.leave_space(uuid);
create or replace function public.leave_space(
  target_space_id uuid,
  personal_data_action text default 'keep',
  target_destination_space_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare current_role text;
declare other_admin_exists boolean;
begin
  if personal_data_action not in ('keep', 'delete', 'move') then
    raise exception 'invalid_personal_data_action';
  end if;
  select role into current_role from public.space_members
  where space_id = target_space_id
    and user_id = auth.uid()
    and deleted_at is null;
  if current_role is null then raise exception 'not_allowed'; end if;
  select exists (
    select 1 from public.space_members
    where space_id = target_space_id
      and role = 'admin'
      and user_id <> auth.uid()
      and deleted_at is null
  ) into other_admin_exists;
  if current_role = 'admin' and not other_admin_exists then
    raise exception 'last_admin_cannot_leave';
  end if;
  if personal_data_action = 'move' then
    if target_destination_space_id is null
       or target_destination_space_id = target_space_id
       or not public.is_space_member(target_destination_space_id, auth.uid()) then
      raise exception 'target_space_not_allowed';
    end if;
    update public.items
    set space_id = target_destination_space_id,
        location_id = null,
        category_id = null,
        version = version + 1,
        updated_at = now()
    where space_id = target_space_id
      and created_by = auth.uid()
      and visibility = 'private'
      and deleted_at is null;
  elsif personal_data_action = 'delete' then
    update public.items
    set deleted_at = now(),
        delete_purge_at = now() + interval '30 days',
        version = version + 1,
        updated_at = now()
    where space_id = target_space_id
      and created_by = auth.uid()
      and visibility = 'private'
      and deleted_at is null;
  end if;
  update public.space_members
  set deleted_at = now()
  where space_id = target_space_id
    and user_id = auth.uid()
    and deleted_at is null;
end;
$$;

grant execute on function public.restore_account() to authenticated;
grant execute on function public.set_item_primary_photo(uuid, uuid) to authenticated;
grant execute on function public.leave_space(uuid, text, uuid) to authenticated;

drop policy if exists checklist_member_check_visible on public.checklist_member_checks;
create policy checklist_member_check_visible on public.checklist_member_checks
for all
using (
  user_id = auth.uid()
  or exists (
    select 1
    from public.checklist_items ci
    join public.checklists c on c.id = ci.checklist_id
    where ci.id = checklist_item_id
      and c.visibility = 'shared'
      and public.is_space_member(c.space_id, auth.uid())
  )
)
with check (
  user_id = auth.uid()
  and exists (
    select 1
    from public.checklist_items ci
    join public.checklists c on c.id = ci.checklist_id
    where ci.id = checklist_item_id
      and (
        c.created_by = auth.uid()
        or (c.visibility = 'shared' and public.is_space_member(c.space_id, auth.uid()))
      )
  )
);

drop policy if exists item_member_insert on public.items;
create policy item_member_insert on public.items for insert with check (
  public.is_space_member(space_id, auth.uid())
  and created_by = auth.uid()
  and (visibility = 'shared' or owner_user_id = auth.uid() or owner_user_id is null or public.is_space_admin(space_id, auth.uid()))
);
drop policy if exists item_member_update on public.items;
create policy item_member_update on public.items for update using (
  public.is_space_member(space_id, auth.uid())
  and (visibility = 'shared' or created_by = auth.uid() or owner_user_id = auth.uid() or public.is_space_admin(space_id, auth.uid()))
) with check (
  public.is_space_member(space_id, auth.uid())
  and (visibility = 'shared' or created_by = auth.uid() or owner_user_id = auth.uid() or public.is_space_admin(space_id, auth.uid()))
);

drop policy if exists item_photo_storage_select on storage.objects;
create policy item_photo_storage_select on storage.objects
for select using (
  bucket_id = 'item-photos'
  and exists (
    select 1
    from public.item_photos p
    join public.items i on i.id = p.item_id
    where p.storage_path = name
      and public.is_space_member(i.space_id, auth.uid())
      and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid())
  )
);

drop policy if exists item_photo_storage_delete on storage.objects;
create policy item_photo_storage_delete on storage.objects
for delete using (
  bucket_id = 'item-photos'
  and exists (
    select 1
    from public.item_photos p
    join public.items i on i.id = p.item_id
    where p.storage_path = name
      and public.is_space_member(i.space_id, auth.uid())
      and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid())
      and (storage.foldername(name))[1] = auth.uid()::text
  )
);

create index if not exists notification_events_pending_idx
  on public.notification_events(created_at)
  where delivered_at is null and failed_at is null;
