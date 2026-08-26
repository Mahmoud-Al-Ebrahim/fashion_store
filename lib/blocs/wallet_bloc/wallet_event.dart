part of 'wallet_bloc.dart';

@immutable
sealed class WalletEvent {}

/// GET Wallet/GetWallet
class GetWalletEvent extends WalletEvent {}

/// GET Transaction/GetAllTransactions
class GetAllTransactionsEvent extends WalletEvent {}

/// POST Transaction/AddTransaction
class AddTransactionEvent extends WalletEvent {
  final String walletId;
  final double amount;

  AddTransactionEvent({required this.walletId, required this.amount});
}

/// GET Transaction/GetOrderDetailsByPayment/{transactionId}
///
/// Resolves the order a transaction paid for, so tapping a row in the
/// ledger can show what was actually bought.
class GetOrderDetailsByPaymentEvent extends WalletEvent {
  final int transactionId;

  GetOrderDetailsByPaymentEvent({required this.transactionId});
}
