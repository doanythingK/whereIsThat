import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MVP migration keeps the security and retention contracts', () {
    final sql = File('supabase/migrations/202608230001_mvp.sql')
        .readAsStringSync();
    final hardeningSql = File(
      'supabase/migrations/202608240001_mvp_hardening.sql',
    ).readAsStringSync();
    final checklistRlsSql = File(
      'supabase/migrations/202608250001_checklist_member_check_rls.sql',
    ).readAsStringSync();
    final stabilizationSql = File(
      'supabase/migrations/202608260001_stabilization.sql',
    ).readAsStringSync();

    expect(sql, contains('alter table public.items enable row level security'));
    expect(sql, contains('item_visibility_select'));
    expect(sql, contains("visibility = 'shared'"));
    expect(sql, contains("bucket_id = 'item-photos'"));
    expect(sql, contains("interval '30 days'"));
    expect(sql, contains('space_requires_one_floor_plan'));
    expect(sql, contains('accept_space_invite'));
    expect(sql, contains('restore_space(target_space_id uuid)'));
    expect(sql, contains('restore_item(target_item_id uuid)'));
    expect(sql, contains('set_item_primary_photo('));
    expect(
      sql,
      contains("personal_data_action not in ('keep', 'delete', 'move')"),
    );
    expect(sql, contains('restore_account()'));
    expect(sql, contains('where id = target_user_id and deleted_at is null'));
    expect(sql, contains('validate_private_item_owner_trigger'));
    expect(sql, contains('notification_events'));
    expect(sql, contains('queue_shopping_notification_trigger'));
    expect(sql, contains('queue_checklist_notification_trigger'));
    expect(sql, contains('queue_checklist_member_notification_trigger'));
    expect(sql, contains('retention_period_expired'));
    expect(sql, isNot(contains('SUPABASE_SERVICE_ROLE_KEY')));
    expect(hardeningSql, contains('restore_account()'));
    expect(hardeningSql, contains('notification_events'));
    expect(hardeningSql, contains('item_photo_storage_select'));
    expect(hardeningSql, isNot(contains('SUPABASE_SERVICE_ROLE_KEY')));
    expect(checklistRlsSql, contains('checklist_member_check_select'));
    expect(checklistRlsSql, contains('checklist_member_check_update'));
    expect(checklistRlsSql, contains('checklist_member_check_delete'));
    expect(stabilizationSql, contains('soft_delete_floor_plan'));
    expect(stabilizationSql, contains('deleted_at = deletion_at'));
    expect(stabilizationSql, contains('floor_plan_deleted'));
    expect(stabilizationSql, contains('version = version + 1'));
    expect(stabilizationSql, contains('target_visibility = \'shared\''));
    expect(stabilizationSql, contains('recovered_at is null'));
    expect(stabilizationSql, contains('recovered_at is not null'));
  });
}
