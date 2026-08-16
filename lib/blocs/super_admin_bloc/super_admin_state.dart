part of 'super_admin_bloc.dart';

enum RevokeUserTokenStatus { init, loading, failure, success }

enum UnbanUserStatus { init, loading, failure, success }

enum GetAllStoreCategoryStatus { init, loading, failure, success }

enum AddRoleStatus { init, loading, failure, success }

enum StoreRequestDecisionStatus { init, loading, failure, success }

enum GetAllStoreRequestsByFilterStatus { init, loading, failure, success }

enum GetActiveUsersStatus { init, loading, failure, success }

enum GetBannedUsersStatus { init, loading, failure, success }

enum DeleteUserStatus { init, loading, failure, success }

enum GetAllFilterOrdersStatus { init, loading, failure, success }

class SuperAdminState {
  final RevokeUserTokenStatus revokeUserTokenStatus;
  final UnbanUserStatus unbanUserStatus;
  final GetAllStoreCategoryStatus getAllStoreCategoryStatus;
  final AddRoleStatus addRoleStatus;
  final StoreRequestDecisionStatus storeRequestDecisionStatus;
  final GetAllStoreRequestsByFilterStatus getAllStoreRequestsByFilterStatus;
  final GetActiveUsersStatus getActiveUsersStatus;
  final GetBannedUsersStatus getBannedUsersStatus;
  final DeleteUserStatus deleteUserStatus;
  final GetAllFilterOrdersStatus getAllFilterOrdersStatus;

  final String errorMessage;

  final List<StoreCategoryModel> storeCategories;
  final List<StoreDetailModel> storeRequests;
  final List<UserProfileModel> activeUsers;
  final List<UserProfileModel> bannedUsers;
  final List<SuperAdminOrderModel> orders;

  SuperAdminState({
    this.revokeUserTokenStatus = RevokeUserTokenStatus.init,
    this.unbanUserStatus = UnbanUserStatus.init,
    this.getAllStoreCategoryStatus = GetAllStoreCategoryStatus.init,
    this.addRoleStatus = AddRoleStatus.init,
    this.storeRequestDecisionStatus = StoreRequestDecisionStatus.init,
    this.getAllStoreRequestsByFilterStatus =
        GetAllStoreRequestsByFilterStatus.init,
    this.getActiveUsersStatus = GetActiveUsersStatus.init,
    this.getBannedUsersStatus = GetBannedUsersStatus.init,
    this.deleteUserStatus = DeleteUserStatus.init,
    this.getAllFilterOrdersStatus = GetAllFilterOrdersStatus.init,
    this.errorMessage = '',
    this.storeCategories = const [],
    this.storeRequests = const [],
    this.activeUsers = const [],
    this.bannedUsers = const [],
    this.orders = const [],
  });

  SuperAdminState copyWith({
    RevokeUserTokenStatus? revokeUserTokenStatus,
    UnbanUserStatus? unbanUserStatus,
    GetAllStoreCategoryStatus? getAllStoreCategoryStatus,
    AddRoleStatus? addRoleStatus,
    StoreRequestDecisionStatus? storeRequestDecisionStatus,
    GetAllStoreRequestsByFilterStatus? getAllStoreRequestsByFilterStatus,
    GetActiveUsersStatus? getActiveUsersStatus,
    GetBannedUsersStatus? getBannedUsersStatus,
    DeleteUserStatus? deleteUserStatus,
    GetAllFilterOrdersStatus? getAllFilterOrdersStatus,
    String? errorMessage,
    List<StoreCategoryModel>? storeCategories,
    List<StoreDetailModel>? storeRequests,
    List<UserProfileModel>? activeUsers,
    List<UserProfileModel>? bannedUsers,
    List<SuperAdminOrderModel>? orders,
  }) {
    return SuperAdminState(
      revokeUserTokenStatus:
          revokeUserTokenStatus ?? this.revokeUserTokenStatus,
      unbanUserStatus: unbanUserStatus ?? this.unbanUserStatus,
      getAllStoreCategoryStatus:
          getAllStoreCategoryStatus ?? this.getAllStoreCategoryStatus,
      addRoleStatus: addRoleStatus ?? this.addRoleStatus,
      storeRequestDecisionStatus:
          storeRequestDecisionStatus ?? this.storeRequestDecisionStatus,
      getAllStoreRequestsByFilterStatus: getAllStoreRequestsByFilterStatus ??
          this.getAllStoreRequestsByFilterStatus,
      getActiveUsersStatus: getActiveUsersStatus ?? this.getActiveUsersStatus,
      getBannedUsersStatus: getBannedUsersStatus ?? this.getBannedUsersStatus,
      deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
      getAllFilterOrdersStatus:
          getAllFilterOrdersStatus ?? this.getAllFilterOrdersStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      storeCategories: storeCategories ?? this.storeCategories,
      storeRequests: storeRequests ?? this.storeRequests,
      activeUsers: activeUsers ?? this.activeUsers,
      bannedUsers: bannedUsers ?? this.bannedUsers,
      orders: orders ?? this.orders,
    );
  }
}
