import 'game_question_entity.dart';

enum VocationalCategory {
  calculo,
  fisico,
  biologico,
  mecanico,
  social,
  literario,
  persuasivo,
  artistico,
  musical,
}

enum MiniGameStatus {
  completed,
  inProgress,
  notStarted,
}

class VocationalMiniGameEntity {
  final VocationalCategory category;
  final String title;
  final String description;
  final List<GameQuestionEntity> questions;

  const VocationalMiniGameEntity({
    required this.category,
    required this.title,
    required this.description,
    required this.questions,
  });

  String get statusKey => category.name;
}