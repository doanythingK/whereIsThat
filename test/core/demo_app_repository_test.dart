import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:where_is_that/core/data/demo_app_repository.dart';
import 'package:where_is_that/core/errors/app_exception.dart';

void main() {
  group('DemoAppRepository MVP invariants', () {
    test('creating a space also creates its first floor plan', () async {
      final repository = DemoAppRepository();

      final space = await repository.createSpace(
        name: '작업실',
        iconKey: 'office',
      );
      final plans = await repository.listFloorPlans(space.id);

      expect(plans, hasLength(1));
      expect(plans.single.name, '1층');
    });

    test(
      'deleting a location unassigns items and restore reconnects them',
      () async {
        final repository = DemoAppRepository();
        final plan = (await repository.listFloorPlans('demo-space')).single;
        final location = (await repository.listLocations(plan.id)).single;
        final before = (await repository.listItems('demo-space'))
            .singleWhere((item) => item.locationId == location.id);

        await repository.softDeleteLocation(location);
        final afterDelete = (await repository.listItems('demo-space'))
            .singleWhere((item) => item.id == before.id);
        expect(afterDelete.locationId, isNull);
        expect(await repository.listLocations(plan.id), isEmpty);

        await repository.restoreLocation(location);
        final afterRestore = (await repository.listItems('demo-space'))
            .singleWhere((item) => item.id == before.id);
        expect(afterRestore.locationId, location.id);
        expect(await repository.listLocations(plan.id), hasLength(1));
      },
    );

    test('floor plan optimistic concurrency rejects stale saves', () async {
      final repository = DemoAppRepository();
      final plan = (await repository.listFloorPlans('demo-space')).single;

      final saved = await repository.saveFloorPlan(
        plan.copyWith(name: '수정된 1층'),
        version: plan.version,
      );
      expect(saved.version, plan.version + 1);

      expect(
        repository.saveFloorPlan(plan, version: plan.version),
        throwsA(isA<ConflictException>()),
      );
    });

    test(
      'shopping and checklist actions persist their completion state',
      () async {
        final repository = DemoAppRepository();
        final shopping = await repository.addShoppingItem(
          spaceId: 'demo-space',
          name: '물티슈',
        );
        await repository.updateShoppingItem(
          shopping.copyWith(isCompleted: true, completedBy: 'demo-user'),
        );
        expect(
          (await repository.listShoppingItems('demo-space'))
              .singleWhere((item) => item.id == shopping.id)
              .isCompleted,
          isTrue,
        );

        final checklist = (await repository.listChecklists(
          spaceId: 'demo-space',
        )).single;
        final checklistItem = (await repository.listChecklistItems(
          checklist.id,
        )).single;
        await repository.toggleChecklistItem(checklistItem);
        expect(
          (await repository.listChecklistItems(checklist.id))
              .single
              .isFinalCompleted,
          isTrue,
        );
      },
    );

    test(
      'item photos are capped at three and categories are space scoped',
      () async {
        final repository = DemoAppRepository();
        final item = (await repository.listItems('demo-space')).first;
        var updated = item;
        for (var index = 0; index < 3; index++) {
          final photo = await repository.uploadItemPhoto(
            item: updated,
            bytes: Uint8List.fromList([index]),
            extension: 'jpg',
          );
          updated = updated.copyWith(photos: [...updated.photos, photo]);
        }
        expect(
          repository.uploadItemPhoto(
            item: updated,
            bytes: Uint8List.fromList([4]),
            extension: 'jpg',
          ),
          throwsA(isA<AppException>()),
        );

        final category = await repository.createCategory(
          spaceId: 'demo-space',
          name: '테스트 카테고리',
        );
        expect(
          (await repository.listCategories('demo-space'))
              .any((entry) => entry.id == category.id),
          isTrue,
        );
      },
    );

    test('system checklist templates are available', () async {
      final repository = DemoAppRepository();
      final templates = await repository.listChecklistTemplates();
      expect(templates, hasLength(5));
      final items = await repository.listChecklistTemplateItems(
        templates.first.id,
      );
      expect(items, isNotEmpty);
    });
  });
}
