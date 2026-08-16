/// Response model for `GET Wallet/GetWallet` and `POST Wallet/AddWallet` -> `data`.
class WalletModel {
  final String id;
  final String userId;
  final double balance;

  WalletModel({required this.id, required this.userId, required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
