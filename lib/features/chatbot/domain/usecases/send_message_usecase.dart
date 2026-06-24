import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(String text) {
    return repository.sendMessage(text);
  }
}
