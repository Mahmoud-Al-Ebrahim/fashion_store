part of 'super_admin_bloc.dart';

/// What the last finished action was, for screens that announce it.
///
/// Returning one value replaces the `if (a == success) else if (b == ...)`
/// chains screens used to write. Those chains announced whichever branch
/// came first in source order, not whichever action the user actually ran.
enum SuperAdminOutcome {
  none,
  banned,
  unbanned,
  deleted,
  roleAdded,
  roleRemoved,
  storeRequestDecided,
  failure,
}

enum RevokeUserTokenStatus { init, loading, failure, success }

enum UnbanUserStatus { init, loading, failure, success }

enum GetAllStoreCategoryStatus { init, loading, failure, success }

enum AddRoleStatus { init, loading, failure, success }

enum RemoveRoleStatus { init, loading, failure, success }

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
  final RemoveRoleStatus removeRoleStatus;
  final StoreRequestDecisionStatus storeRequestDecisionStatus;
  final GetAllStoreRequestsByFilterStatus getAllStoreRequestsByFilterStatus;
  final GetActiveUsersStatus getActiveUsersStatus;
  final GetBannedUsersStatus getBannedUsersStatus;
  final DeleteUserStatus deleteUserStatus;
  final GetAllFilterOrdersStatus getAllFilterOrdersStatus;

  final String errorMessage;

  /// True when the last store-request decision was an approval, false when
  /// it was a rejection. Both share [storeRequestDecisionStatus], so without
  /// this a rejection announced "approved".
  final bool? lastDecisionWasApproval;

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
    this.removeRoleStatus = RemoveRoleStatus.init,
    this.storeRequestDecisionStatus = StoreRequestDecisionStatus.init,
    this.getAllStoreRequestsByFilterStatus =
        GetAllStoreRequestsByFilterStatus.init,
    this.getActiveUsersStatus = GetActiveUsersStatus.init,
    this.getBannedUsersStatus = GetBannedUsersStatus.init,
    this.deleteUserStatus = DeleteUserStatus.init,
    this.getAllFilterOrdersStatus = GetAllFilterOrdersStatus.init,
    this.errorMessage = '',
    this.lastDecisionWasApproval,
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
    RemoveRoleStatus? removeRoleStatus,
    StoreRequestDecisionStatus? storeRequestDecisionStatus,
    GetAllStoreRequestsByFilterStatus? getAllStoreRequestsByFilterStatus,
    GetActiveUsersStatus? getActiveUsersStatus,
    GetBannedUsersStatus? getBannedUsersStatus,
    DeleteUserStatus? deleteUserStatus,
    GetAllFilterOrdersStatus? getAllFilterOrdersStatus,
    String? errorMessage,
    bool? lastDecisionWasApproval,
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
      removeRoleStatus: removeRoleStatus ?? this.removeRoleStatus,
      storeRequestDecisionStatus:
          storeRequestDecisionStatus ?? this.storeRequestDecisionStatus,
      getAllStoreRequestsByFilterStatus:
          getAllStoreRequestsByFilterStatus ??
          this.getAllStoreRequestsByFilterStatus,
      getActiveUsersStatus: getActiveUsersStatus ?? this.getActiveUsersStatus,
      getBannedUsersStatus: getBannedUsersStatus ?? this.getBannedUsersStatus,
      deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
      getAllFilterOrdersStatus:
          getAllFilterOrdersStatus ?? this.getAllFilterOrdersStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      lastDecisionWasApproval:
          lastDecisionWasApproval ?? this.lastDecisionWasApproval,
      storeCategories: storeCategories ?? this.storeCategories,
      storeRequests: storeRequests ?? this.storeRequests,
      activeUsers: activeUsers ?? this.activeUsers,
      bannedUsers: bannedUsers ?? this.bannedUsers,
      orders: orders ?? this.orders,
    );
  }

  /// Clears the outcome of whatever action ran last.
  ///
  /// Action statuses are sticky: nothing ever moved them back to `init`, so
  /// a screen that reacts with `if (a == success) ... else if (b == success)`
  /// would keep matching an *earlier* action. That is what made banning a
  /// user announce "unbanned" (a previous unban was still flagged success)
  /// and made a successful role assignment replay the previous attempt's
  /// error text. Every action handler now starts from a clean slate, so at
  /// most one outcome is ever live.
  SuperAdminState clearActionOutcomes() {
    return copyWith(
      revokeUserTokenStatus: RevokeUserTokenStatus.init,
      unbanUserStatus: UnbanUserStatus.init,
      addRoleStatus: AddRoleStatus.init,
      removeRoleStatus: RemoveRoleStatus.init,
      deleteUserStatus: DeleteUserStatus.init,
      storeRequestDecisionStatus: StoreRequestDecisionStatus.init,
      errorMessage: '',
    );
  }

  /// The single action outcome currently worth announcing.
  ///
  /// Safe because [clearActionOutcomes] guarantees at most one action status
  /// is non-`init` at a time, so the order of the checks below cannot change
  /// the answer.
  SuperAdminOutcome get actionOutcome {
    if (revokeUserTokenStatus == RevokeUserTokenStatus.success) {
      return SuperAdminOutcome.banned;
    }
    if (unbanUserStatus == UnbanUserStatus.success) {
      return SuperAdminOutcome.unbanned;
    }
    if (deleteUserStatus == DeleteUserStatus.success) {
      return SuperAdminOutcome.deleted;
    }
    if (addRoleStatus == AddRoleStatus.success) {
      return SuperAdminOutcome.roleAdded;
    }
    if (removeRoleStatus == RemoveRoleStatus.success) {
      return SuperAdminOutcome.roleRemoved;
    }
    if (storeRequestDecisionStatus == StoreRequestDecisionStatus.success) {
      return SuperAdminOutcome.storeRequestDecided;
    }
    // Only report an error once an action has actually failed - a stale
    // message must never resurface while the next request is in flight.
    final failed =
        revokeUserTokenStatus == RevokeUserTokenStatus.failure ||
        unbanUserStatus == UnbanUserStatus.failure ||
        deleteUserStatus == DeleteUserStatus.failure ||
        addRoleStatus == AddRoleStatus.failure ||
        removeRoleStatus == RemoveRoleStatus.failure ||
        storeRequestDecisionStatus == StoreRequestDecisionStatus.failure;
    if (failed && errorMessage.isNotEmpty) return SuperAdminOutcome.failure;
    return SuperAdminOutcome.none;
  }
}
