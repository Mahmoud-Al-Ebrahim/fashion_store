part of 'wallet_bloc.dart';

enum GetWalletStatus { init, loading, failure, success }

enum GetAllTransactionsStatus { init, loading, failure, success }

enum AddTransactionStatus { init, loading, failure, success }

enum GetOrderDetailsByPaymentStatus { init, loading, failure, success }

class WalletState {
  final GetWalletStatus getWalletStatus;
  final GetAllTransactionsStatus getAllTransactionsStatus;
  final AddTransactionStatus addTransactionStatus;
  final GetOrderDetailsByPaymentStatus getOrderDetailsByPaymentStatus;

  final String errorMessage;

  final WalletModel? wallet;
  final List<TransactionModel> transactions;

  /// Order behind the transaction most recently opened from the ledger.
  final PaymentOrderDetailsModel? paymentOrderDetails;

  WalletState({
    this.getWalletStatus = GetWalletStatus.init,
    this.getAllTransactionsStatus = GetAllTransactionsStatus.init,
    this.addTransactionStatus = AddTransactionStatus.init,
    this.getOrderDetailsByPaymentStatus = GetOrderDetailsByPaymentStatus.init,
    this.errorMessage = '',
    this.wallet,
    this.transactions = const [],
    this.paymentOrderDetails,
  });

  WalletState copyWith({
    GetWalletStatus? getWalletStatus,
    GetAllTransactionsStatus? getAllTransactionsStatus,
    AddTransactionStatus? addTransactionStatus,
    GetOrderDetailsByPaymentStatus? getOrderDetailsByPaymentStatus,
    String? errorMessage,
    WalletModel? wallet,
    List<TransactionModel>? transactions,
    PaymentOrderDetailsModel? paymentOrderDetails,
    // `?? this.x` can never reset a field to null, so opening a new
    // transaction needs an explicit way to drop the previous order.
    bool clearPaymentOrderDetails = false,
  }) {
    return WalletState(
      getWalletStatus: getWalletStatus ?? this.getWalletStatus,
      getAllTransactionsStatus:
          getAllTransactionsStatus ?? this.getAllTransactionsStatus,
      addTransactionStatus: addTransactionStatus ?? this.addTransactionStatus,
      getOrderDetailsByPaymentStatus:
          getOrderDetailsByPaymentStatus ?? this.getOrderDetailsByPaymentStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      paymentOrderDetails: clearPaymentOrderDetails
          ? null
          : (paymentOrderDetails ?? this.paymentOrderDetails),
    );
  }
}
