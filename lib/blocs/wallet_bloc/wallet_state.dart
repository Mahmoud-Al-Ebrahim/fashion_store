part of 'wallet_bloc.dart';

enum GetWalletStatus { init, loading, failure, success }

enum AddWalletStatus { init, loading, failure, success }

enum GetAllTransactionsStatus { init, loading, failure, success }

enum AddTransactionStatus { init, loading, failure, success }

class WalletState {
  final GetWalletStatus getWalletStatus;
  final AddWalletStatus addWalletStatus;
  final GetAllTransactionsStatus getAllTransactionsStatus;
  final AddTransactionStatus addTransactionStatus;

  final String errorMessage;

  final WalletModel? wallet;
  final List<TransactionModel> transactions;

  WalletState({
    this.getWalletStatus = GetWalletStatus.init,
    this.addWalletStatus = AddWalletStatus.init,
    this.getAllTransactionsStatus = GetAllTransactionsStatus.init,
    this.addTransactionStatus = AddTransactionStatus.init,
    this.errorMessage = '',
    this.wallet,
    this.transactions = const [],
  });

  WalletState copyWith({
    GetWalletStatus? getWalletStatus,
    AddWalletStatus? addWalletStatus,
    GetAllTransactionsStatus? getAllTransactionsStatus,
    AddTransactionStatus? addTransactionStatus,
    String? errorMessage,
    WalletModel? wallet,
    List<TransactionModel>? transactions,
  }) {
    return WalletState(
      getWalletStatus: getWalletStatus ?? this.getWalletStatus,
      addWalletStatus: addWalletStatus ?? this.addWalletStatus,
      getAllTransactionsStatus:
          getAllTransactionsStatus ?? this.getAllTransactionsStatus,
      addTransactionStatus: addTransactionStatus ?? this.addTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
    );
  }
}
