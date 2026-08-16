/// Response model for `PUT StoreFollower/StoreFollow` -> `data`.
/// The endpoint toggles the follow relationship; [isFollow] reflects the
/// state *after* the toggle.
class StoreFollowModel {
  final int id;
  final int storeId;
  final bool isFollow;

  StoreFollowModel({
    required this.id,
    required this.storeId,
    required this.isFollow,
  });

  factory StoreFollowModel.fromJson(Map<String, dynamic> json) {
    return StoreFollowModel(
      id: json['id'] as int,
      storeId: json['storeId'] as int,
      isFollow: json['isFollow'] == true,
    );
  }
}
