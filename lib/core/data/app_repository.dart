import 'dart:typed_data';

import '../models/app_models.dart';

enum SocialProvider { kakao, naver, google, apple }

abstract interface class AppRepository {
  bool get isDemoMode;
  AppUser? get signedInUser;

  Future<AppUser?> currentUser();
  Stream<AppUser?> watchAuthState();
  Future<void> signIn(SocialProvider provider);
  Future<void> linkIdentity(SocialProvider provider);
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> registerDevice({
    required String platform,
    required String token,
    String? appVersion,
  });
  Future<List<AppNotice>> listNotices();
  Future<String> acceptInvite(String code);

  Future<List<Space>> listSpaces();
  Future<List<Space>> listDeletedSpaces();
  Future<Space> createSpace({
    required String name,
    required String iconKey,
    String? iconColor,
  });
  Future<void> updateSpace(Space space);
  Future<void> softDeleteSpace(Space space);
  Future<void> restoreSpace(Space space);
  Future<List<SpaceMember>> listMembers(String spaceId);
  Future<void> updateMemberRole(SpaceMember member, String role);
  Future<void> updateMemberDisplayName(SpaceMember member, String displayName);
  Future<SpaceInvite> createInvite(String spaceId, Duration validity);
  Future<void> revokeInvite(SpaceInvite invite);
  Future<void> leaveSpace(String spaceId);
  Future<void> updateLastAccessed(String spaceId);

  Future<List<FloorPlan>> listFloorPlans(String spaceId);
  Future<List<FloorPlan>> listDeletedFloorPlans(String spaceId);
  Future<FloorPlan> createFloorPlan({
    required String spaceId,
    required String name,
  });
  Future<FloorPlan> saveFloorPlan(FloorPlan floorPlan, {required int version});
  Future<void> softDeleteFloorPlan(FloorPlan floorPlan);
  Future<void> restoreFloorPlan(FloorPlan floorPlan);

  Future<List<Location>> listLocations(String floorPlanId);
  Future<List<Location>> listDeletedLocations(String spaceId);
  Future<Location> saveLocation(Location location, {required bool isNew});
  Future<void> softDeleteLocation(Location location);
  Future<void> restoreLocation(Location location);

  Future<List<Category>> listCategories(String spaceId);
  Future<Category> createCategory({
    required String spaceId,
    required String name,
  });
  Future<void> deleteCategory(Category category);
  Future<List<Item>> listItems(String spaceId, {String? search});
  Future<List<Item>> listDeletedItems(String spaceId);
  Future<Item> saveItem(Item item, {required bool isNew});
  Future<void> softDeleteItem(Item item);
  Future<void> restoreItem(Item item);
  Future<void> toggleFavorite(Item item);
  Future<Item> moveItem(
    Item item, {
    required String targetSpaceId,
    String? targetLocationId,
  });
  Future<List<ItemLocationHistory>> listItemLocationHistory(String itemId);
  Future<ItemPhoto> uploadItemPhoto({
    required Item item,
    required Uint8List bytes,
    required String extension,
  });
  Future<void> deleteItemPhoto(Item item, ItemPhoto photo);
  Future<String> createItemPhotoSignedUrl(ItemPhoto photo);

  Future<List<ShoppingItem>> listShoppingItems(String spaceId);
  Future<ShoppingItem> addShoppingItem({
    required String spaceId,
    required String name,
  });
  Future<void> updateShoppingItem(ShoppingItem item);
  Future<void> deleteShoppingItem(ShoppingItem item);

  Future<List<Checklist>> listChecklists({String? spaceId});
  Future<List<ChecklistTemplate>> listChecklistTemplates();
  Future<List<ChecklistTemplateItem>> listChecklistTemplateItems(
    String templateId,
  );
  Future<List<ChecklistItem>> listChecklistItems(String checklistId);
  Future<Checklist> createChecklist({
    String? spaceId,
    required String name,
    required String visibility,
  });
  Future<ChecklistItem> saveChecklistItem(
    ChecklistItem item, {
    required bool isNew,
  });
  Future<void> toggleChecklistItem(ChecklistItem item);
  Future<List<ChecklistMemberCheck>> listMemberChecks(String checklistItemId);
  Future<void> toggleMemberCheck(ChecklistMemberCheck check);
  Future<void> completeChecklist(Checklist checklist, {required bool complete});

  Stream<List<ShoppingItem>> watchShoppingItems(String spaceId);
  Stream<List<ChecklistItem>> watchChecklistItems(String checklistId);
}
