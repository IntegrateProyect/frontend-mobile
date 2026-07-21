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

  /// Expone la detección de categoría para poder generar
  /// etiquetas de opciones y escenas visuales con sentido según
  /// el tema real de cada pregunta (no solo según la pantalla
  /// del minijuego en la que vive).
  static VocationalCategory detectCategory(String text) {
    return _detectCategory(text);
  }

  /// Agrupa las preguntas recibidas del backend
  /// en los cuatro minijuegos principales.
  static List<VocationalMiniGameEntity> groupQuestions(
      List<GameQuestionEntity> questions,
      ) {
    final laboratorioQuestions = <GameQuestionEntity>[];
    final consultorioQuestions = <GameQuestionEntity>[];
    final tallerQuestions = <GameQuestionEntity>[];
    final estudioQuestions = <GameQuestionEntity>[];

    for (final question in questions) {
      final category = _detectCategory(question.text);

      switch (category) {
      /*
         * Laboratorio:
         * Cálculo, físico y biológico.
         */
        case VocationalCategory.calculo:
        case VocationalCategory.fisico:
        case VocationalCategory.biologico:
          laboratorioQuestions.add(question);
          break;

      /*
         * Consultorio:
         * Servicio social.
         */
        case VocationalCategory.social:
          consultorioQuestions.add(question);
          break;

      /*
         * Taller:
         * Mecánico.
         */
        case VocationalCategory.mecanico:
          tallerQuestions.add(question);
          break;

      /*
         * Estudio:
         * Artístico y musical.
         */
        case VocationalCategory.artistico:
        case VocationalCategory.musical:
          estudioQuestions.add(question);
          break;

      /*
         * Persuasivo se divide:
         *
         * Liderar, dirigir y organizar -> Taller.
         * Convencer, debatir y defender -> Consultorio.
         */
        case VocationalCategory.persuasivo:
          if (_isLeadershipQuestion(question.text)) {
            tallerQuestions.add(question);
          } else {
            consultorioQuestions.add(question);
          }
          break;

      /*
         * Literario se divide:
         *
         * Escritura creativa -> Estudio.
         * Lectura y comunicación -> Consultorio.
         */
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
        description:
        'Escucha distintas situaciones y decide cómo ayudar.',
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
        description:
        'Arma, repara y organiza las piezas de un dispositivo.',
        categories: const [
          VocationalCategory.mecanico,
          VocationalCategory.persuasivo,
        ],
        questions: tallerQuestions,
      ),
      VocationalMiniGameEntity(
        kind: VocationalGameKind.estudio,
        title: 'Estudio creativo',
        description:
        'Combina colores, figuras, palabras y sonidos.',
        categories: const [
          VocationalCategory.artistico,
          VocationalCategory.musical,
          VocationalCategory.literario,
        ],
        questions: estudioQuestions,
      ),
    ];
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

  static bool _isCreativeLiteraryQuestion(
      String rawText,
      ) {
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

  static VocationalCategory _detectCategory(
      String rawText,
      ) {
    final text = _normalize(rawText);

    for (final entry in _keywords.entries) {
      if (_containsAny(text, entry.value)) {
        return entry.key;
      }
    }

    /*
     * Se conserva Artístico como categoría predeterminada
     * para no perder preguntas que el backend mande
     * sin una categoría identificable.
     */
    return VocationalCategory.artistico;
  }

  static bool _containsAny(
      String text,
      List<String> words,
      ) {
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