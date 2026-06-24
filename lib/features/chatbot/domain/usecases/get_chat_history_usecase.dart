import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';

class GetChatHistoryUseCase {
  final ChatbotRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageEntity>> call() {
    return repository.getChatHistory();
  }
}
