import 'game_question_entity.dart';
import 'vocational_game_kind.dart';

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
  final VocationalGameKind kind;
  final String title;
  final String description;

  /// Categorías vocacionales que evalúa este minijuego.
  final List<VocationalCategory> categories;

  /// Se mantiene para que el flujo actual de preguntas
  /// y GameDetailScreen continúe funcionando.
  final List<GameQuestionEntity> questions;

  const VocationalMiniGameEntity({
    required this.kind,
    required this.title,
    required this.description,
    required this.categories,
    required this.questions,
  });

  /// Llave utilizada para guardar el progreso.
  ///
  /// Ejemplos:
  /// laboratorio
  /// consultorio
  /// taller
  /// estudio
  String get statusKey => kind.name;

  /// Compatibilidad con MiniGameVisual y
  /// VocationalMiniGameCard.
  ///
  /// Cada uno de los cuatro juegos utiliza una categoría
  /// principal solamente para obtener su imagen, icono y color.
  VocationalCategory get category {
    switch (kind) {
      case VocationalGameKind.laboratorio:
        return VocationalCategory.calculo;

      case VocationalGameKind.consultorio:
        return VocationalCategory.social;

      case VocationalGameKind.taller:
        return VocationalCategory.mecanico;

      case VocationalGameKind.estudio:
        return VocationalCategory.artistico;
    }
  }

  int get totalChallenges => questions.length;
}
