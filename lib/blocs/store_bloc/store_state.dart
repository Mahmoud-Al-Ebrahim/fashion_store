part of 'store_bloc.dart';

enum GetAllStoresStatus { init, loading, failure, success }

enum GetStoreByAdminStatus { init, loading, failure, success }

enum GetAllProductsByStoreStatus { init, loading, failure, success }

enum StoreTransactionStatus { init, loading, failure, success }

class StoreState {
  final GetAllStoresStatus getAllStoresStatus;
  final GetStoreByAdminStatus getStoreByAdminStatus;
  final GetAllProductsByStoreStatus getAllProductsByStoreStatus;
  final StoreTransactionStatus storeTransactionStatus;

  final String errorMessage;

  final List<StoreModel> stores;
  final StoreDetailModel? myStore;
  final List<StoreProductModel> storeProducts;

  StoreState({
    this.getAllStoresStatus = GetAllStoresStatus.init,
    this.getStoreByAdminStatus = GetStoreByAdminStatus.init,
    this.getAllProductsByStoreStatus = GetAllProductsByStoreStatus.init,
    this.storeTransactionStatus = StoreTransactionStatus.init,
    this.errorMessage = '',
    this.stores = const [],
    this.myStore,
    this.storeProducts = const [],
  });

  StoreState copyWith({
    GetAllStoresStatus? getAllStoresStatus,
    GetStoreByAdminStatus? getStoreByAdminStatus,
    GetAllProductsByStoreStatus? getAllProductsByStoreStatus,
    StoreTransactionStatus? storeTransactionStatus,
    String? errorMessage,
    List<StoreModel>? stores,
    StoreDetailModel? myStore,
    List<StoreProductModel>? storeProducts,
  }) {
    return StoreState(
      getAllStoresStatus: getAllStoresStatus ?? this.getAllStoresStatus,
      getStoreByAdminStatus:
          getStoreByAdminStatus ?? this.getStoreByAdminStatus,
      getAllProductsByStoreStatus:
          getAllProductsByStoreStatus ?? this.getAllProductsByStoreStatus,
      storeTransactionStatus:
          storeTransactionStatus ?? this.storeTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      stores: stores ?? this.stores,
      myStore: myStore ?? this.myStore,
      storeProducts: storeProducts ?? this.storeProducts,
    );
  }
}
