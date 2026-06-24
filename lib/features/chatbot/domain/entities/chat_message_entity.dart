enum MessageSender { user, bot }

class ChatMessageEntity {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
