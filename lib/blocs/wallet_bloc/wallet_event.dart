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

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearWalletEvent extends WalletEvent {}
