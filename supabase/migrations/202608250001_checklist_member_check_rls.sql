-- Stabilize per-member checklist checks after the MVP hardening migration.
-- A shared member may read every member's check, but may only write or remove
-- their own row.

drop policy if exists checklist_member_check_visible
  on public.checklist_member_checks;
drop policy if exists checklist_member_check_select
  on public.checklist_member_checks;
drop policy if exists checklist_member_check_insert
  on public.checklist_member_checks;
drop policy if exists checklist_member_check_update
  on public.checklist_member_checks;
drop policy if exists checklist_member_check_delete
  on public.checklist_member_checks;

create policy checklist_member_check_select
on public.checklist_member_checks
for select using (
  user_id = auth.uid()
  or exists (
    select 1
    from public.checklist_items ci
    join public.checklists c on c.id = ci.checklist_id
    where ci.id = checklist_item_id
      and c.visibility = 'shared'
      and public.is_space_member(c.space_id, auth.uid())
  )
);

create policy checklist_member_check_insert
on public.checklist_member_checks
for insert with check (
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

create policy checklist_member_check_update
on public.checklist_member_checks
for update
using (
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

create policy checklist_member_check_delete
on public.checklist_member_checks
for delete using (user_id = auth.uid());
