import 'package:flutter/material.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/usecases/get_available_games_usecase.dart';
import '../../domain/usecases/get_game_questions_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';
import '../../domain/usecases/send_game_answer_usecase.dart';
import '../../domain/usecases/finish_game_usecase.dart';

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

class VocationalMiniGame {
  final VocationalCategory category;
  final String title;
  final String description;
  final IconData icon;
  final List<GameQuestionEntity> questions;

  VocationalMiniGame({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.questions,
  });
}

class GamesProvider extends ChangeNotifier {
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetGameQuestionsUseCase _getQuestionsUseCase;
  final StartGameUseCase _startGameUseCase;
  final SendGameAnswerUseCase _sendAnswerUseCase;
  final FinishGameUseCase _finishGameUseCase;

  GamesProvider({
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetGameQuestionsUseCase getQuestionsUseCase,
    required StartGameUseCase startGameUseCase,
    required SendGameAnswerUseCase sendAnswerUseCase,
    required FinishGameUseCase finishGameUseCase,
  })  : _getGamesUseCase = getGamesUseCase,
        _getQuestionsUseCase = getQuestionsUseCase,
        _startGameUseCase = startGameUseCase,
        _sendAnswerUseCase = sendAnswerUseCase,
        _finishGameUseCase = finishGameUseCase;

  List<GameEntity> _games = [];
  List<GameQuestionEntity> _questions = [];
  List<VocationalMiniGame> _miniGames = [];

  bool _isLoading = false;
  bool _isLoadingQuestions = false;
  String? _sessionId;
  String? _errorMessage;
  GameEntity? _activeGame;

  List<GameEntity> get games => _games;
  List<GameQuestionEntity> get questions => _questions;
  List<VocationalMiniGame> get miniGames => _miniGames;

  bool get isLoading => _isLoading;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get sessionId => _sessionId;
  String? get errorMessage => _errorMessage;
  GameEntity? get activeGame => _activeGame;

  Future<void> fetchGames() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _games = await _getGamesUseCase();

      if (_games.isNotEmpty) {
        await prepareMiniGames(_games.first);
      }
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los minijuegos.';
      debugPrint('Error fetchGames: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> prepareMiniGames(GameEntity game) async {
    _isLoadingQuestions = true;
    _errorMessage = null;
    _activeGame = game;
    _questions = [];
    _miniGames = [];
    _sessionId = null;
    notifyListeners();

    try {
      final startResponse = await _startGameUseCase(game.id);

      _sessionId = startResponse['sessionId']?.toString() ??
          startResponse['data']?['sessionId']?.toString() ??
          startResponse['data']?['id']?.toString();

      final allQuestions = await _getQuestionsUseCase(game.id);

      final grouped = <VocationalCategory, List<GameQuestionEntity>>{};

      for (final question in allQuestions) {
        final category = detectCategory(question.text);
        grouped.putIfAbsent(category, () => []);
        grouped[category]!.add(question);
      }

      _miniGames = grouped.entries
          .where((entry) => entry.value.isNotEmpty)
          .map(
            (entry) => VocationalMiniGame(
          category: entry.key,
          title: _categoryTitle(entry.key),
          description: _categoryDescription(entry.key),
          icon: _categoryIcon(entry.key),
          questions: entry.value,
        ),
      )
          .toList();

      _miniGames.sort((a, b) => a.title.compareTo(b.title));
    } catch (e) {
      _errorMessage = 'No se pudieron dividir las preguntas por categoría.';
      debugPrint('Error prepareMiniGames: $e');
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  void selectMiniGame(VocationalMiniGame miniGame) {
    _questions = miniGame.questions;
    notifyListeners();
  }

  Future<void> sendAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
  }) async {
    await _sendAnswerUseCase(gameId, {
      'sessionId': _sessionId,
      'questionId': questionId,
      'optionId': optionId,
      'answer': answer,
      'weights': weights,
    });
  }

  Future<void> finishGame(String gameId) async {
    if (_sessionId == null || _sessionId!.isEmpty) return;
    await _finishGameUseCase(gameId, _sessionId!);
  }

  void clearQuestions() {
    _questions = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearAllGameData() {
    _questions = [];
    _miniGames = [];
    _sessionId = null;
    _activeGame = null;
    _errorMessage = null;
    notifyListeners();
  }

  VocationalCategory detectCategory(String raw) {
    final text = raw.toLowerCase();

    if (_has(text, [
      'calcular',
      'aritmética',
      'aritmetica',
      'numérico',
      'numerico',
      'porcentajes',
      'logaritmos',
      'matemáticos',
      'matematicos',
      'área',
      'area',
      'grados',
      'radios',
      'mecanizaciones',
      'regla de cálculo',
      'problemas matemáticos',
    ])) {
      return VocationalCategory.calculo;
    }

    if (_has(text, [
      'eclipse',
      'telescopio',
      'estrellas',
      'observatorio',
      'energía atómica',
      'energia atomica',
      'rocas',
      'espectro',
      'luz',
      'combustión',
      'combustion',
      'tiempo y sus causas',
      'exposición científica',
      'científica',
      'cientifica',
    ])) {
      return VocationalCategory.fisico;
    }

    if (_has(text, [
      'sangre',
      'plantas',
      'abejas',
      'insectos',
      'hormigas',
      'organismos',
      'acuario',
      'oxígeno',
      'oxigeno',
      'vida',
      'primeros auxilios',
      'operación médica',
      'operacion medica',
    ])) {
      return VocationalCategory.biologico;
    }

    if (_has(text, [
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
      'radio',
      'televisión',
      'television',
      'contacto eléctrico',
      'contacto electrico',
      'dibujos de máquinas',
      'dibujos de maquinas',
    ])) {
      return VocationalCategory.mecanico;
    }

    if (_has(text, [
      'ayudar',
      'orfelinatos',
      'consejero',
      'niños',
      'ninos',
      'ciegos',
      'escuchar',
      'servir',
      'problemas',
      'club de niños',
      'casas humildes',
      'hermanos menores',
      'personas de escasos recursos',
      'bien de ellos',
    ])) {
      return VocationalCategory.social;
    }

    if (_has(text, [
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
      'concursos literarios',
      'composiciones',
    ])) {
      return VocationalCategory.literario;
    }

    if (_has(text, [
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
    ])) {
      return VocationalCategory.persuasivo;
    }

    if (_has(text, [
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
      'delinear',
      'exposiciones de pintura',
    ])) {
      return VocationalCategory.artistico;
    }

    if (_has(text, [
      'música',
      'musica',
      'concierto',
      'instrumento',
      'coral',
      'compositor',
      'discos',
      'leer música',
      'leer musica',
      'buena música',
      'buena musica',
      'músico',
      'musico',
    ])) {
      return VocationalCategory.musical;
    }

    return VocationalCategory.artistico;
  }

  bool _has(String text, List<String> words) {
    return words.any((word) => text.contains(word));
  }

  String _categoryTitle(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return 'Juego de lógica y cálculo';
      case VocationalCategory.fisico:
        return 'Juego científico físico';
      case VocationalCategory.biologico:
        return 'Juego biológico';
      case VocationalCategory.mecanico:
        return 'Juego mecánico';
      case VocationalCategory.social:
        return 'Juego de servicio social';
      case VocationalCategory.literario:
        return 'Juego literario';
      case VocationalCategory.persuasivo:
        return 'Juego persuasivo';
      case VocationalCategory.artistico:
        return 'Juego artístico';
      case VocationalCategory.musical:
        return 'Juego musical';
    }
  }

  String _categoryDescription(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return 'Retos con números, porcentajes, áreas y razonamiento lógico.';
      case VocationalCategory.fisico:
        return 'Explora estrellas, eclipses, luz, energía y fenómenos naturales.';
      case VocationalCategory.biologico:
        return 'Actividades sobre vida, plantas, animales, salud y laboratorio.';
      case VocationalCategory.mecanico:
        return 'Reparar, armar, instalar y trabajar con herramientas.';
      case VocationalCategory.social:
        return 'Ayudar, escuchar, acompañar y servir a otras personas.';
      case VocationalCategory.literario:
        return 'Lectura, escritura, cuentos, novelas y expresión de ideas.';
      case VocationalCategory.persuasivo:
        return 'Debatir, convencer, liderar, dirigir y defender ideas.';
      case VocationalCategory.artistico:
        return 'Pintura, dibujo, diseño, decoración y creatividad visual.';
      case VocationalCategory.musical:
        return 'Música, instrumentos, conciertos, canto y composición.';
    }
  }

  IconData _categoryIcon(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return Icons.calculate_outlined;
      case VocationalCategory.fisico:
        return Icons.public_outlined;
      case VocationalCategory.biologico:
        return Icons.biotech_outlined;
      case VocationalCategory.mecanico:
        return Icons.build_outlined;
      case VocationalCategory.social:
        return Icons.volunteer_activism_outlined;
      case VocationalCategory.literario:
        return Icons.menu_book_outlined;
      case VocationalCategory.persuasivo:
        return Icons.campaign_outlined;
      case VocationalCategory.artistico:
        return Icons.palette_outlined;
      case VocationalCategory.musical:
        return Icons.music_note_outlined;
    }
  }
}