part of 'store_follower_bloc.dart';

@immutable
sealed class StoreFollowerEvent {}

/// PUT StoreFollower/StoreFollow - toggles follow/unfollow for the given store
class ToggleStoreFollowEvent extends StoreFollowerEvent {
  final int storeId;

  ToggleStoreFollowEvent({required this.storeId});
}

/// GET StoreFollower/GetProductsByFollowerStores
class GetProductsByFollowerStoresEvent extends StoreFollowerEvent {}

/// GET StoreFollower/GetStoreFollowByUser - the stores the signed-in
/// customer follows.
class GetFollowedStoresEvent extends StoreFollowerEvent {}

/// GET StoreFollower/GetStoreFollowersCount
class GetStoreFollowersCountEvent extends StoreFollowerEvent {
  final int storeId;

  GetStoreFollowersCountEvent({required this.storeId});
}
