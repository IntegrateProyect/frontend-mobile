import '../entities/chat_source_entity.dart';

abstract class ChatbotRepository {
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        bool search = false,
      });

  Future<bool> checkHealth();
}