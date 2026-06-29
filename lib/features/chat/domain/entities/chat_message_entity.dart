class ChatMessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  bool isMe(String currentUserId) => senderId == currentUserId;
}
