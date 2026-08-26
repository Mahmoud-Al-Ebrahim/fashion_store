part of 'complaint_bloc.dart';

@immutable
sealed class ComplaintEvent {}

/// POST Complaint/AddComplaint (customer files a complaint against a store)
class AddComplaintEvent extends ComplaintEvent {
  final int storeId;
  final String title;
  final String? description;

  AddComplaintEvent({
    required this.storeId,
    required this.title,
    this.description,
  });
}

/// GET Complaint/GetAllComplaints (store owner - complaints against their store)
class GetAllComplaintsEvent extends ComplaintEvent {}

/// GET Complaint/GetAllComplaintsByUser (customer - their own filed complaints)
class GetAllComplaintsByUserEvent extends ComplaintEvent {}

/// GET Message/GetMessagesByComplaintId/{complaintId}
class GetComplaintMessagesEvent extends ComplaintEvent {
  final int complaintId;

  GetComplaintMessagesEvent({required this.complaintId});
}

/// PUT Message/ReadMessage - marks the complaint's message thread as read
class ReadComplaintMessagesEvent extends ComplaintEvent {
  final int complaintId;

  ReadComplaintMessagesEvent({required this.complaintId});
}
