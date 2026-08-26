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

        await repository.saveItem(
          afterRestore.copyWith(locationId: null),
          isNew: false,
        );
        await repository.softDeleteLocation(location);
        await repository.restoreLocation(location);
        expect(
          (await repository.listItems('demo-space'))
              .singleWhere((item) => item.id == before.id)
              .locationId,
          isNull,
        );
      },
    );

    test(
      'restoring a floor plan does not restore an independently deleted location',
      () async {
        final repository = DemoAppRepository();
        final firstPlan = (await repository.listFloorPlans('demo-space')).single;
        final secondPlan = await repository.createFloorPlan(
          spaceId: 'demo-space',
          name: '2층',
        );
        final firstLocation =
            (await repository.listLocations(firstPlan.id)).single;
        final secondLocation = await repository.saveLocation(
          firstLocation.copyWith(
            id: '',
            floorPlanId: secondPlan.id,
            name: '2층 수납장',
          ),
          isNew: true,
        );

        await repository.softDeleteLocation(secondLocation);
        await repository.softDeleteFloorPlan(secondPlan);
        await repository.restoreFloorPlan(secondPlan);

        expect(await repository.listLocations(secondPlan.id), isEmpty);
        expect(
          (await repository.listDeletedLocations('demo-space'))
              .any((location) => location.id == secondLocation.id),
          isTrue,
        );
      },
    );

    test('restoring an item clears a location deleted after the item', () async {
      final repository = DemoAppRepository();
      final location = (await repository.listLocations('demo-floor-plan')).single;
      final item = (await repository.listItems('demo-space'))
          .singleWhere((entry) => entry.locationId == location.id);

      await repository.softDeleteItem(item);
      await repository.softDeleteLocation(location);
      final deletedItem = (await repository.listDeletedItems('demo-space'))
          .singleWhere((entry) => entry.id == item.id);
      await repository.restoreItem(deletedItem);

      expect(
        (await repository.listItems('demo-space'))
            .singleWhere((entry) => entry.id == item.id)
            .locationId,
        isNull,
      );
    });

    test('moving an item clears a source-space category', () async {
      final repository = DemoAppRepository();
      final category = await repository.createCategory(
        spaceId: 'demo-space',
        name: '공간 전용 카테고리',
      );
      final item = (await repository.listItems('demo-space')).first;
      final categorized = await repository.saveItem(
        item.copyWith(categoryId: category.id),
        isNew: false,
      );
      final targetSpace = await repository.createSpace(
        name: '이동 공간',
        iconKey: 'storage',
      );

      final moved = await repository.moveItem(
        categorized,
        targetSpaceId: targetSpace.id,
      );

      expect(moved.categoryId, isNull);
    });

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

    test(
      'photo primary, user template, shortcuts, and invite lifecycle work',
      () async {
        final repository = DemoAppRepository();
        final item = (await repository.listItems('demo-space')).first;
        final first = await repository.uploadItemPhoto(
          item: item,
          bytes: Uint8List.fromList([1]),
          extension: 'jpg',
        );
        final withFirst = item.copyWith(photos: [first]);
        final second = await repository.uploadItemPhoto(
          item: withFirst,
          bytes: Uint8List.fromList([2]),
          extension: 'jpg',
        );
        await repository.setPrimaryItemPhoto(
          withFirst.copyWith(photos: [first, second]),
          second,
        );
        final photoItem = (await repository.listItems('demo-space'))
            .singleWhere((entry) => entry.id == item.id);
        expect(
          photoItem.photos
              .singleWhere((photo) => photo.id == second.id)
              .isPrimary,
          isTrue,
        );

        final template = await repository.createChecklistTemplate(
          name: '나만의 준비',
        );
        await repository.saveChecklistTemplateItem(
          templateId: template.id,
          name: '물병',
          sortOrder: 0,
        );
        expect(
          await repository.listChecklistTemplateItems(template.id),
          hasLength(1),
        );

        await repository.saveHomeShortcuts([
          'items',
          'more',
          'shopping',
          'checklist',
          'extra',
        ]);
        expect(await repository.getHomeShortcuts(), [
          'items',
          'more',
          'shopping',
          'checklist',
        ]);

        final invite = await repository.createInvite(
          'demo-space',
          const Duration(days: 1),
        );
        expect((await repository.listInvites('demo-space')), contains(invite));
        await repository.revokeInvite(invite);
        expect(
          (await repository.listInvites('demo-space'))
              .singleWhere((entry) => entry.id == invite.id)
              .revokedAt,
          isNotNull,
        );
      },
    );
  });
}
