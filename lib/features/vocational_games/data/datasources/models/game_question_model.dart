import '../../../domain/entities/game_question_entity.dart';

class GameQuestionModel extends GameQuestionEntity {
  GameQuestionModel({
    required super.id,
    required super.text,
    required super.options,
  });

  factory GameQuestionModel.fromJson(Map<String, dynamic> json) {
    return GameQuestionModel(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? json['question'] ?? '').toString(),
      options: _options(json['options']),
    );
  }

  static List<GameQuestionOptionEntity> _options(dynamic value) {
    if (value is List) {
      return value.map((e) {
        final map = Map<String, dynamic>.from(e);
        return GameQuestionOptionEntity(
          id: (map['id'] ?? '').toString(),
          text: (map['text'] ?? '').toString(),
          weights: Map<String, dynamic>.from(map['weights'] ?? {}),
        );
      }).toList();
    }
    return [];
  }
}