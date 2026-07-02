// features/chatbot/presentation/providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatbotProvider extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;

  // Historial en-memoria para multi-turn
  final List<ChatMessageEntity> _messages = [];
  // Historial en formato para la API  [{role: user/assistant, content: ...}]
  final List<Map<String, String>> _apiHistory = [];

  List<ChatSourceEntity> _lastSources = [];
  bool _isLoading = false;
  bool _usedSearch = false;
  String? _error;

  ChatbotProvider({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase;

  List<ChatMessageEntity> get messages    => List.unmodifiable(_messages);
  List<ChatSourceEntity>  get lastSources => List.unmodifiable(_lastSources);
  bool    get isLoading  => _isLoading;
  bool    get usedSearch => _usedSearch;
  String? get error      => _error;

  Future<void> sendMessage(String text, {bool search = false}) async {
    if (text.trim().isEmpty) return;

    // Mensaje del usuario → UI inmediata
    final userMsg = ChatMessageEntity(
      id:        DateTime.now().millisecondsSinceEpoch.toString(),
      text:      text.trim(),
      sender:    MessageSender.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _sendMessageUseCase(
        text,
        history: List.from(_apiHistory),  // copia para evitar mutación
        search:  search,
      );

      // Guardar en historial multi-turn para la próxima request
      _apiHistory.add({'role': 'user',      'content': text});
      _apiHistory.add({'role': 'assistant', 'content': result.response});

      // Limitar historial a 10 turnos (20 mensajes) para no saturar tokens
      while (_apiHistory.length > 20) {
        _apiHistory.removeAt(0);
      }

      final botMsg = ChatMessageEntity(
        id:        '${DateTime.now().millisecondsSinceEpoch}_bot',
        text:      result.response,
        sender:    MessageSender.bot,
        timestamp: DateTime.now(),
      );
      _messages.add(botMsg);
      _lastSources = result.sources;
      _usedSearch  = result.usedSearch;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _messages.add(ChatMessageEntity(
        id:        '${DateTime.now().millisecondsSinceEpoch}_err',
        text:      'Lo siento, no pude procesar tu mensaje. Intenta de nuevo.',
        sender:    MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearConversation() {
    _messages.clear();
    _apiHistory.clear();
    _lastSources = [];
    _error = null;
    notifyListeners();
  }
}