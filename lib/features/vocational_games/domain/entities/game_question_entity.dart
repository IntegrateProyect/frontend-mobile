class GameQuestionEntity {
  final String id;
  final String text;
  final List<GameQuestionOptionEntity> options;

  GameQuestionEntity({
    required this.id,
    required this.text,
    required this.options,
  });
}

class GameQuestionOptionEntity {
  final String id;
  final String text;
  final Map<String, dynamic> weights;

  GameQuestionOptionEntity({
    required this.id,
    required this.text,
    required this.weights,
  });
}