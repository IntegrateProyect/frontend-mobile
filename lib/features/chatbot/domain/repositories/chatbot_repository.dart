// features/chatbot/domain/repositories/chatbot_repository.dart
import '../entities/chat_source_entity.dart';

abstract class ChatbotRepository {
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        List<Map<String, String>> history,
        bool search,
      });

  Future<bool> checkHealth();
}