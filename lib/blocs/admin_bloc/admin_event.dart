part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

/// DELETE Admin/Delete/{storeId} - deletes/deactivates a store
class DeleteStoreEvent extends AdminEvent {
  final int storeId;

  DeleteStoreEvent({required this.storeId});
}

/// GET Admin/GetOrdersDetail?startDate=&endDate= - per product/size/color
/// sales breakdown for the store within a date range
class GetOrdersDetailEvent extends AdminEvent {
  final DateTime startDate;
  final DateTime endDate;

  GetOrdersDetailEvent({required this.startDate, required this.endDate});
}

/// GET Admin/GetProductInventoryAlert - low-stock (product,color,size) list
class GetProductInventoryAlertEvent extends AdminEvent {}

/// GET Admin/GetAllDiscountProductByStore - the store's own discounted products
class GetAllDiscountProductByStoreEvent extends AdminEvent {}

/// GET Admin/GetProductDashboard?pageNumber=&pageSize=
class GetProductDashboardEvent extends AdminEvent {
  final int pageNumber;
  final int pageSize;

  GetProductDashboardEvent({this.pageNumber = 1, this.pageSize = 10});
}

/// GET Admin/GetDashboardAnalytics?fromDate=&endDate=
class GetDashboardAnalyticsEvent extends AdminEvent {
  final DateTime fromDate;
  final DateTime endDate;

  GetDashboardAnalyticsEvent({required this.fromDate, required this.endDate});
}

/// GET Admin/GetDashboardSummary
class GetDashboardSummaryEvent extends AdminEvent {}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearAdminEvent extends AdminEvent {}
