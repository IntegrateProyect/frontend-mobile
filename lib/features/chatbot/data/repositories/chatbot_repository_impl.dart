import '../../../../core/utils/UserService.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/remote/chatbot_remote_datasource.dart';

class _ChatbotResponseModel {
  final String response;
  final String modelUsed;
  final int tokensUsed;
  final bool usedSearch;
  final List<ChatSourceEntity> sources;

  const _ChatbotResponseModel({
    required this.response,
    required this.modelUsed,
    required this.tokensUsed,
    required this.usedSearch,
    required this.sources,
  });

  factory _ChatbotResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawSources = json['sources'];

    final sources = rawSources is List
        ? rawSources
        .whereType<Map>()
        .map(
          (source) => ChatSourceEntity.fromJson(
        Map<String, dynamic>.from(source),
      ),
    )
        .toList()
        : <ChatSourceEntity>[];

    final rawTokens = json['tokens_used'];

    return _ChatbotResponseModel(
      response: json['response']?.toString() ?? '',
      modelUsed: json['model_used']?.toString() ?? '',
      tokensUsed: rawTokens is int
          ? rawTokens
          : int.tryParse(rawTokens?.toString() ?? '') ?? 0,
      usedSearch: json['used_search'] == true,
      sources: sources,
    );
  }

  ChatbotResponseEntity toEntity() {
    return ChatbotResponseEntity(
      response: response,
      modelUsed: modelUsed,
      tokensUsed: tokensUsed,
      usedSearch: usedSearch,
      sources: sources,
    );
  }
}

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
        bool search = false,
      }) async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw const ChatbotSessionExpiredException(
        'No se encontró una sesión activa.',
      );
    }

    final json = await remoteDataSource.sendMessage(
      token: token,
      message: message,
      search: search,
    );

    return _ChatbotResponseModel.fromJson(json).toEntity();
  }

  @override
  Future<bool> checkHealth() {
    return remoteDataSource.checkHealth();
  }
}