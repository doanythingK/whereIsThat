import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MVP migration keeps the security and retention contracts', () {
    final sql = File('supabase/migrations/202608230001_mvp.sql')
        .readAsStringSync();

    expect(sql, contains('alter table public.items enable row level security'));
    expect(sql, contains('item_visibility_select'));
    expect(sql, contains("visibility = 'shared'"));
    expect(sql, contains("bucket_id = 'item-photos'"));
    expect(sql, contains("interval '30 days'"));
    expect(sql, contains('space_requires_one_floor_plan'));
    expect(sql, contains('accept_space_invite'));
    expect(sql, contains('restore_space(target_space_id uuid)'));
    expect(sql, contains('restore_item(target_item_id uuid)'));
    expect(sql, contains('retention_period_expired'));
    expect(sql, isNot(contains('SUPABASE_SERVICE_ROLE_KEY')));
  });
}
