import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String get statusKey => category.name;
}

enum MiniGameStatus {
  completed,
  inProgress,
  notStarted,
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

  int _savedIndex = 0;
  Map<String, dynamic> _lastBackendResult = {};
  final Map<String, MiniGameStatus> _miniGameStatus = {};

  List<GameEntity> get games => _games;
  List<GameQuestionEntity> get questions => _questions;
  List<VocationalMiniGame> get miniGames => _miniGames;

  bool get isLoading => _isLoading;
  bool get isLoadingQuestions => _isLoadingQuestions;

  String? get sessionId => _sessionId;
  String? get errorMessage => _errorMessage;
  GameEntity? get activeGame => _activeGame;

  int get savedIndex => _savedIndex;
  Map<String, dynamic> get lastBackendResult => _lastBackendResult;
  Map<String, MiniGameStatus> get miniGameStatus => _miniGameStatus;

  MiniGameStatus getMiniGameStatus(String miniGameKey) {
    return _miniGameStatus[miniGameKey] ?? MiniGameStatus.notStarted;
  }

  Future<void> loadMiniGameStatus(String miniGameKey) async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('game_completed_$miniGameKey') ?? false;
    final savedSession = prefs.getString('game_session_$miniGameKey');
    final savedIndex = prefs.getInt('game_index_$miniGameKey') ?? 0;

    if (isCompleted) {
      _miniGameStatus[miniGameKey] = MiniGameStatus.completed;
    } else if ((savedSession != null && savedSession.isNotEmpty) ||
        savedIndex > 0) {
      _miniGameStatus[miniGameKey] = MiniGameStatus.inProgress;
    } else {
      _miniGameStatus[miniGameKey] = MiniGameStatus.notStarted;
    }

    notifyListeners();
  }

  Future<void> loadAllMiniGameStatus() async {
    final prefs = await SharedPreferences.getInstance();

    for (final miniGame in _miniGames) {
      final key = miniGame.statusKey;
      final isCompleted = prefs.getBool('game_completed_$key') ?? false;
      final savedSession = prefs.getString('game_session_$key');
      final savedIndex = prefs.getInt('game_index_$key') ?? 0;

      if (isCompleted) {
        _miniGameStatus[key] = MiniGameStatus.completed;
      } else if ((savedSession != null && savedSession.isNotEmpty) ||
          savedIndex > 0) {
        _miniGameStatus[key] = MiniGameStatus.inProgress;
      } else {
        _miniGameStatus[key] = MiniGameStatus.notStarted;
      }
    }

    notifyListeners();
  }

  Future<void> fetchGames() async {
    _isLoading = true;
    _errorMessage = null;
    _miniGames = [];
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
    notifyListeners();

    try {
      final allQuestions = await _getQuestionsUseCase(game.id);

      if (allQuestions.isEmpty) {
        _errorMessage = 'Este juego no tiene preguntas disponibles.';
        return;
      }

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

      await loadAllMiniGameStatus();
    } catch (e) {
      _errorMessage = 'No se pudieron dividir las preguntas por categoría.';
      debugPrint('Error prepareMiniGames: $e');
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  Future<void> startSessionIfNeeded(
      String gameId, {
        String? statusKey,
      }) async {
    if (_sessionId != null && _sessionId!.isNotEmpty) return;

    final key = statusKey ?? gameId;
    final prefs = await SharedPreferences.getInstance();

    final savedSession = prefs.getString('game_session_$key');
    final savedQuestionIndex = prefs.getInt('game_index_$key') ?? 0;
    final isCompleted = prefs.getBool('game_completed_$key') ?? false;

    if (isCompleted) {
      _miniGameStatus[key] = MiniGameStatus.completed;
      _savedIndex = 0;
      notifyListeners();
      return;
    }

    if (savedSession != null && savedSession.isNotEmpty) {
      _sessionId = savedSession;
      _savedIndex = savedQuestionIndex;
      _miniGameStatus[key] = MiniGameStatus.inProgress;
      notifyListeners();
      return;
    }

    final startResponse = await _startGameUseCase(gameId);

    _sessionId = startResponse['sessionId']?.toString() ??
        startResponse['data']?['sessionId']?.toString() ??
        startResponse['data']?['id']?.toString() ??
        startResponse['id']?.toString();

    if (_sessionId != null && _sessionId!.isNotEmpty) {
      await prefs.setString('game_session_$key', _sessionId!);
      await prefs.setBool('game_completed_$key', false);
      _miniGameStatus[key] = MiniGameStatus.inProgress;
    } else {
      _miniGameStatus[key] = MiniGameStatus.notStarted;
    }

    _savedIndex = savedQuestionIndex;
    notifyListeners();
  }

  Future<void> selectMiniGame(VocationalMiniGame miniGame) async {
    final prefs = await SharedPreferences.getInstance();
    final key = miniGame.statusKey;

    _questions = miniGame.questions;
    _savedIndex = prefs.getInt('game_index_$key') ?? 0;

    notifyListeners();
  }

  Future<void> saveProgress({
    required String gameId,
    required int currentIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('game_index_$gameId', currentIndex);
    await prefs.setBool('game_completed_$gameId', false);

    _miniGameStatus[gameId] = MiniGameStatus.inProgress;
    notifyListeners();
  }

  Future<void> sendAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
    required int currentIndex,
    String? progressKey,
  }) async {
    final key = progressKey ?? gameId;

    await startSessionIfNeeded(gameId, statusKey: key);

    await _sendAnswerUseCase(gameId, {
      'sessionId': _sessionId,
      'questionId': questionId,
      'selectedOptionId': optionId,
      'rawData': {
        'answerText': answer,
        'weights': weights,
      },
    });

    await saveProgress(
      gameId: key,
      currentIndex: currentIndex,
    );
  }

  Future<Map<String, dynamic>> finishGame(
      String gameId, {
        String? statusKey,
      }) async {
    final key = statusKey ?? gameId;

    await startSessionIfNeeded(gameId, statusKey: key);

    if (_sessionId == null || _sessionId!.isEmpty) {
      return {};
    }

    final result = await _finishGameUseCase(gameId, _sessionId!);

    debugPrint('XXX FINISH GAME RESPONSE: $result');

    final data = _asMap(result['data'] ?? result);
    final backendResult = _asMap(data['result'] ?? data['results'] ?? data);

    _lastBackendResult = backendResult;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_session_$key');
    await prefs.remove('game_index_$key');
    await prefs.setBool('game_completed_$key', true);

    _sessionId = null;
    _savedIndex = 0;
    _miniGameStatus[key] = MiniGameStatus.completed;

    notifyListeners();

    return backendResult;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
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
    _savedIndex = 0;
    _lastBackendResult = {};
    _miniGameStatus.clear();
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
      'primeros auxilios',
      'operación médica',
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
      'televisión',
      'television',
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
      'personas de escasos recursos',
      'hermanos menores',
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
        return 'Retos con números y razonamiento lógico.';
      case VocationalCategory.fisico:
        return 'Explora fenómenos naturales, luz, estrellas y energía.';
      case VocationalCategory.biologico:
        return 'Actividades sobre vida, plantas, salud y laboratorio.';
      case VocationalCategory.mecanico:
        return 'Reparar, armar, instalar y usar herramientas.';
      case VocationalCategory.social:
        return 'Ayudar, escuchar y acompañar a otras personas.';
      case VocationalCategory.literario:
        return 'Lectura, escritura y expresión de ideas.';
      case VocationalCategory.persuasivo:
        return 'Debatir, convencer, liderar y defender ideas.';
      case VocationalCategory.artistico:
        return 'Pintura, dibujo, diseño y creatividad visual.';
      case VocationalCategory.musical:
        return 'Música, instrumentos, conciertos y composición.';
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
