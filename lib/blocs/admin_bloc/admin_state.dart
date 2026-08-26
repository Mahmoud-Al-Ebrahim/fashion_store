part of 'admin_bloc.dart';

enum DeleteStoreStatus { init, loading, failure, success }

enum GetOrdersDetailStatus { init, loading, failure, success }

enum GetProductInventoryAlertStatus { init, loading, failure, success }

enum GetAllDiscountProductByStoreStatus { init, loading, failure, success }

enum GetProductDashboardStatus { init, loading, failure, success }

enum GetDashboardAnalyticsStatus { init, loading, failure, success }

enum GetDashboardSummaryStatus { init, loading, failure, success }

class AdminState {
  final DeleteStoreStatus deleteStoreStatus;
  final GetOrdersDetailStatus getOrdersDetailStatus;
  final GetProductInventoryAlertStatus getProductInventoryAlertStatus;
  final GetAllDiscountProductByStoreStatus getAllDiscountProductByStoreStatus;
  final GetProductDashboardStatus getProductDashboardStatus;
  final GetDashboardAnalyticsStatus getDashboardAnalyticsStatus;
  final GetDashboardSummaryStatus getDashboardSummaryStatus;

  final String errorMessage;

  final List<AdminOrderDetailStatModel> ordersDetail;
  final List<InventoryAlertModel> inventoryAlerts;
  final List<StoreProductModel> discountedStoreProducts;
  final ProductDashboardResultModel? productDashboard;
  final AdminDashboardAnalyticsModel? dashboardAnalytics;
  final AdminDashboardSummaryModel? dashboardSummary;

  AdminState({
    this.deleteStoreStatus = DeleteStoreStatus.init,
    this.getOrdersDetailStatus = GetOrdersDetailStatus.init,
    this.getProductInventoryAlertStatus = GetProductInventoryAlertStatus.init,
    this.getAllDiscountProductByStoreStatus =
        GetAllDiscountProductByStoreStatus.init,
    this.getProductDashboardStatus = GetProductDashboardStatus.init,
    this.getDashboardAnalyticsStatus = GetDashboardAnalyticsStatus.init,
    this.getDashboardSummaryStatus = GetDashboardSummaryStatus.init,
    this.errorMessage = '',
    this.ordersDetail = const [],
    this.inventoryAlerts = const [],
    this.discountedStoreProducts = const [],
    this.productDashboard,
    this.dashboardAnalytics,
    this.dashboardSummary,
  });

  AdminState copyWith({
    DeleteStoreStatus? deleteStoreStatus,
    GetOrdersDetailStatus? getOrdersDetailStatus,
    GetProductInventoryAlertStatus? getProductInventoryAlertStatus,
    GetAllDiscountProductByStoreStatus? getAllDiscountProductByStoreStatus,
    GetProductDashboardStatus? getProductDashboardStatus,
    GetDashboardAnalyticsStatus? getDashboardAnalyticsStatus,
    GetDashboardSummaryStatus? getDashboardSummaryStatus,
    String? errorMessage,
    List<AdminOrderDetailStatModel>? ordersDetail,
    List<InventoryAlertModel>? inventoryAlerts,
    List<StoreProductModel>? discountedStoreProducts,
    ProductDashboardResultModel? productDashboard,
    AdminDashboardAnalyticsModel? dashboardAnalytics,
    AdminDashboardSummaryModel? dashboardSummary,
  }) {
    return AdminState(
      deleteStoreStatus: deleteStoreStatus ?? this.deleteStoreStatus,
      getOrdersDetailStatus:
          getOrdersDetailStatus ?? this.getOrdersDetailStatus,
      getProductInventoryAlertStatus:
          getProductInventoryAlertStatus ?? this.getProductInventoryAlertStatus,
      getAllDiscountProductByStoreStatus:
          getAllDiscountProductByStoreStatus ??
          this.getAllDiscountProductByStoreStatus,
      getProductDashboardStatus:
          getProductDashboardStatus ?? this.getProductDashboardStatus,
      getDashboardAnalyticsStatus:
          getDashboardAnalyticsStatus ?? this.getDashboardAnalyticsStatus,
      getDashboardSummaryStatus:
          getDashboardSummaryStatus ?? this.getDashboardSummaryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      ordersDetail: ordersDetail ?? this.ordersDetail,
      inventoryAlerts: inventoryAlerts ?? this.inventoryAlerts,
      discountedStoreProducts:
          discountedStoreProducts ?? this.discountedStoreProducts,
      productDashboard: productDashboard ?? this.productDashboard,
      dashboardAnalytics: dashboardAnalytics ?? this.dashboardAnalytics,
      dashboardSummary: dashboardSummary ?? this.dashboardSummary,
    );
  }
}
