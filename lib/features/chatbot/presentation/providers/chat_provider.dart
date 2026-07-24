import 'package:flutter/material.dart';

import '../../data/datasources/remote/chatbot_remote_datasource.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatbotProvider extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;

  final List<ChatMessageEntity> _messages = [];

  List<ChatSourceEntity> _lastSources = [];

  bool _isLoading = false;
  bool _usedSearch = false;
  bool _sessionExpired = false;
  String? _error;

  ChatbotProvider({
    required SendMessageUseCase sendMessageUseCase,
  }) : _sendMessageUseCase = sendMessageUseCase;

  List<ChatMessageEntity> get messages =>
      List.unmodifiable(_messages);

  List<ChatSourceEntity> get lastSources =>
      List.unmodifiable(_lastSources);

  bool get isLoading => _isLoading;

  bool get usedSearch => _usedSearch;

  bool get sessionExpired => _sessionExpired;

  String? get error => _error;

  Future<void> sendMessage(
      String text, {
        bool search = false,
      }) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty || _isLoading) {
      return;
    }

    final now = DateTime.now();

    _messages.add(
      ChatMessageEntity(
        id: now.microsecondsSinceEpoch.toString(),
        text: cleanText,
        sender: MessageSender.user,
        timestamp: now,
      ),
    );

    _isLoading = true;
    _sessionExpired = false;
    _error = null;
    _lastSources = [];

    notifyListeners();

    try {
      final result = await _sendMessageUseCase(
        cleanText,
        search: search,
      );

      _messages.add(
        ChatMessageEntity(
          id: '${DateTime.now().microsecondsSinceEpoch}_bot',
          text: result.response.isEmpty
              ? 'No recibí una respuesta válida.'
              : result.response,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
        ),
      );

      _lastSources = result.sources;
      _usedSearch = result.usedSearch;
    } on ChatbotSessionExpiredException catch (error) {
      _sessionExpired = true;
      _error = error.message;
    } on ChatbotApiException catch (error) {
      _error = error.message;

      _addErrorMessage(
        'No pude procesar tu mensaje. Intenta nuevamente.',
      );
    } catch (error) {
      _error = error
          .toString()
          .replaceFirst('Exception: ', '')
          .trim();

      _addErrorMessage(
        'Ocurrió un problema de conexión. Intenta nuevamente.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addErrorMessage(String text) {
    _messages.add(
      ChatMessageEntity(
        id: '${DateTime.now().microsecondsSinceEpoch}_error',
        text: text,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ),
    );
  }

  void clearConversation() {
    _messages.clear();
    _lastSources = [];
    _usedSearch = false;
    _sessionExpired = false;
    _error = null;

    notifyListeners();
  }
}