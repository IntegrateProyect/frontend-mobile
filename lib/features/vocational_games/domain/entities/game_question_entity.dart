class GameQuestionEntity {
  final String id;
  final String text;
  final String type;
  final List<GameQuestionOptionEntity> options;

  const GameQuestionEntity({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
  });
}

class GameQuestionOptionEntity {
  final String id;
  final String text;
  final Map<String, dynamic> weights;

  const GameQuestionOptionEntity({
    required this.id,
    required this.text,
    required this.weights,
  });
}