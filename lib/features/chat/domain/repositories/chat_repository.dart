import '../entities/chat_contact_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<void> connect(String url);
  void disconnect();
  Future<List<ChatContactEntity>> getContacts();
  Future<List<ChatMessageEntity>> getHistory(String partnerId);
  void sendMessage(String receiverId, String text);
  Stream<ChatMessageEntity> onMessageReceived();
  Stream<bool> get onConnectionChanged;
  void markAsRead(String senderId);
  void sendTyping(String receiverId, bool isTyping);
}