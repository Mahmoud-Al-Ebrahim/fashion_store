part of 'complaint_bloc.dart';

enum AddComplaintStatus { init, loading, failure, success }

enum GetAllComplaintsStatus { init, loading, failure, success }

enum GetAllComplaintsByUserStatus { init, loading, failure, success }

enum GetComplaintMessagesStatus { init, loading, failure, success }

enum ReadComplaintMessagesStatus { init, loading, failure, success }

class ComplaintState {
  final AddComplaintStatus addComplaintStatus;
  final GetAllComplaintsStatus getAllComplaintsStatus;
  final GetAllComplaintsByUserStatus getAllComplaintsByUserStatus;
  final GetComplaintMessagesStatus getComplaintMessagesStatus;
  final ReadComplaintMessagesStatus readComplaintMessagesStatus;

  final String errorMessage;

  final List<StoreComplaintModel> storeComplaints;
  final List<UserComplaintModel> userComplaints;
  final List<MessageModel> messages;

  ComplaintState({
    this.addComplaintStatus = AddComplaintStatus.init,
    this.getAllComplaintsStatus = GetAllComplaintsStatus.init,
    this.getAllComplaintsByUserStatus = GetAllComplaintsByUserStatus.init,
    this.getComplaintMessagesStatus = GetComplaintMessagesStatus.init,
    this.readComplaintMessagesStatus = ReadComplaintMessagesStatus.init,
    this.errorMessage = '',
    this.storeComplaints = const [],
    this.userComplaints = const [],
    this.messages = const [],
  });

  ComplaintState copyWith({
    AddComplaintStatus? addComplaintStatus,
    GetAllComplaintsStatus? getAllComplaintsStatus,
    GetAllComplaintsByUserStatus? getAllComplaintsByUserStatus,
    GetComplaintMessagesStatus? getComplaintMessagesStatus,
    ReadComplaintMessagesStatus? readComplaintMessagesStatus,
    String? errorMessage,
    List<StoreComplaintModel>? storeComplaints,
    List<UserComplaintModel>? userComplaints,
    List<MessageModel>? messages,
  }) {
    return ComplaintState(
      addComplaintStatus: addComplaintStatus ?? this.addComplaintStatus,
      getAllComplaintsStatus:
          getAllComplaintsStatus ?? this.getAllComplaintsStatus,
      getAllComplaintsByUserStatus:
          getAllComplaintsByUserStatus ?? this.getAllComplaintsByUserStatus,
      getComplaintMessagesStatus:
          getComplaintMessagesStatus ?? this.getComplaintMessagesStatus,
      readComplaintMessagesStatus:
          readComplaintMessagesStatus ?? this.readComplaintMessagesStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      storeComplaints: storeComplaints ?? this.storeComplaints,
      userComplaints: userComplaints ?? this.userComplaints,
      messages: messages ?? this.messages,
    );
  }
}
