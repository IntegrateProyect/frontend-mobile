import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  @override
  Future<ChatMessageEntity> sendMessage(String text) async {
    // TODO: Implement actual API call to chatbot service
    await Future.delayed(const Duration(seconds: 1));
    return ChatMessageEntity(
      id: DateTime.now().toString(),
      text: "Esta es una respuesta simulada del Chatbot Orientate para: $text",
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    return [];
  }
}
