part of 'super_admin_bloc.dart';

@immutable
sealed class SuperAdminEvent {}

/// POST SuperAdmin/RevokeToken/{userId} - force-logs-out a user (revokes refresh tokens)
class RevokeUserTokenEvent extends SuperAdminEvent {
  final String userId;

  RevokeUserTokenEvent({required this.userId});
}

/// POST SuperAdmin/UnbanUser/{userId}
class UnbanUserEvent extends SuperAdminEvent {
  final String userId;

  UnbanUserEvent({required this.userId});
}

/// GET SuperAdmin/GetAllStoreCategory/{storeId}
class GetAllStoreCategoryEvent extends SuperAdminEvent {
  final int storeId;

  GetAllStoreCategoryEvent({required this.storeId});
}

/// POST SuperAdmin/AddRole - grants a role (e.g. "Admin") to a user
class AddRoleEvent extends SuperAdminEvent {
  final String userId;
  final String role;

  AddRoleEvent({required this.userId, required this.role});
}

/// PATCH SuperAdmin/RequestApproved/{requestId} - approves a pending store request
class ApproveStoreRequestEvent extends SuperAdminEvent {
  final int requestId;

  ApproveStoreRequestEvent({required this.requestId});
}

/// PATCH SuperAdmin/RequestRejected - rejects a pending store request
class RejectStoreRequestEvent extends SuperAdminEvent {
  final int requestId;
  final String? rejectionReason;

  RejectStoreRequestEvent({required this.requestId, this.rejectionReason});
}

/// GET SuperAdmin/GetAllRequestStoreByFilter?storeStatus=&pageNumber=&pageSize=
class GetAllStoreRequestsByFilterEvent extends SuperAdminEvent {
  final String storeStatus; // enStoreStatus
  final int pageNumber;
  final int pageSize;

  GetAllStoreRequestsByFilterEvent({
    required this.storeStatus,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

/// GET SuperAdmin/ActiveUsers
class GetActiveUsersEvent extends SuperAdminEvent {}

/// GET SuperAdmin/BannedUsers
class GetBannedUsersEvent extends SuperAdminEvent {}

/// DELETE SuperAdmin/DeleteUser?userId=
class DeleteUserEvent extends SuperAdminEvent {
  final String userId;

  DeleteUserEvent({required this.userId});
}

/// GET SuperAdmin/GetAllFilterOrders?orderStatus=&pageNumber=&pageSize=
class GetAllFilterOrdersEvent extends SuperAdminEvent {
  final String orderStatus; // enOrderStatus
  final int pageNumber;
  final int pageSize;

  GetAllFilterOrdersEvent({
    required this.orderStatus,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
