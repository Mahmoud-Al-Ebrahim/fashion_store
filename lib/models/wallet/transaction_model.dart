/// Item of `GET Transaction/GetAllTransactions` -> `data`, and the response
/// model for `POST Transaction/AddTransaction` -> `data`.
class TransactionModel {
  final int id;
  final String walletId;
  final int? paymentId;
  final double amount;
  final DateTime date;
  final String transactionType; // e.g. Deposit | Withdraw

  TransactionModel({
    required this.id,
    required this.walletId,
    this.paymentId,
    required this.amount,
    required this.date,
    required this.transactionType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      walletId: json['walletId'].toString(),
      paymentId: json['paymentId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'].toString()),
      transactionType: json['transactionType']?.toString() ?? '',
    );
  }
}

List<TransactionModel> transactionListFromJson(dynamic json) =>
    (json as List<dynamic>)
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
