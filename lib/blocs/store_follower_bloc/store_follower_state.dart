part of 'store_follower_bloc.dart';

enum ToggleStoreFollowStatus { init, loading, failure, success }

enum GetProductsByFollowerStoresStatus { init, loading, failure, success }

enum GetStoreFollowersCountStatus { init, loading, failure, success }

enum GetFollowedStoresStatus { init, loading, failure, success }

class StoreFollowerState {
  final ToggleStoreFollowStatus toggleStoreFollowStatus;
  final GetProductsByFollowerStoresStatus getProductsByFollowerStoresStatus;
  final GetStoreFollowersCountStatus getStoreFollowersCountStatus;
  final GetFollowedStoresStatus getFollowedStoresStatus;

  final String errorMessage;

  final StoreFollowModel? storeFollow;
  final List<ProductCatalogModel> followedStoresProducts;
  final int followersCount;

  /// Stores the signed-in customer follows.
  final List<StoreModel> followedStores;

  StoreFollowerState({
    this.toggleStoreFollowStatus = ToggleStoreFollowStatus.init,
    this.getProductsByFollowerStoresStatus =
        GetProductsByFollowerStoresStatus.init,
    this.getStoreFollowersCountStatus = GetStoreFollowersCountStatus.init,
    this.getFollowedStoresStatus = GetFollowedStoresStatus.init,
    this.errorMessage = '',
    this.storeFollow,
    this.followedStoresProducts = const [],
    this.followersCount = 0,
    this.followedStores = const [],
  });

  StoreFollowerState copyWith({
    ToggleStoreFollowStatus? toggleStoreFollowStatus,
    GetProductsByFollowerStoresStatus? getProductsByFollowerStoresStatus,
    GetStoreFollowersCountStatus? getStoreFollowersCountStatus,
    GetFollowedStoresStatus? getFollowedStoresStatus,
    String? errorMessage,
    StoreFollowModel? storeFollow,
    List<ProductCatalogModel>? followedStoresProducts,
    int? followersCount,
    List<StoreModel>? followedStores,
  }) {
    return StoreFollowerState(
      toggleStoreFollowStatus:
          toggleStoreFollowStatus ?? this.toggleStoreFollowStatus,
      getProductsByFollowerStoresStatus:
          getProductsByFollowerStoresStatus ??
          this.getProductsByFollowerStoresStatus,
      getStoreFollowersCountStatus:
          getStoreFollowersCountStatus ?? this.getStoreFollowersCountStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      storeFollow: storeFollow ?? this.storeFollow,
      followedStoresProducts:
          followedStoresProducts ?? this.followedStoresProducts,
      followersCount: followersCount ?? this.followersCount,
      getFollowedStoresStatus:
          getFollowedStoresStatus ?? this.getFollowedStoresStatus,
      followedStores: followedStores ?? this.followedStores,
    );
  }
}
