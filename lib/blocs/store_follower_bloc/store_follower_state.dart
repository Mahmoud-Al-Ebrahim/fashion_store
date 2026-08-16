part of 'store_follower_bloc.dart';

enum ToggleStoreFollowStatus { init, loading, failure, success }

enum GetProductsByFollowerStoresStatus { init, loading, failure, success }

enum GetStoreFollowersCountStatus { init, loading, failure, success }

class StoreFollowerState {
  final ToggleStoreFollowStatus toggleStoreFollowStatus;
  final GetProductsByFollowerStoresStatus getProductsByFollowerStoresStatus;
  final GetStoreFollowersCountStatus getStoreFollowersCountStatus;

  final String errorMessage;

  final StoreFollowModel? storeFollow;
  final List<ProductCatalogModel> followedStoresProducts;
  final int followersCount;

  StoreFollowerState({
    this.toggleStoreFollowStatus = ToggleStoreFollowStatus.init,
    this.getProductsByFollowerStoresStatus =
        GetProductsByFollowerStoresStatus.init,
    this.getStoreFollowersCountStatus = GetStoreFollowersCountStatus.init,
    this.errorMessage = '',
    this.storeFollow,
    this.followedStoresProducts = const [],
    this.followersCount = 0,
  });

  StoreFollowerState copyWith({
    ToggleStoreFollowStatus? toggleStoreFollowStatus,
    GetProductsByFollowerStoresStatus? getProductsByFollowerStoresStatus,
    GetStoreFollowersCountStatus? getStoreFollowersCountStatus,
    String? errorMessage,
    StoreFollowModel? storeFollow,
    List<ProductCatalogModel>? followedStoresProducts,
    int? followersCount,
  }) {
    return StoreFollowerState(
      toggleStoreFollowStatus:
          toggleStoreFollowStatus ?? this.toggleStoreFollowStatus,
      getProductsByFollowerStoresStatus: getProductsByFollowerStoresStatus ??
          this.getProductsByFollowerStoresStatus,
      getStoreFollowersCountStatus:
          getStoreFollowersCountStatus ?? this.getStoreFollowersCountStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      storeFollow: storeFollow ?? this.storeFollow,
      followedStoresProducts:
          followedStoresProducts ?? this.followedStoresProducts,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
