class ChatContactEntity {
  final String contactId;
  final String contactName;
  final String contactEmail;
  final String contactRole;
  final String lastMessageText;
  final DateTime lastMessageCreatedAt;
  final int unreadCount;

  ChatContactEntity({
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
    required this.contactRole,
    required this.lastMessageText,
    required this.lastMessageCreatedAt,
    required this.unreadCount,
  });
}
