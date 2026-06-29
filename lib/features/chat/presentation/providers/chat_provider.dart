import 'package:flutter/material.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;
  
  List<ChatContactEntity> _contacts = [];
  List<ChatMessageEntity> _messages = [];
  bool _isLoading = false;
  String? _activeChatPartnerId;

  List<ChatContactEntity> get contacts => _contacts;
  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatProvider({required this.repository}) {
    repository.onMessageReceived().listen((message) {
      if (message.senderId == _activeChatPartnerId || message.receiverId == _activeChatPartnerId) {
        _messages.add(message);
        notifyListeners();
      }
      loadContacts(); // Refresh contact list for last message/unread count
    });
  }

  Future<void> connect(String url) async {
    await repository.connect(url);
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _contacts = await repository.getContacts();
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory(String partnerId) async {
    _activeChatPartnerId = partnerId;
    _isLoading = true;
    _messages = [];
    notifyListeners();
    try {
      _messages = await repository.getHistory(partnerId);
      repository.markAsRead(partnerId);
    } catch (e) {
      debugPrint('Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String receiverId, String text) {
    repository.sendMessage(receiverId, text);
  }

  void sendTyping(String receiverId, bool isTyping) {
    repository.sendTyping(receiverId, isTyping);
  }

  @override
  void dispose() {
    repository.disconnect();
    super.dispose();
  }
}
