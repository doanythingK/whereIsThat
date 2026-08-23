import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import 'app_repository.dart';

final appRepositoryProvider = Provider<AppRepository>(
  (ref) => throw StateError('AppRepository override is missing.'),
);

final currentUserProvider = FutureProvider<AppUser?>((ref) {
  return ref.watch(appRepositoryProvider).currentUser();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(appRepositoryProvider).watchAuthState();
});

final spacesProvider = FutureProvider<List<Space>>((ref) {
  return ref.watch(appRepositoryProvider).listSpaces();
});

final deletedSpacesProvider = FutureProvider<List<Space>>((ref) {
  return ref.watch(appRepositoryProvider).listDeletedSpaces();
});

final noticesProvider = FutureProvider<List<AppNotice>>((ref) {
  return ref.watch(appRepositoryProvider).listNotices();
});

final floorPlansProvider = FutureProvider.family<List<FloorPlan>, String>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listFloorPlans(spaceId);
});

final deletedFloorPlansProvider =
    FutureProvider.family<List<FloorPlan>, String>((ref, spaceId) {
      return ref.watch(appRepositoryProvider).listDeletedFloorPlans(spaceId);
    });

final locationsProvider = FutureProvider.family<List<Location>, String>((
  ref,
  floorPlanId,
) {
  return ref.watch(appRepositoryProvider).listLocations(floorPlanId);
});

final deletedLocationsProvider = FutureProvider.family<List<Location>, String>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listDeletedLocations(spaceId);
});

final categoriesProvider = FutureProvider.family<List<Category>, String>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listCategories(spaceId);
});

final itemsProvider =
    FutureProvider.family<List<Item>, ({String spaceId, String? search})>((
      ref,
      args,
    ) {
      return ref
          .watch(appRepositoryProvider)
          .listItems(args.spaceId, search: args.search);
    });

final deletedItemsProvider = FutureProvider.family<List<Item>, String>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listDeletedItems(spaceId);
});

final itemLocationHistoryProvider =
    FutureProvider.family<List<ItemLocationHistory>, String>((ref, itemId) {
      return ref.watch(appRepositoryProvider).listItemLocationHistory(itemId);
    });

final shoppingItemsProvider = FutureProvider.family<List<ShoppingItem>, String>(
  (ref, spaceId) {
    return ref.watch(appRepositoryProvider).listShoppingItems(spaceId);
  },
);

final shoppingItemsStreamProvider =
    StreamProvider.family<List<ShoppingItem>, String>((ref, spaceId) {
      return ref.watch(appRepositoryProvider).watchShoppingItems(spaceId);
    });

final checklistsProvider = FutureProvider.family<List<Checklist>, String?>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listChecklists(spaceId: spaceId);
});

final checklistTemplatesProvider = FutureProvider<List<ChecklistTemplate>>((
  ref,
) {
  return ref.watch(appRepositoryProvider).listChecklistTemplates();
});

final checklistTemplateItemsProvider =
    FutureProvider.family<List<ChecklistTemplateItem>, String>((
      ref,
      templateId,
    ) {
      return ref
          .watch(appRepositoryProvider)
          .listChecklistTemplateItems(templateId);
    });

final checklistItemsProvider =
    FutureProvider.family<List<ChecklistItem>, String>((ref, checklistId) {
      return ref.watch(appRepositoryProvider).listChecklistItems(checklistId);
    });

final checklistItemsStreamProvider =
    StreamProvider.family<List<ChecklistItem>, String>((ref, checklistId) {
      return ref.watch(appRepositoryProvider).watchChecklistItems(checklistId);
    });

final memberChecksProvider =
    FutureProvider.family<List<ChecklistMemberCheck>, String>(
      (ref, checklistItemId) =>
          ref.watch(appRepositoryProvider).listMemberChecks(checklistItemId),
    );

final spaceMembersProvider = FutureProvider.family<List<SpaceMember>, String>((
  ref,
  spaceId,
) {
  return ref.watch(appRepositoryProvider).listMembers(spaceId);
});

final workspaceActionsProvider = Provider<WorkspaceActions>(
  (ref) => WorkspaceActions(ref),
);

class WorkspaceActions {
  WorkspaceActions(this.ref);

  final Ref ref;

  AppRepository get _repository => ref.read(appRepositoryProvider);

  Future<Space> createSpace({
    required String name,
    required String iconKey,
    String? iconColor,
  }) async {
    final space = await _repository.createSpace(
      name: name,
      iconKey: iconKey,
      iconColor: iconColor,
    );
    ref.invalidate(spacesProvider);
    ref.invalidate(floorPlansProvider(space.id));
    return space;
  }

  Future<void> updateSpace(Space space) async {
    await _repository.updateSpace(space);
    ref.invalidate(spacesProvider);
  }

  Future<void> deleteSpace(Space space) async {
    await _repository.softDeleteSpace(space);
    ref.invalidate(spacesProvider);
    ref.invalidate(deletedSpacesProvider);
  }

  Future<void> revokeInvite(SpaceInvite invite) async {
    await _repository.revokeInvite(invite);
  }

  Future<SpaceInvite> createInvite(
    String spaceId, {
    Duration validity = const Duration(days: 7),
  }) => _repository.createInvite(spaceId, validity);

  Future<void> updateMemberRole(SpaceMember member, String role) async {
    await _repository.updateMemberRole(member, role);
    ref.invalidate(spaceMembersProvider(member.spaceId));
  }

  Future<void> updateMemberDisplayName(
    SpaceMember member,
    String displayName,
  ) async {
    await _repository.updateMemberDisplayName(member, displayName);
    ref.invalidate(spaceMembersProvider(member.spaceId));
  }

  Future<void> restoreSpace(Space space) async {
    await _repository.restoreSpace(space);
    ref.invalidate(spacesProvider);
    ref.invalidate(deletedSpacesProvider);
  }

  Future<String> acceptInvite(String code) async {
    final spaceId = await _repository.acceptInvite(code);
    ref.invalidate(spacesProvider);
    return spaceId;
  }

  Future<void> leaveSpace(String spaceId) async {
    await _repository.leaveSpace(spaceId);
    ref.invalidate(spacesProvider);
  }

  Future<void> accessSpace(String spaceId) async {
    await _repository.updateLastAccessed(spaceId);
    ref.invalidate(spacesProvider);
  }

  Future<FloorPlan> createFloorPlan({
    required String spaceId,
    required String name,
  }) async {
    final plan = await _repository.createFloorPlan(
      spaceId: spaceId,
      name: name,
    );
    ref.invalidate(floorPlansProvider(spaceId));
    return plan;
  }

  Future<FloorPlan> saveFloorPlan(
    FloorPlan plan, {
    required int version,
  }) async {
    final saved = await _repository.saveFloorPlan(plan, version: version);
    ref.invalidate(floorPlansProvider(plan.spaceId));
    ref.invalidate(locationsProvider(plan.id));
    return saved;
  }

  Future<void> deleteFloorPlan(FloorPlan plan) async {
    await _repository.softDeleteFloorPlan(plan);
    ref.invalidate(floorPlansProvider(plan.spaceId));
    ref.invalidate(locationsProvider(plan.id));
    ref.invalidate(itemsProvider((spaceId: plan.spaceId, search: null)));
    ref.invalidate(deletedFloorPlansProvider(plan.spaceId));
  }

  Future<void> restoreFloorPlan(FloorPlan plan) async {
    await _repository.restoreFloorPlan(plan);
    ref.invalidate(floorPlansProvider(plan.spaceId));
    ref.invalidate(locationsProvider(plan.id));
    ref.invalidate(itemsProvider((spaceId: plan.spaceId, search: null)));
    ref.invalidate(deletedFloorPlansProvider(plan.spaceId));
  }

  Future<Location> saveLocation(
    Location location, {
    required bool isNew,
  }) async {
    final saved = await _repository.saveLocation(location, isNew: isNew);
    ref.invalidate(locationsProvider(location.floorPlanId));
    return saved;
  }

  Future<void> deleteLocation(Location location) async {
    await _repository.softDeleteLocation(location);
    ref.invalidate(locationsProvider(location.floorPlanId));
    ref.invalidate(itemsProvider((spaceId: location.spaceId, search: null)));
    ref.invalidate(deletedLocationsProvider(location.spaceId));
  }

  Future<void> restoreLocation(Location location) async {
    await _repository.restoreLocation(location);
    ref.invalidate(locationsProvider(location.floorPlanId));
    ref.invalidate(itemsProvider((spaceId: location.spaceId, search: null)));
    ref.invalidate(deletedLocationsProvider(location.spaceId));
  }

  Future<Category> createCategory({
    required String spaceId,
    required String name,
  }) async {
    final category = await _repository.createCategory(
      spaceId: spaceId,
      name: name,
    );
    ref.invalidate(categoriesProvider(spaceId));
    return category;
  }

  Future<void> deleteCategory(Category category) async {
    await _repository.deleteCategory(category);
    if (category.spaceId != null) {
      ref.invalidate(categoriesProvider(category.spaceId!));
    }
  }

  Future<Item> saveItem(Item item, {required bool isNew}) async {
    final saved = await _repository.saveItem(item, isNew: isNew);
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
    return saved;
  }

  Future<void> deleteItem(Item item) async {
    await _repository.softDeleteItem(item);
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
    ref.invalidate(deletedItemsProvider(item.spaceId));
  }

  Future<void> restoreItem(Item item) async {
    await _repository.restoreItem(item);
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
    ref.invalidate(deletedItemsProvider(item.spaceId));
  }

  Future<void> toggleFavorite(Item item) async {
    await _repository.toggleFavorite(item);
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
  }

  Future<Item> moveItem(
    Item item, {
    required String targetSpaceId,
    String? targetLocationId,
  }) async {
    final moved = await _repository.moveItem(
      item,
      targetSpaceId: targetSpaceId,
      targetLocationId: targetLocationId,
    );
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
    ref.invalidate(itemsProvider((spaceId: targetSpaceId, search: null)));
    ref.invalidate(itemLocationHistoryProvider(item.id));
    return moved;
  }

  Future<ItemPhoto> uploadItemPhoto({
    required Item item,
    required Uint8List bytes,
    required String extension,
  }) async {
    final photo = await _repository.uploadItemPhoto(
      item: item,
      bytes: bytes,
      extension: extension,
    );
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
    return photo;
  }

  Future<void> deleteItemPhoto(Item item, ItemPhoto photo) async {
    await _repository.deleteItemPhoto(item, photo);
    ref.invalidate(itemsProvider((spaceId: item.spaceId, search: null)));
  }

  Future<String> createItemPhotoSignedUrl(ItemPhoto photo) =>
      _repository.createItemPhotoSignedUrl(photo);

  Future<ShoppingItem> addShoppingItem({
    required String spaceId,
    required String name,
  }) async {
    final item = await _repository.addShoppingItem(
      spaceId: spaceId,
      name: name,
    );
    ref.invalidate(shoppingItemsProvider(spaceId));
    ref.invalidate(shoppingItemsStreamProvider(spaceId));
    return item;
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    await _repository.updateShoppingItem(item);
    ref.invalidate(shoppingItemsProvider(item.spaceId));
    ref.invalidate(shoppingItemsStreamProvider(item.spaceId));
  }

  Future<void> deleteShoppingItem(ShoppingItem item) async {
    await _repository.deleteShoppingItem(item);
    ref.invalidate(shoppingItemsProvider(item.spaceId));
    ref.invalidate(shoppingItemsStreamProvider(item.spaceId));
  }

  Future<Checklist> createChecklist({
    String? spaceId,
    required String name,
    required String visibility,
  }) async {
    final checklist = await _repository.createChecklist(
      spaceId: spaceId,
      name: name,
      visibility: visibility,
    );
    ref.invalidate(checklistsProvider(spaceId));
    return checklist;
  }

  Future<ChecklistItem> saveChecklistItem(
    ChecklistItem item, {
    required bool isNew,
  }) async {
    final saved = await _repository.saveChecklistItem(item, isNew: isNew);
    ref.invalidate(checklistItemsProvider(item.checklistId));
    ref.invalidate(checklistItemsStreamProvider(item.checklistId));
    return saved;
  }

  Future<void> toggleChecklistItem(ChecklistItem item) async {
    await _repository.toggleChecklistItem(item);
    ref.invalidate(checklistItemsProvider(item.checklistId));
    ref.invalidate(checklistItemsStreamProvider(item.checklistId));
  }

  Future<void> toggleMemberCheck(ChecklistMemberCheck check) async {
    await _repository.toggleMemberCheck(check);
    ref.invalidate(memberChecksProvider(check.checklistItemId));
  }

  Future<void> completeChecklist(
    Checklist checklist, {
    required bool complete,
  }) async {
    await _repository.completeChecklist(checklist, complete: complete);
    ref.invalidate(checklistsProvider(checklist.spaceId));
  }
}
