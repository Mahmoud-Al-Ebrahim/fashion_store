part of 'wallet_bloc.dart';

@immutable
sealed class WalletEvent {}

/// GET Wallet/GetWallet
class GetWalletEvent extends WalletEvent {}

/// POST Wallet/AddWallet
class AddWalletEvent extends WalletEvent {}

/// GET Transaction/GetAllTransactions
class GetAllTransactionsEvent extends WalletEvent {}

/// POST Transaction/AddTransaction
class AddTransactionEvent extends WalletEvent {
  final String walletId;
  final double amount;

  AddTransactionEvent({required this.walletId, required this.amount});
}
