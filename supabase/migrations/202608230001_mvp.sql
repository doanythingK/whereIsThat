-- "엄마 이거 어딨어?" MVP schema and RLS.
-- Apply this migration to the dev Supabase project first. Production must be
-- promoted only after the same migration has passed dev verification.

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text,
  profile_image_path text,
  theme_mode text not null default 'system' check (theme_mode in ('system', 'light', 'dark')),
  marketing_opt_in boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table if not exists public.spaces (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) between 1 and 80),
  icon_key text not null default 'home',
  icon_color text,
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  delete_purge_at timestamptz
);

create table if not exists public.space_members (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('admin', 'member')),
  display_name text,
  joined_at timestamptz not null default now(),
  last_accessed_at timestamptz,
  deleted_at timestamptz,
  constraint active_space_member_unique unique (space_id, user_id)
);

create unique index if not exists one_active_member_per_user_space
  on public.space_members(space_id, user_id) where deleted_at is null;

create table if not exists public.space_invites (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces(id) on delete cascade,
  code text not null unique,
  token_hash text not null unique,
  created_by uuid not null references auth.users(id),
  expires_at timestamptz not null,
  revoked_at timestamptz,
  max_uses integer check (max_uses is null or max_uses > 0),
  use_count integer not null default 0 check (use_count >= 0),
  created_at timestamptz not null default now()
);

create table if not exists public.floor_plans (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 80),
  layout_data jsonb not null default jsonb_build_object(
    'grid', jsonb_build_object('rows', 20, 'cols', 20),
    'activeCells', '[]'::jsonb,
    'walls', '[]'::jsonb,
    'rooms', '[]'::jsonb
  ),
  version bigint not null default 1 check (version > 0),
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  delete_purge_at timestamptz
);

create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces(id) on delete cascade,
  floor_plan_id uuid not null references public.floor_plans(id) on delete cascade,
  room_key text,
  name text not null check (char_length(trim(name)) between 1 and 100),
  location_type text,
  icon_key text not null default 'shelf',
  icon_color text,
  show_label boolean not null default true,
  x_ratio numeric(8, 6) not null check (x_ratio between 0 and 1),
  y_ratio numeric(8, 6) not null check (y_ratio between 0 and 1),
  z_index integer not null default 0,
  version bigint not null default 1 check (version > 0),
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  delete_purge_at timestamptz
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  space_id uuid references public.spaces(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 60),
  is_system boolean not null default false,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create unique index if not exists categories_unique_active_name
  on public.categories(coalesce(space_id, '00000000-0000-0000-0000-000000000000'::uuid), lower(name))
  where deleted_at is null;

create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null references public.spaces(id) on delete cascade,
  location_id uuid references public.locations(id) on delete set null,
  category_id uuid references public.categories(id) on delete set null,
  name text not null check (char_length(trim(name)) between 1 and 200),
  quantity numeric not null default 1 check (quantity >= 0),
  unit text,
  detail_location text,
  memo text check (memo is null or char_length(memo) <= 500),
  is_food boolean not null default false,
  visibility text not null default 'shared' check (visibility in ('shared', 'private')),
  owner_user_id uuid references auth.users(id),
  created_by uuid not null references auth.users(id),
  version bigint not null default 1 check (version > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  delete_purge_at timestamptz,
  constraint private_item_creator check (visibility = 'shared' or created_by = owner_user_id or owner_user_id is null)
);

create table if not exists public.item_photos (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items(id) on delete cascade,
  storage_path text not null unique,
  is_primary boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create unique index if not exists one_primary_photo_per_item
  on public.item_photos(item_id) where is_primary;

create table if not exists public.item_location_history (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items(id) on delete cascade,
  from_space_id uuid references public.spaces(id),
  from_location_id uuid references public.locations(id),
  to_space_id uuid references public.spaces(id),
  to_location_id uuid references public.locations(id),
  moved_by uuid references auth.users(id),
  moved_at timestamptz not null default now(),
  reason text
);

create table if not exists public.item_favorites (
  user_id uuid not null references auth.users(id) on delete cascade,
  item_id uuid not null references public.items(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, item_id)
);

create table if not exists public.shopping_lists (
  id uuid primary key default gen_random_uuid(),
  space_id uuid not null unique references public.spaces(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.shopping_items (
  id uuid primary key default gen_random_uuid(),
  shopping_list_id uuid not null references public.shopping_lists(id) on delete cascade,
  space_id uuid not null references public.spaces(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 200),
  assignee_user_id uuid references auth.users(id),
  is_completed boolean not null default false,
  completed_by uuid references auth.users(id),
  completed_at timestamptz,
  sort_order numeric not null default 0,
  source_type text,
  source_id uuid,
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table if not exists public.checklist_templates (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid references auth.users(id) on delete cascade,
  template_type text not null check (template_type in ('system', 'user')),
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.checklist_template_items (
  id uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.checklist_templates(id) on delete cascade,
  name text not null,
  category_id uuid references public.categories(id) on delete set null,
  sort_order numeric not null default 0
);

create table if not exists public.checklists (
  id uuid primary key default gen_random_uuid(),
  space_id uuid references public.spaces(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 100),
  visibility text not null check (visibility in ('personal', 'shared')),
  is_completed boolean not null default false,
  completed_by uuid references auth.users(id),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint personal_checklist_has_no_space check (visibility = 'shared' or space_id is null)
);

create table if not exists public.checklist_items (
  id uuid primary key default gen_random_uuid(),
  checklist_id uuid not null references public.checklists(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 200),
  linked_item_id uuid references public.items(id) on delete set null,
  is_final_completed boolean not null default false,
  final_completed_by uuid references auth.users(id),
  final_completed_at timestamptz,
  sort_order numeric not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.checklist_member_checks (
  checklist_item_id uuid not null references public.checklist_items(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  is_checked boolean not null default false,
  checked_at timestamptz,
  primary key (checklist_item_id, user_id)
);

create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  theme_mode text not null default 'system',
  shortcut_config jsonb not null default '[]'::jsonb,
  notification_config jsonb not null default '{}'::jsonb,
  marketing_opt_in boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  platform text not null check (platform in ('android', 'ios')),
  fcm_token text not null unique,
  app_version text,
  is_active boolean not null default true,
  last_seen_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.app_notices (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  importance text not null default 'normal',
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.app_config (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

grant usage on schema public to authenticated;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant usage, select on all sequences in schema public to authenticated;

create or replace function public.is_space_member(target_space_id uuid, target_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.space_members
    where space_id = target_space_id
      and user_id = target_user_id
      and deleted_at is null
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
    select 1 from public.space_members
    where space_id = target_space_id
      and user_id = target_user_id
      and role = 'admin'
      and deleted_at is null
  );
$$;

revoke all on function public.is_space_member(uuid, uuid) from public;
revoke all on function public.is_space_admin(uuid, uuid) from public;
grant execute on function public.is_space_member(uuid, uuid) to authenticated;
grant execute on function public.is_space_admin(uuid, uuid) to authenticated;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles(id, nickname)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'nickname', new.raw_user_meta_data ->> 'name'))
  on conflict (id) do nothing;
  insert into public.user_settings(user_id) values (new.id) on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function public.handle_new_space()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.space_members(space_id, user_id, role, display_name)
  values (new.id, new.created_by, 'admin', null)
  on conflict (space_id, user_id) do update set deleted_at = null, role = 'admin';
  insert into public.floor_plans(space_id, name, created_by) values (new.id, '1층', new.created_by);
  insert into public.shopping_lists(space_id) values (new.id) on conflict (space_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_space_created on public.spaces;
create trigger on_space_created after insert on public.spaces
for each row execute procedure public.handle_new_space();

create or replace function public.enforce_space_member_limit()
returns trigger
language plpgsql
as $$
begin
  if new.deleted_at is null and not exists (
    select 1 from public.space_members
    where space_id = new.space_id
      and user_id = new.user_id
      and deleted_at is null
      and id <> new.id
  ) then
    if (select count(*) from public.space_members where space_id = new.space_id and deleted_at is null) >= 20 then
      raise exception 'space_member_limit_reached';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists enforce_space_member_limit_trigger on public.space_members;
create trigger enforce_space_member_limit_trigger before insert or update on public.space_members
for each row execute procedure public.enforce_space_member_limit();

create or replace function public.prevent_last_space_admin()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.deleted_at is null
     and (new.deleted_at is not null or new.role <> 'admin')
     and old.role = 'admin'
     and not exists (
       select 1 from public.space_members
       where space_id = old.space_id
         and role = 'admin'
         and deleted_at is null
         and id <> old.id
     ) then
    raise exception 'space_requires_one_admin';
  end if;
  return new;
end;
$$;

drop trigger if exists prevent_last_space_admin_trigger on public.space_members;
create trigger prevent_last_space_admin_trigger before update on public.space_members
for each row execute procedure public.prevent_last_space_admin();

create or replace function public.prevent_created_by_change()
returns trigger
language plpgsql
as $$
begin
  if old.created_by is distinct from new.created_by then
    raise exception 'created_by_is_immutable';
  end if;
  return new;
end;
$$;

drop trigger if exists prevent_floor_plan_created_by_change on public.floor_plans;
create trigger prevent_floor_plan_created_by_change before update on public.floor_plans
for each row execute procedure public.prevent_created_by_change();
drop trigger if exists prevent_location_created_by_change on public.locations;
create trigger prevent_location_created_by_change before update on public.locations
for each row execute procedure public.prevent_created_by_change();

create or replace function public.validate_item_location_space()
returns trigger
language plpgsql
as $$
begin
  if new.location_id is not null and not exists (
    select 1 from public.locations
    where id = new.location_id
      and space_id = new.space_id
      and deleted_at is null
  ) then
    raise exception 'item_location_space_mismatch';
  end if;
  return new;
end;
$$;

drop trigger if exists validate_item_location_space_trigger on public.items;
create trigger validate_item_location_space_trigger before insert or update on public.items
for each row execute procedure public.validate_item_location_space();

create or replace function public.validate_location_floor_plan_space()
returns trigger
language plpgsql
as $$
begin
  if not exists (
    select 1 from public.floor_plans
    where id = new.floor_plan_id
      and space_id = new.space_id
  ) then
    raise exception 'location_floor_plan_space_mismatch';
  end if;
  return new;
end;
$$;

drop trigger if exists validate_location_floor_plan_space_trigger on public.locations;
create trigger validate_location_floor_plan_space_trigger before insert or update on public.locations
for each row execute procedure public.validate_location_floor_plan_space();

create or replace function public.prevent_last_floor_plan_delete()
returns trigger
language plpgsql
as $$
begin
  if old.deleted_at is null and new.deleted_at is not null and not exists (
    select 1 from public.floor_plans
    where space_id = old.space_id and deleted_at is null and id <> old.id
  ) then
    raise exception 'space_requires_one_floor_plan';
  end if;
  return new;
end;
$$;

drop trigger if exists prevent_last_floor_plan_delete_trigger on public.floor_plans;
create trigger prevent_last_floor_plan_delete_trigger before update on public.floor_plans
for each row execute procedure public.prevent_last_floor_plan_delete();

create table if not exists public.item_location_recovery (
  item_id uuid not null references public.items(id) on delete cascade,
  location_id uuid not null references public.locations(id) on delete cascade,
  recovered_at timestamptz,
  primary key (item_id, location_id)
);

alter table public.item_location_recovery enable row level security;

create or replace function public.enforce_item_photo_limit()
returns trigger
language plpgsql
as $$
begin
  if (select count(*) from public.item_photos where item_id = new.item_id) >= 3 then
    raise exception 'item_photo_limit_reached';
  end if;
  return new;
end;
$$;

drop trigger if exists enforce_item_photo_limit_trigger on public.item_photos;
create trigger enforce_item_photo_limit_trigger before insert on public.item_photos
for each row execute procedure public.enforce_item_photo_limit();

create or replace function public.record_item_location_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.location_id is distinct from new.location_id or old.space_id is distinct from new.space_id then
    insert into public.item_location_history(
      item_id, from_space_id, from_location_id, to_space_id, to_location_id, moved_by, reason
    ) values (
      new.id, old.space_id, old.location_id, new.space_id, new.location_id, auth.uid(), 'item_updated'
    );
  end if;
  return new;
end;
$$;

drop trigger if exists record_item_location_change_trigger on public.items;
create trigger record_item_location_change_trigger after update on public.items
for each row execute procedure public.record_item_location_change();

create or replace function public.handle_location_soft_delete()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.deleted_at is null and new.deleted_at is not null then
    insert into public.item_location_recovery(item_id, location_id)
    select id, old.id from public.items where location_id = old.id and deleted_at is null
    on conflict (item_id, location_id) do nothing;
    update public.items set location_id = null, updated_at = now() where location_id = old.id and deleted_at is null;
  end if;
  return new;
end;
$$;

drop trigger if exists handle_location_soft_delete_trigger on public.locations;
create trigger handle_location_soft_delete_trigger after update on public.locations
for each row execute procedure public.handle_location_soft_delete();

create or replace function public.soft_delete_location(target_location_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare target_space uuid;
begin
  select space_id into target_space from public.locations where id = target_location_id;
  if not public.is_space_member(target_space, auth.uid()) then raise exception 'not_allowed'; end if;
  update public.locations
    set deleted_at = now(), delete_purge_at = now() + interval '30 days'
    where id = target_location_id and deleted_at is null;
end;
$$;

create or replace function public.restore_location(target_location_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare target_space uuid;
declare purge_at timestamptz;
begin
  select space_id, delete_purge_at into target_space, purge_at from public.locations where id = target_location_id;
  if not public.is_space_member(target_space, auth.uid()) then raise exception 'not_allowed'; end if;
  if purge_at is not null and purge_at <= now() then raise exception 'retention_period_expired'; end if;
  update public.locations set deleted_at = null, delete_purge_at = null where id = target_location_id;
  update public.items i set location_id = r.location_id, updated_at = now()
    from public.item_location_recovery r
    where r.location_id = target_location_id and r.item_id = i.id
      and i.location_id is null and i.deleted_at is null;
  update public.item_location_recovery set recovered_at = now() where location_id = target_location_id;
end;
$$;

create or replace function public.soft_delete_floor_plan(target_floor_plan_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare target_space uuid;
declare purge_at timestamptz;
begin
  select space_id, delete_purge_at into target_space, purge_at from public.floor_plans where id = target_floor_plan_id;
  if not public.is_space_member(target_space, auth.uid()) then raise exception 'not_allowed'; end if;
  if purge_at is not null and purge_at <= now() then raise exception 'retention_period_expired'; end if;
  update public.floor_plans set deleted_at = now(), delete_purge_at = now() + interval '30 days'
    where id = target_floor_plan_id and deleted_at is null;
  update public.locations set deleted_at = now(), delete_purge_at = now() + interval '30 days'
    where floor_plan_id = target_floor_plan_id and deleted_at is null;
end;
$$;

create or replace function public.restore_floor_plan(target_floor_plan_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare target_space uuid;
declare purge_at timestamptz;
begin
  select space_id, delete_purge_at into target_space, purge_at
    from public.floor_plans where id = target_floor_plan_id;
  if not public.is_space_member(target_space, auth.uid()) then raise exception 'not_allowed'; end if;
  if purge_at is null or purge_at <= now() then raise exception 'retention_period_expired'; end if;
  update public.floor_plans set deleted_at = null, delete_purge_at = null where id = target_floor_plan_id;
  update public.locations set deleted_at = null, delete_purge_at = null where floor_plan_id = target_floor_plan_id;
  update public.items i set location_id = r.location_id, updated_at = now()
    from public.item_location_recovery r
    join public.locations l on l.id = r.location_id
    where l.floor_plan_id = target_floor_plan_id and r.item_id = i.id
      and i.location_id is null and i.deleted_at is null;
  update public.item_location_recovery r set recovered_at = now()
    from public.locations l
    where r.location_id = l.id and l.floor_plan_id = target_floor_plan_id;
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
  if invite_row.id is null
     or invite_row.revoked_at is not null
     or invite_row.expires_at <= now()
     or (invite_row.max_uses is not null and invite_row.use_count >= invite_row.max_uses) then
    raise exception 'invite_invalid';
  end if;
  select count(*) into target_member_count from public.space_members where space_id = invite_row.space_id and deleted_at is null;
  if target_member_count >= 20 then raise exception 'space_member_limit_reached'; end if;
  insert into public.space_members(space_id, user_id, role)
  values (invite_row.space_id, auth.uid(), 'member')
  on conflict (space_id, user_id) do update set deleted_at = null;
  update public.space_invites set use_count = use_count + 1 where id = invite_row.id;
  return invite_row.space_id;
end;
$$;

create or replace function public.request_account_deletion()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles set deleted_at = now(), updated_at = now() where id = auth.uid();
end;
$$;

create or replace function public.restore_space(target_space_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare purge_at timestamptz;
begin
  select delete_purge_at into purge_at from public.spaces
    where id = target_space_id and deleted_at is not null;
  if not public.is_space_admin(target_space_id, auth.uid()) then raise exception 'not_allowed'; end if;
  if purge_at is null or purge_at <= now() then raise exception 'retention_period_expired'; end if;
  update public.spaces set deleted_at = null, delete_purge_at = null, updated_at = now()
    where id = target_space_id;
end;
$$;

create or replace function public.restore_item(target_item_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare target_space uuid;
declare purge_at timestamptz;
begin
  select space_id, delete_purge_at into target_space, purge_at from public.items
    where id = target_item_id and deleted_at is not null;
  if not public.is_space_member(target_space, auth.uid()) then raise exception 'not_allowed'; end if;
  if purge_at is null or purge_at <= now() then raise exception 'retention_period_expired'; end if;
  update public.items set deleted_at = null, delete_purge_at = null, updated_at = now()
    where id = target_item_id;
end;
$$;

create or replace function public.leave_space(target_space_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare current_role text;
declare other_admin_exists boolean;
begin
  select role into current_role from public.space_members
    where space_id = target_space_id and user_id = auth.uid() and deleted_at is null;
  if current_role is null then raise exception 'not_allowed'; end if;
  select exists (
    select 1 from public.space_members
      where space_id = target_space_id and role = 'admin'
        and user_id <> auth.uid() and deleted_at is null
  ) into other_admin_exists;
  if current_role = 'admin' and not other_admin_exists then
    raise exception 'last_admin_cannot_leave';
  end if;
  update public.space_members set deleted_at = now()
    where space_id = target_space_id and user_id = auth.uid() and deleted_at is null;
end;
$$;

grant execute on function public.accept_space_invite(text) to authenticated;
grant execute on function public.request_account_deletion() to authenticated;
grant execute on function public.leave_space(uuid) to authenticated;
grant execute on function public.soft_delete_location(uuid) to authenticated;
grant execute on function public.restore_location(uuid) to authenticated;
grant execute on function public.soft_delete_floor_plan(uuid) to authenticated;
grant execute on function public.restore_floor_plan(uuid) to authenticated;
grant execute on function public.restore_space(uuid) to authenticated;
grant execute on function public.restore_item(uuid) to authenticated;

do $$
declare table_name text;
begin
  foreach table_name in array array['profiles','spaces','floor_plans','locations','items','shopping_lists','shopping_items','checklist_templates','checklists','checklist_items','user_settings','user_devices'] loop
    execute format('drop trigger if exists %I_updated_at on public.%I', table_name, table_name);
    execute format('create trigger %I_updated_at before update on public.%I for each row execute procedure public.set_updated_at()', table_name, table_name);
  end loop;
end;
$$;

alter table public.profiles enable row level security;
alter table public.spaces enable row level security;
alter table public.space_members enable row level security;
alter table public.space_invites enable row level security;
alter table public.floor_plans enable row level security;
alter table public.locations enable row level security;
alter table public.categories enable row level security;
alter table public.items enable row level security;
alter table public.item_photos enable row level security;
alter table public.item_location_history enable row level security;
alter table public.item_location_recovery enable row level security;
alter table public.item_favorites enable row level security;
alter table public.shopping_lists enable row level security;
alter table public.shopping_items enable row level security;
alter table public.checklist_templates enable row level security;
alter table public.checklist_template_items enable row level security;
alter table public.checklists enable row level security;
alter table public.checklist_items enable row level security;
alter table public.checklist_member_checks enable row level security;
alter table public.user_settings enable row level security;
alter table public.user_devices enable row level security;
alter table public.app_notices enable row level security;
alter table public.app_config enable row level security;

drop policy if exists profile_self on public.profiles;
create policy profile_self on public.profiles for all using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists space_member_select on public.spaces;
create policy space_member_select on public.spaces for select using (public.is_space_member(id, auth.uid()));
drop policy if exists space_create on public.spaces;
create policy space_create on public.spaces for insert with check (created_by = auth.uid());
drop policy if exists space_admin_update on public.spaces;
create policy space_admin_update on public.spaces for update using (public.is_space_admin(id, auth.uid())) with check (public.is_space_admin(id, auth.uid()));

drop policy if exists member_select on public.space_members;
create policy member_select on public.space_members for select using (public.is_space_member(space_id, auth.uid()));
drop policy if exists member_admin_update on public.space_members;
create policy member_admin_update on public.space_members for update using (public.is_space_admin(space_id, auth.uid())) with check (public.is_space_admin(space_id, auth.uid()));
drop policy if exists member_self_update on public.space_members;
create policy member_self_update on public.space_members for update using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists invite_admin_all on public.space_invites;
create policy invite_admin_all on public.space_invites for all using (public.is_space_admin(space_id, auth.uid())) with check (public.is_space_admin(space_id, auth.uid()));

drop policy if exists floor_plan_member_all on public.floor_plans;
drop policy if exists floor_plan_member_select on public.floor_plans;
create policy floor_plan_member_select on public.floor_plans for select using (public.is_space_member(space_id, auth.uid()));
drop policy if exists floor_plan_member_insert on public.floor_plans;
create policy floor_plan_member_insert on public.floor_plans for insert with check (public.is_space_member(space_id, auth.uid()) and created_by = auth.uid());
drop policy if exists floor_plan_member_update on public.floor_plans;
create policy floor_plan_member_update on public.floor_plans for update using (public.is_space_member(space_id, auth.uid())) with check (public.is_space_member(space_id, auth.uid()));
drop policy if exists floor_plan_member_delete on public.floor_plans;
create policy floor_plan_member_delete on public.floor_plans for delete using (public.is_space_member(space_id, auth.uid()));

drop policy if exists location_member_all on public.locations;
drop policy if exists location_member_select on public.locations;
create policy location_member_select on public.locations for select using (public.is_space_member(space_id, auth.uid()));
drop policy if exists location_member_insert on public.locations;
create policy location_member_insert on public.locations for insert with check (public.is_space_member(space_id, auth.uid()) and created_by = auth.uid());
drop policy if exists location_member_update on public.locations;
create policy location_member_update on public.locations for update using (public.is_space_member(space_id, auth.uid())) with check (public.is_space_member(space_id, auth.uid()));
drop policy if exists location_member_delete on public.locations;
create policy location_member_delete on public.locations for delete using (public.is_space_member(space_id, auth.uid()));

drop policy if exists category_member_select on public.categories;
create policy category_member_select on public.categories for select using (space_id is null or public.is_space_member(space_id, auth.uid()));
drop policy if exists category_member_write on public.categories;
create policy category_member_write on public.categories for all using (space_id is not null and public.is_space_member(space_id, auth.uid())) with check (space_id is not null and public.is_space_member(space_id, auth.uid()) and created_by = auth.uid());

drop policy if exists item_visibility_select on public.items;
create policy item_visibility_select on public.items for select using (
  public.is_space_member(space_id, auth.uid())
  and (visibility = 'shared' or created_by = auth.uid() or owner_user_id = auth.uid())
);
drop policy if exists item_member_insert on public.items;
create policy item_member_insert on public.items for insert with check (
  public.is_space_member(space_id, auth.uid()) and created_by = auth.uid()
  and (visibility = 'shared' or owner_user_id = auth.uid() or owner_user_id is null)
);
drop policy if exists item_member_update on public.items;
create policy item_member_update on public.items for update using (
  public.is_space_member(space_id, auth.uid()) and (visibility = 'shared' or created_by = auth.uid() or owner_user_id = auth.uid())
) with check (
  public.is_space_member(space_id, auth.uid()) and (visibility = 'shared' or created_by = auth.uid() or owner_user_id = auth.uid())
);

drop policy if exists item_photo_visibility on public.item_photos;
create policy item_photo_visibility on public.item_photos for all using (
  exists (select 1 from public.items i where i.id = item_id and public.is_space_member(i.space_id, auth.uid()) and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid()))
) with check (
  exists (select 1 from public.items i where i.id = item_id and public.is_space_member(i.space_id, auth.uid()) and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid()))
);

drop policy if exists item_history_visibility on public.item_location_history;
create policy item_history_visibility on public.item_location_history for select using (
  exists (select 1 from public.items i where i.id = item_id and public.is_space_member(i.space_id, auth.uid()) and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid()))
);

drop policy if exists item_recovery_internal on public.item_location_recovery;
create policy item_recovery_internal on public.item_location_recovery for select using (
  exists (select 1 from public.items i where i.id = item_id and public.is_space_member(i.space_id, auth.uid()) and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid()))
);

drop policy if exists item_favorite_self on public.item_favorites;
create policy item_favorite_self on public.item_favorites for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists shopping_list_member on public.shopping_lists;
create policy shopping_list_member on public.shopping_lists for all using (public.is_space_member(space_id, auth.uid())) with check (public.is_space_member(space_id, auth.uid()));
drop policy if exists shopping_item_member on public.shopping_items;
drop policy if exists shopping_item_member_select on public.shopping_items;
create policy shopping_item_member_select on public.shopping_items for select using (public.is_space_member(space_id, auth.uid()));
drop policy if exists shopping_item_member_insert on public.shopping_items;
create policy shopping_item_member_insert on public.shopping_items for insert with check (public.is_space_member(space_id, auth.uid()) and created_by = auth.uid());
drop policy if exists shopping_item_member_update on public.shopping_items;
create policy shopping_item_member_update on public.shopping_items for update using (public.is_space_member(space_id, auth.uid())) with check (public.is_space_member(space_id, auth.uid()));
drop policy if exists shopping_item_member_delete on public.shopping_items;
create policy shopping_item_member_delete on public.shopping_items for delete using (public.is_space_member(space_id, auth.uid()));

drop policy if exists checklist_template_self on public.checklist_templates;
create policy checklist_template_self on public.checklist_templates for all using (owner_user_id is null or owner_user_id = auth.uid()) with check (owner_user_id is null or owner_user_id = auth.uid());
drop policy if exists checklist_template_item_visible on public.checklist_template_items;
create policy checklist_template_item_visible on public.checklist_template_items for all using (exists (select 1 from public.checklist_templates t where t.id = template_id and (t.owner_user_id is null or t.owner_user_id = auth.uid()))) with check (exists (select 1 from public.checklist_templates t where t.id = template_id and (t.owner_user_id is null or t.owner_user_id = auth.uid())));

drop policy if exists checklist_visible on public.checklists;
create policy checklist_visible on public.checklists for select using (
  created_by = auth.uid() or (visibility = 'shared' and space_id is not null and public.is_space_member(space_id, auth.uid()))
);
drop policy if exists checklist_insert on public.checklists;
create policy checklist_insert on public.checklists for insert with check (
  created_by = auth.uid() and (visibility = 'personal' or (visibility = 'shared' and public.is_space_member(space_id, auth.uid())))
);
drop policy if exists checklist_update on public.checklists;
create policy checklist_update on public.checklists for update using (created_by = auth.uid() or (visibility = 'shared' and public.is_space_member(space_id, auth.uid()))) with check (created_by = auth.uid() or (visibility = 'shared' and public.is_space_member(space_id, auth.uid())));

drop policy if exists checklist_item_visible on public.checklist_items;
create policy checklist_item_visible on public.checklist_items for all using (exists (select 1 from public.checklists c where c.id = checklist_id and (c.created_by = auth.uid() or (c.visibility = 'shared' and public.is_space_member(c.space_id, auth.uid()))))) with check (exists (select 1 from public.checklists c where c.id = checklist_id and (c.created_by = auth.uid() or (c.visibility = 'shared' and public.is_space_member(c.space_id, auth.uid())))));
drop policy if exists checklist_member_check_visible on public.checklist_member_checks;
create policy checklist_member_check_visible on public.checklist_member_checks for all using (user_id = auth.uid() or exists (select 1 from public.checklist_items ci join public.checklists c on c.id = ci.checklist_id where ci.id = checklist_item_id and c.visibility = 'shared' and public.is_space_member(c.space_id, auth.uid()))) with check (user_id = auth.uid());

drop policy if exists user_settings_self on public.user_settings;
create policy user_settings_self on public.user_settings for all using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists device_self on public.user_devices;
create policy device_self on public.user_devices for all using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists notices_visible on public.app_notices;
create policy notices_visible on public.app_notices for select using (is_active and (starts_at is null or starts_at <= now()) and (ends_at is null or ends_at > now()));
drop policy if exists config_visible on public.app_config;
create policy config_visible on public.app_config for select using (true);

insert into public.categories(id, name, is_system)
values
  ('00000000-0000-0000-0000-000000000001', '생활용품', true),
  ('00000000-0000-0000-0000-000000000002', '전자제품', true),
  ('00000000-0000-0000-0000-000000000003', '문서', true),
  ('00000000-0000-0000-0000-000000000004', '의류', true)
on conflict (id) do nothing;

insert into public.checklist_templates(id, template_type, name)
values
  ('00000000-0000-0000-0000-000000000101', 'system', '해외여행'),
  ('00000000-0000-0000-0000-000000000102', 'system', '국내여행'),
  ('00000000-0000-0000-0000-000000000103', 'system', '캠핑'),
  ('00000000-0000-0000-0000-000000000104', 'system', '출장'),
  ('00000000-0000-0000-0000-000000000105', 'system', '입원')
on conflict (id) do nothing;

insert into public.checklist_template_items(template_id, name, sort_order)
select template_id, item_name, item_order
from (values
  ('00000000-0000-0000-0000-000000000101'::uuid, '여권/신분증', 0::numeric),
  ('00000000-0000-0000-0000-000000000101'::uuid, '충전기', 1::numeric),
  ('00000000-0000-0000-0000-000000000101'::uuid, '상비약', 2::numeric),
  ('00000000-0000-0000-0000-000000000102'::uuid, '신분증', 0::numeric),
  ('00000000-0000-0000-0000-000000000102'::uuid, '세면도구', 1::numeric),
  ('00000000-0000-0000-0000-000000000103'::uuid, '랜턴', 0::numeric),
  ('00000000-0000-0000-0000-000000000103'::uuid, '버너/연료', 1::numeric),
  ('00000000-0000-0000-0000-000000000104'::uuid, '노트북/충전기', 0::numeric),
  ('00000000-0000-0000-0000-000000000104'::uuid, '출장 서류', 1::numeric),
  ('00000000-0000-0000-0000-000000000105'::uuid, '복용 약', 0::numeric),
  ('00000000-0000-0000-0000-000000000105'::uuid, '신분증', 1::numeric)
) as seed(template_id, item_name, item_order)
where not exists (
  select 1 from public.checklist_template_items existing
  where existing.template_id = seed.template_id
    and existing.name = seed.item_name
);

create index if not exists items_space_deleted_idx on public.items(space_id, deleted_at);
create index if not exists items_name_idx on public.items(name);
create index if not exists locations_space_name_idx on public.locations(space_id, name);
create index if not exists space_members_user_deleted_idx on public.space_members(user_id, deleted_at);
create index if not exists shopping_items_space_completed_idx on public.shopping_items(space_id, is_completed);
create index if not exists checklists_space_visibility_idx on public.checklists(space_id, visibility);

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table public.shopping_items;
    alter publication supabase_realtime add table public.checklist_items;
    alter publication supabase_realtime add table public.checklist_member_checks;
    alter publication supabase_realtime add table public.space_members;
  end if;
exception when duplicate_object then null;
end;
$$;

insert into storage.buckets(id, name, public)
values ('item-photos', 'item-photos', false)
on conflict (id) do update set public = false;

drop policy if exists item_photo_storage_select on storage.objects;
create policy item_photo_storage_select on storage.objects for select using (
  bucket_id = 'item-photos' and exists (
    select 1 from public.item_photos p
    join public.items i on i.id = p.item_id
    where p.storage_path = name and public.is_space_member(i.space_id, auth.uid()) and (i.visibility = 'shared' or i.created_by = auth.uid())
  )
);
drop policy if exists item_photo_storage_insert on storage.objects;
create policy item_photo_storage_insert on storage.objects for insert with check (
  bucket_id = 'item-photos' and (storage.foldername(name))[1] = auth.uid()::text
);
drop policy if exists item_photo_storage_delete on storage.objects;
create policy item_photo_storage_delete on storage.objects for delete using (
  bucket_id = 'item-photos' and exists (
    select 1 from public.item_photos p
    join public.items i on i.id = p.item_id
    where p.storage_path = name
      and public.is_space_member(i.space_id, auth.uid())
      and (i.visibility = 'shared' or i.created_by = auth.uid() or i.owner_user_id = auth.uid())
  )
);
