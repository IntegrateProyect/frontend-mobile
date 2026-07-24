import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';
import '../../../domain/entities/vocational_game_kind.dart';
import '../../../domain/entities/vocational_mini_game_entity.dart';

import '../models/game_model.dart';

class GameMapper {
  const GameMapper._();

  static GameEntity toEntity(GameModel model) {
    return GameEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
      type: model.type,
    );
  }

  static VocationalCategory detectCategory(String text) {
    return _detectCategory(text);
  }

  static List<VocationalMiniGameEntity> groupQuestions(
      List<GameQuestionEntity> questions,
      ) {
    final laboratorioQuestions = <GameQuestionEntity>[];
    final consultorioQuestions = <GameQuestionEntity>[];
    final tallerQuestions = <GameQuestionEntity>[];
    final estudioQuestions = <GameQuestionEntity>[];

    // Después de agregar la pregunta del acuario, Laboratorio queda cerrado.
    // Las preguntas siguientes continúan clasificándose para los otros juegos,
    // pero ya no se agregan más preguntas científicas al Laboratorio.
    var laboratoryClosed = false;

    for (final question in questions) {
      final category = _detectCategory(question.text);

      switch (category) {
        case VocationalCategory.calculo:
        case VocationalCategory.fisico:
        case VocationalCategory.biologico:
          if (!laboratoryClosed) {
            laboratorioQuestions.add(question);

            if (_isAquariumQuestion(question.text)) {
              laboratoryClosed = true;
            }
          }
          break;

        case VocationalCategory.social:
          consultorioQuestions.add(question);
          break;

        case VocationalCategory.mecanico:
          tallerQuestions.add(question);
          break;

        case VocationalCategory.artistico:
        case VocationalCategory.musical:
          estudioQuestions.add(question);
          break;

        case VocationalCategory.persuasivo:
          if (_isLeadershipQuestion(question.text)) {
            tallerQuestions.add(question);
          } else {
            consultorioQuestions.add(question);
          }
          break;

        case VocationalCategory.literario:
          if (_isCreativeLiteraryQuestion(question.text)) {
            estudioQuestions.add(question);
          } else {
            consultorioQuestions.add(question);
          }
          break;
      }
    }

    return <VocationalMiniGameEntity>[
      VocationalMiniGameEntity(
        kind: VocationalGameKind.laboratorio,
        title: 'Laboratorio',
        description:
        'Investiga, compara datos y completa experimentos científicos.',
        categories: const [
          VocationalCategory.calculo,
          VocationalCategory.fisico,
          VocationalCategory.biologico,
        ],
        questions: laboratorioQuestions,
      ),
      VocationalMiniGameEntity(
        kind: VocationalGameKind.consultorio,
        title: 'Consultorio',
        description: 'Escucha distintas situaciones y decide cómo ayudar.',
        categories: const [
          VocationalCategory.social,
          VocationalCategory.literario,
          VocationalCategory.persuasivo,
        ],
        questions: consultorioQuestions,
      ),
      VocationalMiniGameEntity(
        kind: VocationalGameKind.taller,
        title: 'Taller',
        description: 'Arma, repara y organiza las piezas de un dispositivo.',
        categories: const [
          VocationalCategory.mecanico,
          VocationalCategory.persuasivo,
        ],
        questions: tallerQuestions,
      ),
      VocationalMiniGameEntity(
        kind: VocationalGameKind.estudio,
        title: 'Estudio creativo',
        description: 'Combina colores, figuras, palabras y sonidos.',
        categories: const [
          VocationalCategory.artistico,
          VocationalCategory.musical,
          VocationalCategory.literario,
        ],
        questions: estudioQuestions,
      ),
    ];
  }

  static bool _isAquariumQuestion(String rawText) {
    final text = _normalize(rawText);
    return _containsAny(
      text,
      const [
        'cuidar un pequeno acuario',
        'cuidado del acuario',
        'pequeno acuario',
        'acuario',
        'peces',
      ],
    );
  }

  static bool _isLeadershipQuestion(String rawText) {
    final text = _normalize(rawText);

    return _containsAny(
      text,
      const [
        'lider',
        'dirigir',
        'organizar',
        'coordinar',
        'supervisar',
        'delegar',
        'equipo',
        'candidato',
        'campana',
        'administrar',
        'responsable de un grupo',
      ],
    );
  }

  static bool _isCreativeLiteraryQuestion(String rawText) {
    final text = _normalize(rawText);

    return _containsAny(
      text,
      const [
        'escribir',
        'cuento',
        'cuentos',
        'novela',
        'novelas',
        'poesia',
        'crear historias',
        'redactar',
        'componer un texto',
        'guion',
        'guiones',
        'obra literaria',
      ],
    );
  }

  static VocationalCategory _detectCategory(String rawText) {
    final text = _normalize(rawText);

    for (final entry in _keywords.entries) {
      if (_containsAny(text, entry.value)) {
        return entry.key;
      }
    }

    return VocationalCategory.artistico;
  }

  static bool _containsAny(String text, List<String> words) {
    return words.any(text.contains);
  }

  static String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  static const Map<VocationalCategory, List<String>> _keywords = {
    VocationalCategory.calculo: [
      'calcular',
      'aritmetica',
      'numerico',
      'porcentajes',
      'logaritmos',
      'matematicos',
      'regla de calculo',
      'resolver problemas',
      'ecuacion',
      'ecuaciones',
      'matematica',
      'matematicas',
      'logica',
    ],
    VocationalCategory.fisico: [
      'eclipse',
      'telescopio',
      'estrellas',
      'observatorio',
      'energia atomica',
      'rocas',
      'espectro',
      'combustion',
      'fisica',
      'fenomenos naturales',
      'astronomia',
      'planetas',
    ],
    VocationalCategory.biologico: [
      'sangre',
      'plantas',
      'abejas',
      'insectos',
      'hormigas',
      'organismos',
      'acuario',
      'peces',
      'oxigeno',
      'primeros auxilios',
      'operacion medica',
      'biologia',
      'salud',
      'laboratorio',
      'animales',
      'medicina',
    ],
    VocationalCategory.mecanico: [
      'licuadora',
      'maquina',
      'taladro',
      'reparar',
      'soldar',
      'reloj',
      'electrico',
      'torno',
      'muebles',
      'television',
      'herramienta',
      'armar',
      'motor',
      'mecanico',
      'mecanica',
      'construir',
    ],
    VocationalCategory.social: [
      'ayudar',
      'orfelinatos',
      'orfanatos',
      'consejero',
      'ninos',
      'ciegos',
      'escuchar',
      'servir',
      'personas de escasos recursos',
      'hermanos menores',
      'acompanar',
      'apoyar',
      'cuidar personas',
      'orientar personas',
      'trabajo social',
    ],
    VocationalCategory.literario: [
      'escribir',
      'cuentos',
      'novelas',
      'literatura',
      'biblioteca',
      'periodico',
      'cartas',
      'clasicos',
      'resenas',
      'articulos',
      'leer',
      'lectura',
      'libros',
      'redactar',
      'poesia',
    ],
    VocationalCategory.persuasivo: [
      'debates',
      'argumentos',
      'convencer',
      'politicos',
      'defender',
      'lider',
      'dirigir',
      'producto',
      'publico',
      'candidatos',
      'punto de vista',
      'campanas',
      'persuadir',
      'coordinar',
      'organizar',
      'vender',
      'negociar',
    ],
    VocationalCategory.artistico: [
      'pintar',
      'oleo',
      'arte',
      'dibujar',
      'mosaicos',
      'decoracion',
      'paisajes',
      'tapices',
      'escenarios',
      'pinturas',
      'disenos',
      'colores',
      'formas',
      'creatividad',
      'ilustrar',
      'escultura',
    ],
    VocationalCategory.musical: [
      'musica',
      'concierto',
      'instrumento',
      'coral',
      'compositor',
      'discos',
      'leer musica',
      'musico',
      'ritmo',
      'sonido',
      'cantar',
      'cancion',
      'melodia',
    ],
  };
}