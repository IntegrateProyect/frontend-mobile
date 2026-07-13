import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';
import '../../../domain/entities/vocational_mini_game_entity.dart';

import '../models/game_model.dart';

class GameMapper {
  static GameEntity toEntity(GameModel model) {
    return GameEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
      type: model.type,
    );
  }

  static List<VocationalMiniGameEntity> groupQuestions(
      List<GameQuestionEntity> questions,
      ) {
    final grouped = <VocationalCategory, List<GameQuestionEntity>>{
      for (final category in VocationalCategory.values)
        category: <GameQuestionEntity>[],
    };

    for (final question in questions) {
      final category = _detectCategory(question.text);
      grouped[category]!.add(question);
    }

    return VocationalCategory.values
        .where((category) => grouped[category]!.isNotEmpty)
        .map(
          (category) => VocationalMiniGameEntity(
        category: category,
        title: _titles[category]!,
        description: _descriptions[category]!,
        questions: grouped[category]!,
      ),
    )
        .toList();
  }

  static VocationalCategory _detectCategory(String value) {
    final text = value.toLowerCase();

    for (final entry in _keywords.entries) {
      if (entry.value.any(text.contains)) {
        return entry.key;
      }
    }

    return VocationalCategory.artistico;
  }

  static const Map<VocationalCategory, List<String>> _keywords = {
    VocationalCategory.calculo: [
      'calcular',
      'aritmética',
      'aritmetica',
      'numérico',
      'numerico',
      'porcentajes',
      'logaritmos',
      'matemáticos',
      'matematicos',
      'regla de cálculo',
      'regla de calculo',
    ],
    VocationalCategory.fisico: [
      'eclipse',
      'telescopio',
      'estrellas',
      'observatorio',
      'energía atómica',
      'energia atomica',
      'rocas',
      'espectro',
      'combustión',
      'combustion',
    ],
    VocationalCategory.biologico: [
      'sangre',
      'plantas',
      'abejas',
      'insectos',
      'hormigas',
      'organismos',
      'acuario',
      'oxígeno',
      'oxigeno',
      'primeros auxilios',
      'operación médica',
      'operacion medica',
    ],
    VocationalCategory.mecanico: [
      'licuadora',
      'máquina',
      'maquina',
      'taladro',
      'reparar',
      'soldar',
      'reloj',
      'eléctrico',
      'electrico',
      'torno',
      'muebles',
      'televisión',
      'television',
    ],
    VocationalCategory.social: [
      'ayudar',
      'orfelinatos',
      'orfanatos',
      'consejero',
      'niños',
      'ninos',
      'ciegos',
      'escuchar',
      'servir',
      'personas de escasos recursos',
      'hermanos menores',
    ],
    VocationalCategory.literario: [
      'escribir',
      'cuentos',
      'novelas',
      'literatura',
      'biblioteca',
      'periódico',
      'periodico',
      'cartas',
      'clásicos',
      'clasicos',
      'reseñas',
      'artículos',
      'articulos',
    ],
    VocationalCategory.persuasivo: [
      'debates',
      'argumentos',
      'convencer',
      'políticos',
      'politicos',
      'defender',
      'líder',
      'lider',
      'dirigir',
      'producto',
      'público',
      'publico',
      'candidatos',
      'punto de vista',
      'campañas',
      'campanas',
    ],
    VocationalCategory.artistico: [
      'pintar',
      'óleo',
      'oleo',
      'arte',
      'dibujar',
      'mosaicos',
      'decoración',
      'decoracion',
      'paisajes',
      'tapices',
      'escenarios',
      'pinturas',
      'diseños',
      'disenos',
    ],
    VocationalCategory.musical: [
      'música',
      'musica',
      'concierto',
      'instrumento',
      'coral',
      'compositor',
      'discos',
      'leer música',
      'leer musica',
      'músico',
      'musico',
    ],
  };

  static const Map<VocationalCategory, String> _titles = {
    VocationalCategory.calculo: 'Juego de lógica y cálculo',
    VocationalCategory.fisico: 'Juego científico físico',
    VocationalCategory.biologico: 'Juego biológico',
    VocationalCategory.mecanico: 'Juego mecánico',
    VocationalCategory.social: 'Juego de servicio social',
    VocationalCategory.literario: 'Juego literario',
    VocationalCategory.persuasivo: 'Juego persuasivo',
    VocationalCategory.artistico: 'Juego artístico',
    VocationalCategory.musical: 'Juego musical',
  };

  static const Map<VocationalCategory, String> _descriptions = {
    VocationalCategory.calculo:
    'Retos con números y razonamiento lógico.',
    VocationalCategory.fisico:
    'Explora fenómenos naturales, luz, estrellas y energía.',
    VocationalCategory.biologico:
    'Actividades sobre vida, plantas, salud y laboratorio.',
    VocationalCategory.mecanico:
    'Reparar, armar, instalar y utilizar herramientas.',
    VocationalCategory.social:
    'Ayudar, escuchar y acompañar a otras personas.',
    VocationalCategory.literario:
    'Lectura, escritura y expresión de ideas.',
    VocationalCategory.persuasivo:
    'Debatir, convencer, liderar y defender ideas.',
    VocationalCategory.artistico:
    'Pintura, dibujo, diseño y creatividad visual.',
    VocationalCategory.musical:
    'Música, instrumentos, conciertos y composición.',
  };
}