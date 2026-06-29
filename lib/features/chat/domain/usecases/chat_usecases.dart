import '../entities/chat_contact_entity.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatContactsUseCase {
  final ChatRepository repository;
  GetChatContactsUseCase(this.repository);
  Future<List<ChatContactEntity>> call() => repository.getContacts();
}

class GetChatHistoryUseCase {
  final ChatRepository repository;
  GetChatHistoryUseCase(this.repository);
  Future<List<ChatMessageEntity>> call(String partnerId) => repository.getHistory(partnerId);
}

class SendChatMessageUseCase {
  final ChatRepository repository;
  SendChatMessageUseCase(this.repository);
  void call(String receiverId, String text) => repository.sendMessage(receiverId, text);
}

class ConnectChatSocketUseCase {
  final ChatRepository repository;
  ConnectChatSocketUseCase(this.repository);
  Future<void> call(String url) => repository.connect(url);
}

class DisconnectChatSocketUseCase {
  final ChatRepository repository;
  DisconnectChatSocketUseCase(this.repository);
  void call() => repository.disconnect();
}

class MarkMessagesAsReadUseCase {
  final ChatRepository repository;
  MarkMessagesAsReadUseCase(this.repository);
  void call(String senderId) => repository.markAsRead(senderId);
}
