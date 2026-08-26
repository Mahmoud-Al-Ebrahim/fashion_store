import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/wallet/payment_order_details_model.dart';
import '../../models/wallet/transaction_model.dart';
import '../../models/wallet/wallet_model.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState()) {
    on<GetWalletEvent>(_onGetWalletEvent);
    on<GetAllTransactionsEvent>(_onGetAllTransactionsEvent);
    on<AddTransactionEvent>(_onAddTransactionEvent);
    on<GetOrderDetailsByPaymentEvent>(_onGetOrderDetailsByPaymentEvent);
  }

  FutureOr<void> _onGetWalletEvent(
    GetWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(getWalletStatus: GetWalletStatus.loading));
    await ApiService.getMethod(endPoint: 'Wallet/GetWallet')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<WalletModel>.fromJson(
            response.data,
            (json) => WalletModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getWalletStatus: GetWalletStatus.success,
              wallet: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getWalletStatus: GetWalletStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getWalletStatus: GetWalletStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllTransactionsEvent(
    GetAllTransactionsEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(
      state.copyWith(
        getAllTransactionsStatus: GetAllTransactionsStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Transaction/GetAllTransactions')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<TransactionModel>>.fromJson(
            response.data,
            (json) => transactionListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllTransactionsStatus: GetAllTransactionsStatus.success,
              transactions: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllTransactionsStatus: GetAllTransactionsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllTransactionsStatus: GetAllTransactionsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onAddTransactionEvent(
    AddTransactionEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(addTransactionStatus: AddTransactionStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Transaction/AddTransaction',
          body: {"walletId": event.walletId, "amount": event.amount},
        )
        .then((response) {
          log(response.data.toString());
          add(GetWalletEvent());
          add(GetAllTransactionsEvent());
          emit(
            state.copyWith(addTransactionStatus: AddTransactionStatus.success),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              addTransactionStatus: AddTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              addTransactionStatus: AddTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetOrderDetailsByPaymentEvent(
    GetOrderDetailsByPaymentEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(
      state.copyWith(
        getOrderDetailsByPaymentStatus: GetOrderDetailsByPaymentStatus.loading,
        // Drop the previous transaction's order so the sheet never shows
        // stale details while the new one loads.
        clearPaymentOrderDetails: true,
      ),
    );
    await ApiService.getMethod(
          endPoint:
              'Transaction/GetOrderDetailsByPayment/${event.transactionId}',
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse =
              ApiResponseModel<PaymentOrderDetailsModel>.fromJson(
                response.data,
                (json) => PaymentOrderDetailsModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              );
          emit(
            state.copyWith(
              getOrderDetailsByPaymentStatus:
                  GetOrderDetailsByPaymentStatus.success,
              paymentOrderDetails: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrderDetailsByPaymentStatus:
                  GetOrderDetailsByPaymentStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getOrderDetailsByPaymentStatus:
                  GetOrderDetailsByPaymentStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
