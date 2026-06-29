import 'package:orientate/features/chat/domain/entities/chat_contact_entity.dart';

class ChatContactModel extends ChatContactEntity {
  ChatContactModel({
    required super.contactId,
    required super.contactName,
    required super.contactEmail,
    required super.contactRole,
    required super.lastMessageText,
    required super.lastMessageCreatedAt,
    required super.unreadCount,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      contactId: json['contactId'] ?? '',
      contactName: json['contactName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactRole: json['contactRole'] ?? '',
      lastMessageText: json['lastMessageText'] ?? '',
      lastMessageCreatedAt: DateTime.parse(json['lastMessageCreatedAt'] ?? DateTime.now().toIso8601String()),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
