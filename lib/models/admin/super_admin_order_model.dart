/// Item of `GET SuperAdmin/GetAllFilterOrders` -> `data` - a platform-wide
/// order view for the SuperAdmin.
///
/// NOTE: every query made during API exploration returned an empty list, so
/// this shape could not be confirmed against real data. It's modeled after
/// [OrderSummaryModel] (the store-owner's own order view) with the fields a
/// cross-store admin view would plausibly add; verify against a live
/// response before relying on the extra fields ([storeId], [storeName],
/// [customerFullName]) in UI.
class SuperAdminOrderModel {
  final int id;
  final int? storeId;
  final String? storeName;
  final String? customerFullName;
  final String address;
  final double totalPrice;
  final DateTime createdAt;
  final String status; // enOrderStatus: Processing|Cancelled|Delivered

  SuperAdminOrderModel({
    required this.id,
    this.storeId,
    this.storeName,
    this.customerFullName,
    required this.address,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
  });

  factory SuperAdminOrderModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminOrderModel(
      id: json['id'] as int,
      storeId: json['storeId'] as int?,
      storeName: json['storeName']?.toString(),
      customerFullName: json['customerFullName']?.toString(),
      address: json['address']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      status: json['status']?.toString() ?? '',
    );
  }
}

List<SuperAdminOrderModel> superAdminOrderListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => SuperAdminOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
