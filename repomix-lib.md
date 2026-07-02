This file is a merged representation of the entire codebase, combined into a single document by Repomix.

<file_summary>
This section contains a summary of this file.

<purpose>
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.
</purpose>

<file_format>
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  - File path as an attribute
  - Full contents of the file
</file_format>

<usage_guidelines>
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
</usage_guidelines>

<notes>
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)
</notes>

</file_summary>

<directory_structure>
data/
  datasources/
    mappers/
      chat_mapper.dart
    models/
      chat_message_model.dart
    remote/
      chatbot_remote_datasource.dart
  repositories/
    chatbot_repository_impl.dart
domain/
  entities/
    chat_message_entity.dart
    chat_source_entity.dart
  repositories/
    chatbot_repository.dart
  usecases/
    get_chat_history_usecase.dart
    send_message_usecase.dart
presentation/
  components/
    chat_bubble.dart
  providers/
    chat_provider.dart
  screens/
    chat_screen.dart
    chatbot_screen.dart
</directory_structure>

<files>
This section contains the contents of the repository's files.

<file path="data/datasources/mappers/chat_mapper.dart">
import '../../../domain/entities/chat_message_entity.dart';
import '../models/chat_message_model.dart';

class ChatMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) {
    return ChatMessageEntity(
      id: model.id,
      text: model.text,
      sender: model.sender,
      timestamp: model.timestamp,
    );
  }

  static ChatMessageModel fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      sender: entity.sender,
      timestamp: entity.timestamp,
    );
  }
}
</file>

<file path="data/datasources/models/chat_message_model.dart">
import '../../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text,
    required super.sender,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'bot',
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
</file>

<file path="data/datasources/remote/chatbot_remote_datasource.dart">
// data/datasources/remote/chatbot_remote_datasource.dart
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/handlers.dart';

abstract class ChatbotRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId});
  Future<bool> checkHealth();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static final String _baseUrl = dotenv.env['CHATBOT_API_URL'] ?? '...';

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (studentId != null) 'X-Student-Id': studentId,
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 20)); // el LLM puede tardar
    return processResponse(response); // reutiliza core/utils/handlers.dart
  }

  @override
  Future<bool> checkHealth() async {
    final response = await http.get(Uri.parse('$_baseUrl/chat/health'));
    final json = processResponse(response);
    return json['status'] == 'ok';
  }
}
</file>

<file path="data/repositories/chatbot_repository_impl.dart">
// features/chatbot/data/repositories/chatbot_repository_impl.dart
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/remote/chatbot_remote_datasource.dart';

// ── Model (vive aquí porque solo lo usa este repositorio) ────────────────────
class _ChatbotResponseModel {
  final String response;
  final String modelUsed;
  final int tokensUsed;
  final bool usedSearch;
  final List<ChatSourceEntity> sources;

  _ChatbotResponseModel({
    required this.response,
    required this.modelUsed,
    required this.tokensUsed,
    required this.usedSearch,
    required this.sources,
  });

  factory _ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    final sourcesList = (json['sources'] as List<dynamic>? ?? [])
        .map((s) => ChatSourceEntity.fromJson(Map<String, dynamic>.from(s)))
        .toList();

    return _ChatbotResponseModel(
      response:    json['response']     ?? '',
      modelUsed:   json['model_used']   ?? '',
      tokensUsed:  json['tokens_used']  ?? 0,
      usedSearch:  json['used_search']  == true,
      sources:     sourcesList,
    );
  }

  ChatbotResponseEntity toEntity() => ChatbotResponseEntity(
    response:    response,
    modelUsed:   modelUsed,
    tokensUsed:  tokensUsed,
    usedSearch:  usedSearch,
    sources:     sources,
  );
}

// ── Implementación del repositorio ───────────────────────────────────────────
class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;
  final UserService userService;

  ChatbotRepositoryImpl({
    required this.remoteDataSource,
    required this.userService,
  });

  @override
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        List<Map<String, String>> history = const [],
        bool search = false,
      }) async {
    final user = await userService.getUser();
    final json = await remoteDataSource.sendMessage(
      {
        'message': message,
        'history': history,
        'search':  search,
      },
      studentId: user?.id,
    );
    return _ChatbotResponseModel.fromJson(json).toEntity();
  }

  @override
  Future<bool> checkHealth() => remoteDataSource.checkHealth();
}
</file>

<file path="domain/entities/chat_message_entity.dart">
enum MessageSender { user, bot }

class ChatMessageEntity {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
</file>

<file path="domain/entities/chat_source_entity.dart">
// features/chatbot/domain/entities/chat_source_entity.dart

class ChatSourceEntity {
  final String careerId;
  final String careerName;
  final String universidad;
  final String area;
  final String descripcionCorta;
  final bool isClusterAlternative;

  ChatSourceEntity({
    required this.careerId,
    required this.careerName,
    required this.universidad,
    required this.area,
    required this.descripcionCorta,
    this.isClusterAlternative = false,
  });

  factory ChatSourceEntity.fromJson(Map<String, dynamic> json) {
    return ChatSourceEntity(
      careerId:            json['career_id']           ?? '',
      careerName:          json['career_name']         ?? '',
      universidad:         json['universidad']         ?? '',
      area:                json['area']                ?? '',
      descripcionCorta:    json['descripcion_corta']   ?? '',
      isClusterAlternative: json['is_cluster_alternative'] == true,
    );
  }
}

// La respuesta completa del endpoint POST /chat/
class ChatbotResponseEntity {
  final String response;
  final String modelUsed;
  final int tokensUsed;
  final bool usedSearch;
  final List<ChatSourceEntity> sources;

  ChatbotResponseEntity({
    required this.response,
    required this.modelUsed,
    required this.tokensUsed,
    required this.usedSearch,
    required this.sources,
  });
}
</file>

<file path="domain/repositories/chatbot_repository.dart">
// features/chatbot/domain/repositories/chatbot_repository.dart
import '../entities/chat_source_entity.dart';

abstract class ChatbotRepository {
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        List<Map<String, String>> history,
        bool search,
      });

  Future<bool> checkHealth();
}
</file>

<file path="domain/usecases/get_chat_history_usecase.dart">
// features/chatbot/domain/usecases/get_chat_history_usecase.dart

// El historial del chatbot es en-memoria (no hay endpoint GET /chat/history).
// Este use case existe solo para que injection_container no explote.
// El ChatProvider maneja la lista directamente.
class GetChatHistoryUseCase {
  // vacío a propósito
}
</file>

<file path="domain/usecases/send_message_usecase.dart">
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
</file>

<file path="presentation/components/chat_bubble.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 12),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
</file>

<file path="presentation/providers/chat_provider.dart">
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
</file>

<file path="presentation/screens/chat_screen.dart">
// features/chatbot/presentation/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../components/chat_bubble.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller   = TextEditingController();
  final _scrollCtrl   = ScrollController();
  bool  _searchMode   = false;   // toggle RAG

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    await context.read<ChatbotProvider>().sendMessage(
      text,
      search: _searchMode,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();

    // Scroll cuando llega respuesta
    if (!provider.isLoading) _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oriéntate+ Chat'),
        actions: [
          // Toggle RAG
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 18,
                  color: _searchMode
                      ? const Color(0xFF311B92)
                      : Colors.grey,
                ),
                Switch(
                  value: _searchMode,
                  activeColor: const Color(0xFF311B92),
                  onChanged: (v) => setState(() => _searchMode = v),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner RAG activo
          if (_searchMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: const Color(0xFFEDE7F6),
              child: const Text(
                '🔍 Búsqueda de carreras activada',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF311B92),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Lista de mensajes
          Expanded(
            child: provider.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller:  _scrollCtrl,
              padding:     const EdgeInsets.all(16),
              itemCount:   provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];
                // Si es el último mensaje del bot + hubo fuentes, mostralas
                final isLastBot = index == provider.messages.length - 1 &&
                    msg.sender == MessageSender.bot;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatBubble(message: msg),
                    if (isLastBot && provider.lastSources.isNotEmpty)
                      _buildSourcesChips(provider),
                  ],
                );
              },
            ),
          ),

          // Indicador de carga
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(
                color: Color(0xFF311B92),
                backgroundColor: Color(0xFFEDE7F6),
              ),
            ),

          _buildInputArea(provider.isLoading),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFFCBB8FF)),
          SizedBox(height: 16),
          Text(
            '¡Hola! Soy Oriéntate+\n¿En qué puedo ayudarte hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcesChips(ChatbotProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: provider.lastSources.take(4).map((src) {
          return Chip(
            label: Text(
              src.careerName,
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: src.isClusterAlternative
                ? const Color(0xFFF3E5F5)
                : const Color(0xFFE8EAF6),
            avatar: Icon(
              src.isClusterAlternative
                  ? Icons.auto_awesome
                  : Icons.school_outlined,
              size: 14,
              color: const Color(0xFF311B92),
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  enabled:    !isLoading,
                  maxLines:   null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border:   InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical:   10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF311B92),
              child: isLoading
                  ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                  color:       Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : IconButton(
                icon:    const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="presentation/screens/chatbot_screen.dart">
import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: const Center(
        child: Text('Chatbot Screen Content'),
      ),
    );
  }
}
</file>

</files>
