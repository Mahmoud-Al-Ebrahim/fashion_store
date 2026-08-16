import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/wallet/transaction_model.dart';
import '../../models/wallet/wallet_model.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState()) {
    on<GetWalletEvent>(_onGetWalletEvent);
    on<AddWalletEvent>(_onAddWalletEvent);
    on<GetAllTransactionsEvent>(_onGetAllTransactionsEvent);
    on<AddTransactionEvent>(_onAddTransactionEvent);
  }

  FutureOr<void> _onGetWalletEvent(
    GetWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(getWalletStatus: GetWalletStatus.loading));
    await ApiService.getMethod(endPoint: 'Wallet/GetWallet').then((response) {
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
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getWalletStatus: GetWalletStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getWalletStatus: GetWalletStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddWalletEvent(
    AddWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(addWalletStatus: AddWalletStatus.loading));
    await ApiService.postMethod(endPoint: 'Wallet/AddWallet').then((
      response,
    ) {
      log(response.data.toString());
      add(GetWalletEvent());
      emit(state.copyWith(addWalletStatus: AddWalletStatus.success));
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addWalletStatus: AddWalletStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          addWalletStatus: AddWalletStatus.failure,
          errorMessage: "حدث خطأ ما!",
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
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllTransactionsStatus: GetAllTransactionsStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          getAllTransactionsStatus: GetAllTransactionsStatus.failure,
          errorMessage: "حدث خطأ ما!",
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
    ).then((response) {
      log(response.data.toString());
      add(GetWalletEvent());
      add(GetAllTransactionsEvent());
      emit(
        state.copyWith(addTransactionStatus: AddTransactionStatus.success),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addTransactionStatus: AddTransactionStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      emit(
        state.copyWith(
          addTransactionStatus: AddTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }
}
