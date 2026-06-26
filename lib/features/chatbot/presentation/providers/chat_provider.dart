import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';

class ChatProvider extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;

  List<ChatMessageEntity> _messages = [];
  bool _isLoading = false;

  ChatProvider({
    required this._sendMessageUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
  })  : _getChatHistoryUseCase = getChatHistoryUseCase;

  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await _getChatHistoryUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageEntity(
      id: DateTime.now().toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    notifyListeners();

    try {
      final botResponse = await _sendMessageUseCase(text);
      _messages.add(botResponse);
    } catch (e) {
      _messages.add(ChatMessageEntity(
        id: DateTime.now().toString(),
        text: "Lo siento, hubo un error al procesar tu mensaje.",
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    } finally {
      notifyListeners();
    }
  }
}
