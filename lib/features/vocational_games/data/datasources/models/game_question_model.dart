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
      id: _firstValue(
        json,
        const [
          'id',
          'questionId',
          'question_id',
        ],
      ),
      text: _firstValue(
        json,
        const [
          'text',
          'question',
          'title',
          'statement',
          'description',
        ],
      ),
      type: _firstValue(
        json,
        const [
          'type',
          'questionType',
          'question_type',
        ],
        defaultValue: 'MULTIPLE_CHOICE',
      ),
      options: _parseOptions(
        json['options'] ??
            json['answers'] ??
            json['choices'],
      ),
    );
  }

  static String _firstValue(
      Map<String, dynamic> json,
      List<String> keys, {
        String defaultValue = '',
      }) {
    for (final key in keys) {
      final value = json[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return defaultValue;
  }

  static List<GameQuestionOptionEntity> _parseOptions(
      dynamic value,
      ) {
    if (value is! List) {
      return const [];
    }

    final options = <GameQuestionOptionEntity>[];

    for (int index = 0; index < value.length; index++) {
      final item = value[index];

      // Cuando la opción viene como texto.
      if (item is String) {
        options.add(
          GameQuestionOptionEntity(
            id: index.toString(),
            text: item,
            weights: const {},
          ),
        );

        continue;
      }

      // Cuando la opción viene como número.
      if (item is num || item is bool) {
        options.add(
          GameQuestionOptionEntity(
            id: index.toString(),
            text: item.toString(),
            weights: const {},
          ),
        );

        continue;
      }

      // Cuando la opción viene como objeto.
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);

        final id = _firstValue(
          map,
          const [
            'id',
            'optionId',
            'option_id',
            'value',
          ],
          defaultValue: index.toString(),
        );

        final text = _firstValue(
          map,
          const [
            'text',
            'label',
            'answer',
            'option',
            'value',
          ],
          defaultValue: 'Opción ${index + 1}',
        );

        options.add(
          GameQuestionOptionEntity(
            id: id,
            text: text,
            weights: _parseWeights(
              map['weights'] ??
                  map['scores'] ??
                  map['weight'],
            ),
          ),
        );
      }
    }

    return options;
  }

  static Map<String, dynamic> _parseWeights(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }
}