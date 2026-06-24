import '../entities/chat_message_entity.dart';

abstract class ChatbotRepository {
  Future<ChatMessageEntity> sendMessage(String text);
  Future<List<ChatMessageEntity>> getChatHistory();
}
