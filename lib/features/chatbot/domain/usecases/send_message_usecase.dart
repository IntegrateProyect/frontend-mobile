// features/chatbot/domain/usecases/send_message_usecase.dart
import '../entities/chat_source_entity.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;
  SendMessageUseCase(this.repository);

  Future<ChatbotResponseEntity> call(
      String message, {
        List<Map<String, String>> history = const [],
        bool search = false,
      }) {
    return repository.sendMessage(message, history: history, search: search);
  }
}