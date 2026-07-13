import '../../../domain/entities/game_question_entity.dart';

class GameQuestionModel extends GameQuestionEntity {
  const GameQuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.options,
  });

  factory GameQuestionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GameQuestionModel(
      id: (json['id'] ?? '').toString(),
      text: (
          json['text'] ??
              json['question'] ??
              ''
      ).toString(),
      type: (
          json['type'] ??
              'MULTIPLE_CHOICE'
      ).toString(),
      options: _parseOptions(json['options']),
    );
  }

  static List<GameQuestionOptionEntity> _parseOptions(
      dynamic value,
      ) {
    if (value is! List) {
      return [];
    }

    return value.map((item) {
      final map = Map<String, dynamic>.from(item);

      return GameQuestionOptionEntity(
        id: (map['id'] ?? '').toString(),
        text: (map['text'] ?? '').toString(),
        weights: _parseWeights(map['weights']),
      );
    }).toList();
  }

  static Map<String, dynamic> _parseWeights(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }
}