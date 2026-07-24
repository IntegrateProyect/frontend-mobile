import '../entities/chat_source_entity.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  const SendMessageUseCase(this.repository);

  Future<ChatbotResponseEntity> call(
      String message, {
        bool search = false,
      }) {
    return repository.sendMessage(
      message,
      search: search,
    );
  }
}