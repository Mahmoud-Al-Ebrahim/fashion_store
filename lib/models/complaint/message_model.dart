import '../../core/utils/json_parse.dart';

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

  /// True once the sender has edited the message.
  final bool isEdited;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.complaintId,
    required this.senderId,
    this.senderName,
    this.senderImage,
    required this.text,
    required this.isRead,
    this.isEdited = false,
    required this.createdAt,
  });

  /// Parses `ResponseGetMessageDto`, which both `Message/GetMessagesBy
  /// ComplaintId` and the hub's `ReceiveMessage` push return:
  ///
  /// ```
  /// { id, senderId, senderName, senderImageUrl, messageText,
  ///   sentAt, isRead, isEdited, updatedAt }
  /// ```
  ///
  /// Note what is *absent*: there is no `complaintId`, no `text` and no
  /// `createdAt`. Reading those names is what made the history fail to load
  /// and every live message render blank. The caller already knows which
  /// complaint it is looking at, so `complaintId` defaults to 0.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: asInt(json['id']),
      complaintId: asInt(json['complaintId']),
      senderId: asString(json['senderId']),
      senderName: asStringOrNull(json['senderName']),
      senderImage: asStringOrNull(
        json['senderImageUrl'] ?? json['senderImage'],
      ),
      text: asString(json['messageText'] ?? json['text'] ?? json['content']),
      isRead: asBool(json['isRead']),
      isEdited: asBool(json['isEdited']),
      // Bare server timestamps are UTC; `asDate(...).toLocal()` treated
      // them as local and showed every message three hours early.
      createdAt: asServerDate(json['sentAt'] ?? json['createdAt']),
    );
  }
}

List<MessageModel> messageListFromJson(dynamic json) => (json as List<dynamic>)
    .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
    .toList();
