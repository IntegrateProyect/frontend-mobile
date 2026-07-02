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