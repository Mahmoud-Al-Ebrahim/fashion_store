part of 'store_request_bloc.dart';

enum StoreRequestTransactionStatus { init, loading, failure, success }

enum GetStoreRequestFilesStatus { init, loading, failure, success }

enum GetAllStoreRequestsStatus { init, loading, failure, success }

class StoreRequestState {
  final StoreRequestTransactionStatus storeRequestTransactionStatus;
  final GetStoreRequestFilesStatus getStoreRequestFilesStatus;
  final GetAllStoreRequestsStatus getAllStoreRequestsStatus;

  final String errorMessage;

  final List<StoreDetailModel> storeRequests;
  final StoreRequestFilesModel? storeRequestFiles;

  StoreRequestState({
    this.storeRequestTransactionStatus = StoreRequestTransactionStatus.init,
    this.getStoreRequestFilesStatus = GetStoreRequestFilesStatus.init,
    this.getAllStoreRequestsStatus = GetAllStoreRequestsStatus.init,
    this.errorMessage = '',
    this.storeRequests = const [],
    this.storeRequestFiles,
  });

  StoreRequestState copyWith({
    StoreRequestTransactionStatus? storeRequestTransactionStatus,
    GetStoreRequestFilesStatus? getStoreRequestFilesStatus,
    GetAllStoreRequestsStatus? getAllStoreRequestsStatus,
    String? errorMessage,
    List<StoreDetailModel>? storeRequests,
    StoreRequestFilesModel? storeRequestFiles,
  }) {
    return StoreRequestState(
      storeRequestTransactionStatus:
          storeRequestTransactionStatus ?? this.storeRequestTransactionStatus,
      getStoreRequestFilesStatus:
          getStoreRequestFilesStatus ?? this.getStoreRequestFilesStatus,
      getAllStoreRequestsStatus:
          getAllStoreRequestsStatus ?? this.getAllStoreRequestsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      storeRequests: storeRequests ?? this.storeRequests,
      storeRequestFiles: storeRequestFiles ?? this.storeRequestFiles,
    );
  }
}
