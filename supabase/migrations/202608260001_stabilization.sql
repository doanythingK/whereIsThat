-- Stabilization follow-up for the MVP migrations.
-- Keep the existing public API while making soft-delete/restore operations
-- safe for the location and item integrity triggers.

create or replace function public.handle_location_soft_delete()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.deleted_at is null and new.deleted_at is not null then
    -- A location can be deleted more than once.  Recovered rows from an
    -- earlier deletion must not be mistaken for the current deletion batch.
    delete from public.item_location_recovery
    where location_id = old.id and recovered_at is not null;

    insert into public.item_location_recovery(item_id, location_id)
    select id, old.id
    from public.items
    where location_id = old.id and deleted_at is null
    on conflict (item_id, location_id) do nothing;

    update public.items
    set location_id = null, updated_at = now()
    where location_id = old.id and deleted_at is null;
  end if;
  return new;
end;
$$;

create or replace function public.restore_location(target_location_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  target_space uuid;
  target_floor_plan uuid;
  target_deleted_at timestamptz;
  purge_at timestamptz;
begin
  select space_id, floor_plan_id, deleted_at, delete_purge_at
    into target_space, target_floor_plan, target_deleted_at, purge_at
    from public.locations
    where id = target_location_id
      and deleted_at is not null;
  if not public.is_space_member(target_space, auth.uid()) then
    raise exception 'not_allowed';
  end if;
  if purge_at is null or purge_at <= now() then
    raise exception 'retention_period_expired';
  end if;
  if not exists (
    select 1
    from public.floor_plans
    where id = target_floor_plan
      and deleted_at is null
  ) then
    raise exception 'floor_plan_deleted';
  end if;

  update public.locations
    set deleted_at = null, delete_purge_at = null
    where id = target_location_id
      and deleted_at = target_deleted_at
      and delete_purge_at = purge_at;

  update public.items i
    set location_id = r.location_id, updated_at = now()
    from public.item_location_recovery r
    where r.location_id = target_location_id
      and r.item_id = i.id
      and r.recovered_at is null
      and i.space_id = target_space
      and i.location_id is null
      and i.deleted_at is null;

  update public.item_location_recovery
    set recovered_at = now()
    where location_id = target_location_id and recovered_at is null;
end;
$$;

create or replace function public.soft_delete_floor_plan(target_floor_plan_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  target_space uuid;
  deletion_at timestamptz;
  purge_at timestamptz;
begin
  select space_id
    into target_space
    from public.floor_plans
    where id = target_floor_plan_id
      and deleted_at is null;
  if not public.is_space_member(target_space, auth.uid()) then
    raise exception 'not_allowed';
  end if;

  deletion_at := now();
  purge_at := deletion_at + interval '30 days';

  -- Locations must be soft-deleted first.  The location trigger validates
  -- that its floor plan is still active before the floor plan is deleted.
  update public.locations
    set deleted_at = deletion_at, delete_purge_at = purge_at
    where floor_plan_id = target_floor_plan_id
      and deleted_at is null;

  update public.floor_plans
    set deleted_at = deletion_at, delete_purge_at = purge_at
    where id = target_floor_plan_id
      and deleted_at is null;
end;
$$;

create or replace function public.restore_floor_plan(target_floor_plan_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  target_space uuid;
  deletion_at timestamptz;
  purge_at timestamptz;
  restored_location_ids uuid[];
begin
  select space_id, deleted_at, delete_purge_at
    into target_space, deletion_at, purge_at
    from public.floor_plans
    where id = target_floor_plan_id
      and deleted_at is not null;
  if not public.is_space_member(target_space, auth.uid()) then
    raise exception 'not_allowed';
  end if;
  if purge_at is null or purge_at <= now() then
    raise exception 'retention_period_expired';
  end if;

  -- Only locations deleted by this floor-plan deletion are restored.
  -- A location deleted independently must remain in the trash.
  select coalesce(array_agg(id), '{}'::uuid[])
    into restored_location_ids
    from public.locations
    where floor_plan_id = target_floor_plan_id
      and deleted_at = deletion_at
      and delete_purge_at = purge_at;

  update public.floor_plans
    set deleted_at = null, delete_purge_at = null
    where id = target_floor_plan_id
      and deleted_at = deletion_at
      and delete_purge_at = purge_at;

  update public.locations
    set deleted_at = null, delete_purge_at = null
    where id = any(restored_location_ids);

  update public.items i
    set location_id = r.location_id, updated_at = now()
    from public.item_location_recovery r
    where r.location_id = any(restored_location_ids)
      and r.item_id = i.id
      and r.recovered_at is null
      and i.space_id = target_space
      and i.location_id is null
      and i.deleted_at is null;

  update public.item_location_recovery r
    set recovered_at = now()
    where r.location_id = any(restored_location_ids)
      and r.recovered_at is null;
end;
$$;

create or replace function public.restore_item(target_item_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  target_space uuid;
  target_visibility text;
  target_creator uuid;
  target_owner uuid;
  target_location_id uuid;
  purge_at timestamptz;
begin
  select space_id, visibility, created_by, owner_user_id,
         location_id, delete_purge_at
    into target_space, target_visibility, target_creator, target_owner,
         target_location_id, purge_at
    from public.items
    where id = target_item_id
      and deleted_at is not null;
  if not public.is_space_member(target_space, auth.uid())
     or not (
       target_visibility = 'shared'
       or target_creator = auth.uid()
       or target_owner = auth.uid()
       or public.is_space_admin(target_space, auth.uid())
     ) then
    raise exception 'not_allowed';
  end if;
  if purge_at is null or purge_at <= now() then
    raise exception 'retention_period_expired';
  end if;

  -- A location can have been deleted after this item entered the trash.
  -- Keep the item restorable even when that old location is no longer valid.
  update public.items
    set location_id = case
      when target_location_id is not null and exists (
        select 1
        from public.locations
        where id = target_location_id
          and space_id = target_space
          and deleted_at is null
      ) then target_location_id
      else null
    end,
    deleted_at = null,
    delete_purge_at = null,
    version = version + 1,
    updated_at = now()
    where id = target_item_id
      and deleted_at is not null;
end;
$$;

-- A personal check is readable/removable only when its checklist is also
-- accessible to the current user.  This prevents an orphaned check row from
-- becoming a way to probe an inaccessible checklist item.
drop policy if exists checklist_member_check_select
  on public.checklist_member_checks;
create policy checklist_member_check_select
on public.checklist_member_checks
for select using (
  exists (
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

drop policy if exists checklist_member_check_delete
  on public.checklist_member_checks;
create policy checklist_member_check_delete
on public.checklist_member_checks
for delete using (
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
