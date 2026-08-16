/// Item of `GET Message/GetMessagesByComplaintId/{complaintId}` -> `data`.
///
/// NOTE: every complaint inspected during API exploration had zero messages
/// and the swagger spec exposes no "send message" endpoint, so this shape is
/// *inferred* from standard chat-thread conventions, not confirmed against a
/// real response. Verify field names against a live payload before relying
/// on this in UI.
class MessageModel {
  final int id;
  final int complaintId;
  final String senderId;
  final String? senderName;
  final String? senderImage;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.complaintId,
    required this.senderId,
    this.senderName,
    this.senderImage,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      complaintId: json['complaintId'] as int,
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName']?.toString(),
      senderImage: json['senderImage']?.toString(),
      text: (json['text'] ?? json['content'])?.toString() ?? '',
      isRead: json['isRead'] == true,
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}

List<MessageModel> messageListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
    .toList();
