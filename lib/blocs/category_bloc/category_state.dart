part of 'category_bloc.dart';

enum GetAllCategoriesStatus { init, loading, failure, success }

enum CategoryTransactionStatus { init, loading, failure, success }

enum GetAllStoreCategoryStatus { init, loading, failure, success }

enum StoreCategoryTransactionStatus { init, loading, failure, success }

class CategoryState {
  final GetAllCategoriesStatus getAllCategoriesStatus;
  final CategoryTransactionStatus categoryTransactionStatus;
  final GetAllStoreCategoryStatus getAllStoreCategoryStatus;
  final StoreCategoryTransactionStatus storeCategoryTransactionStatus;

  final String errorMessage;

  final List<CategoryModel> categories;
  final List<StoreCategoryModel> storeCategories;

  CategoryState({
    this.getAllCategoriesStatus = GetAllCategoriesStatus.init,
    this.categoryTransactionStatus = CategoryTransactionStatus.init,
    this.getAllStoreCategoryStatus = GetAllStoreCategoryStatus.init,
    this.storeCategoryTransactionStatus =
        StoreCategoryTransactionStatus.init,
    this.errorMessage = '',
    this.categories = const [],
    this.storeCategories = const [],
  });

  CategoryState copyWith({
    GetAllCategoriesStatus? getAllCategoriesStatus,
    CategoryTransactionStatus? categoryTransactionStatus,
    GetAllStoreCategoryStatus? getAllStoreCategoryStatus,
    StoreCategoryTransactionStatus? storeCategoryTransactionStatus,
    String? errorMessage,
    List<CategoryModel>? categories,
    List<StoreCategoryModel>? storeCategories,
  }) {
    return CategoryState(
      getAllCategoriesStatus:
          getAllCategoriesStatus ?? this.getAllCategoriesStatus,
      categoryTransactionStatus:
          categoryTransactionStatus ?? this.categoryTransactionStatus,
      getAllStoreCategoryStatus:
          getAllStoreCategoryStatus ?? this.getAllStoreCategoryStatus,
      storeCategoryTransactionStatus:
          storeCategoryTransactionStatus ?? this.storeCategoryTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      storeCategories: storeCategories ?? this.storeCategories,
    );
  }
}
