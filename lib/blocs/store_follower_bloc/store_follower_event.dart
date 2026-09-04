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

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearStoreFollowerEvent extends StoreFollowerEvent {}
