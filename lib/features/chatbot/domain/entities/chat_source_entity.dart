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