part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

/// GET Category/GetAll
class GetAllCategoriesEvent extends CategoryEvent {}

/// POST Category/Add (SuperAdmin)
class AddCategoryEvent extends CategoryEvent {
  final String name;

  AddCategoryEvent({required this.name});
}

/// DELETE Category/Delete/{categoryId} (SuperAdmin)
class DeleteCategoryEvent extends CategoryEvent {
  final int categoryId;

  DeleteCategoryEvent({required this.categoryId});
}

/// GET StoreCategory/GetAllStoreCategoryByAdmin (store owner)
class GetAllStoreCategoryByAdminEvent extends CategoryEvent {}

/// POST StoreCategory/Add (store owner - assigns a global category to their store)
class AddStoreCategoryEvent extends CategoryEvent {
  final int categoryId;

  AddStoreCategoryEvent({required this.categoryId});
}

/// DELETE StoreCategory/Delete/{storeCategoryId} (store owner)
class DeleteStoreCategoryEvent extends CategoryEvent {
  final int storeCategoryId;

  DeleteStoreCategoryEvent({required this.storeCategoryId});
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearCategoryEvent extends CategoryEvent {}
