import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/datasources/mappers/game_mapper.dart';
import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';
import '../../../domain/entities/vocational_mini_game_entity.dart';
import '../../providers/games_provider.dart';
import '../game_result_screen.dart';
import 'game_fx.dart';
import 'game_option_labels.dart';

class ConsultorioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const ConsultorioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<ConsultorioGameScreen> createState() =>
      _ConsultorioGameScreenState();
}

class _ConsultorioGameScreenState
    extends State<ConsultorioGameScreen> {
  late final ConsultorioFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = ConsultorioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<ConsultorioFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF0D47A1),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 16,
            child: ValueListenableBuilder<int>(
              valueListenable: _game.streakNotifier,
              builder: (context, streak, _) {
                return StreakBadge(
                  streak: streak,
                  color: const Color(0xFF1565C0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultorioFlameGame extends FlameGame {
  final BuildContext context;
  final GameEntity gameEntity;
  final String miniGameKey;

  late final TextComponent questionText;
  late final TextComponent instructionText;
  late final PatientComponent patient;

  final List<HelpOptionComponent> activeOptions = [];
  final ValueNotifier<int> streakNotifier = ValueNotifier<int>(0);
  final Random _rng = Random();

  bool _textsCreated = false;
  bool _isSubmitting = false;

  ConsultorioFlameGame({
    required this.context,
    required this.gameEntity,
    required this.miniGameKey,
  });

  @override
  Color backgroundColor() {
    return const Color(0xFFE3F2FD);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      AmbientFloaters(color: const Color(0xFF64B5F6)),
    );

    add(
      TextComponent(
        text: 'Consultorio',
        position: Vector2(size.x / 2, 65),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF0D47A1),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      PulsingTargetRing(
        position: Vector2(size.x / 2, size.y / 2 - 30),
        color: const Color(0xFF1976D2),
        baseRadius: 80,
      ),
    );

    patient = PatientComponent(
      position: Vector2(
        size.x / 2,
        size.y / 2 - 30,
      ),
    );

    add(patient);

    // Espera a que PatientComponent.onLoad() inicialice
    // los ojos, el estado de ánimo y la insignia.
    await patient.loaded;

    if (!context.mounted) {
      return;
    }

    _updateGameStage();
  }

  void _updateGameStage() {
    if (!context.mounted) {
      return;
    }

    final provider = context.read<GamesProvider>();

    if (provider.questions.isEmpty) {
      _showMessage(
        'No hay preguntas disponibles.',
      );
      return;
    }

    if (provider.savedIndex < 0 ||
        provider.savedIndex >= provider.questions.length) {
      return;
    }

    final currentQuestion =
    provider.questions[provider.savedIndex];

    // Tematiza el badge del paciente según la categoría real.
    patient.updateContent(currentQuestion.text);

    for (final option in activeOptions) {
      option.removeFromParent();
    }

    activeOptions.clear();

    if (!_textsCreated) {
      questionText = TextComponent(
        text: currentQuestion.text,
        position: Vector2(size.x / 2, 120),
        anchor: Anchor.center,
        size: Vector2(size.x - 50, 60),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF0D47A1),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una acción y llévala hasta la persona',
        position: Vector2(size.x / 2, 170),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
          ),
        ),
      );

      add(questionText);
      add(instructionText);

      _textsCreated = true;
    } else {
      questionText.text = currentQuestion.text;
    }

    _loadOptions(currentQuestion);
  }

  void _loadOptions(
      GameQuestionEntity question,
      ) {
    if (question.options.isEmpty) {
      _showMessage(
        'Esta pregunta no tiene opciones.',
      );
      return;
    }

    final category = GameMapper.detectCategory(question.text);

    final colors = <Color>[
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];

    final double availableWidth = size.x - 30;

    final double spacing =
        availableWidth / question.options.length;

    for (int index = 0;
    index < question.options.length;
    index++) {
      final option = question.options[index];

      final double xPosition =
          15 + (spacing * index) + (spacing / 2);

      final component = HelpOptionComponent(
        option: option,
        color: colors[index % colors.length],
        category: category,
        position: Vector2(
          xPosition,
          size.y - 110,
        ),
        onSelected: _submitAnswer,
      );

      activeOptions.add(component);
      add(component);
    }
  }

  Future<void> _submitAnswer(
      GameQuestionOptionEntity option,
      HelpOptionComponent piece,
      ) async {
    if (_isSubmitting || !context.mounted) {
      return;
    }

    final provider = context.read<GamesProvider>();
    final currentIndex = provider.savedIndex;

    if (currentIndex < 0 ||
        currentIndex >= provider.questions.length) {
      return;
    }

    _isSubmitting = true;

    add(
      BurstParticles(
        position: patient.position.clone(),
        color: const Color(0xFF42A5F5),
      ),
    );

    patient.reactToAnswer();

    add(
      FloatingPraise(
        position: patient.position - Vector2(0, 100),
        text: randomPraise(_rng),
        color: const Color(0xFF0D47A1),
      ),
    );

    streakNotifier.value += 1;

    try {
      final currentQuestion =
      provider.questions[currentIndex];

      await provider.sendAnswer(
        gameId: gameEntity.id,
        questionId: currentQuestion.id,
        optionId: option.id,
        answer: option.text,
        weights: option.weights,
        currentIndex: currentIndex + 1,
        progressKey: miniGameKey,
      );

      if (!context.mounted) {
        return;
      }

      if (currentIndex + 1 < provider.questions.length) {
        _isSubmitting = false;
        _updateGameStage();
      } else {
        final result = await provider.finishGame(
          gameEntity.id,
          statusKey: miniGameKey,
        );

        if (!context.mounted) {
          return;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              result: result,
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error al enviar la respuesta: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _isSubmitting = false;
      streakNotifier.value = 0;

      for (final option in activeOptions) {
        option.returnToOriginalPosition();
      }

      _showMessage(
        'No se pudo guardar la respuesta. Inténtalo nuevamente.',
      );
    }
  }

  void _showMessage(String message) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// Personaje que representa al paciente. Sonríe (cambia de
/// expresión) y rebota levemente cada vez que se le ayuda, y
/// muestra un badge temático según la categoría real de cada
/// pregunta (escuchar, orientar, debatir, liderar, etc.).
class PatientComponent extends PositionComponent {
  late CircleComponent _leftEye;
  late CircleComponent _rightEye;
  late TextComponent _mood;
  late TextComponent _badge;

  int _reactionCount = 0;
  VocationalCategory _currentCategory = VocationalCategory.social;

  PatientComponent({
    required Vector2 position,
  }) : super(
    position: position,
    size: Vector2(150, 180),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      CircleComponent(
        radius: 53,
        position: Vector2(size.x / 2 + 3, 62),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.black.withOpacity(0.12),
      ),
    );

    add(
      CircleComponent(
        radius: 50,
        position: Vector2(size.x / 2, 58),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.blue.shade200,
      ),
    );

    _leftEye = CircleComponent(
      radius: 4,
      position: Vector2(size.x / 2 - 18, 50),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF0D47A1),
    );
    add(_leftEye);

    _rightEye = CircleComponent(
      radius: 4,
      position: Vector2(size.x / 2 + 18, 50),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF0D47A1),
    );
    add(_rightEye);

    add(
      RectangleComponent(
        position: Vector2(size.x / 2, 125),
        size: Vector2(90, 80),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.blue.shade400,
      ),
    );

    _badge = TextComponent(
      text: '🤝',
      position: Vector2(size.x - 5, 25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24),
      ),
    );
    add(_badge);

    _mood = TextComponent(
      text: '+',
      position: Vector2(size.x / 2, 123),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_mood);
  }

  /// Cambia el badge según la categoría real de la pregunta.
  void updateContent(String questionText) {
    _currentCategory = GameMapper.detectCategory(questionText);
    _badge.text = _emojiFor(_currentCategory);
  }

  void reactToAnswer() {
    _reactionCount++;
    _mood.text = _reactionCount % 2 == 0 ? '☺' : '+';

    add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(duration: 0.13, curve: Curves.easeOut),
          ),
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.25, curve: Curves.elasticOut),
          ),
        ],
      ),
    );
  }

  String _emojiFor(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return '🧮';
      case VocationalCategory.fisico:
        return '🪐';
      case VocationalCategory.biologico:
        return '🧬';
      case VocationalCategory.mecanico:
        return '⚙️';
      case VocationalCategory.social:
        return '🤝';
      case VocationalCategory.literario:
        return '📖';
      case VocationalCategory.persuasivo:
        return '📢';
      case VocationalCategory.artistico:
        return '🎨';
      case VocationalCategory.musical:
        return '🎵';
    }
  }
}

/// Opción que el usuario puede arrastrar. Respira suavemente
/// mientras espera a que la elijan.
class HelpOptionComponent extends PositionComponent
    with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;

  final void Function(
      GameQuestionOptionEntity option,
      HelpOptionComponent piece,
      ) onSelected;

  late final Vector2 originalPosition;

  bool _isDragging = false;
  bool _wasSubmitted = false;

  HelpOptionComponent({
    required this.option,
    required this.color,
    required this.category,
    required Vector2 position,
    required this.onSelected,
  }) : super(
    position: position,
    size: Vector2(90, 90),
    anchor: Anchor.center,
  ) {
    originalPosition = position.clone();
  }

  @override
  bool get isIdleAnimated => !_isDragging && !_wasSubmitted;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleComponent(
        position: Vector2(size.x / 2 + 3, 28),
        size: Vector2(75, 45),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.black.withOpacity(0.15),
      ),
    );

    add(
      RectangleComponent(
        position: Vector2(size.x / 2, 25),
        size: Vector2(75, 45),
        anchor: Anchor.center,
        paint: Paint()..color = color,
      ),
    );

    add(
      TextComponent(
        text: GameOptionLabels.fromOriginal(
          originalText: option.text,
          category: category,
        ),
        position: Vector2(size.x / 2, 67),
        anchor: Anchor.center,
        size: Vector2(88, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    if (_wasSubmitted) {
      return;
    }

    _isDragging = true;
    scale = Vector2.all(1.08);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || _wasSubmitted) {
      return;
    }

    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    if (!_isDragging || _wasSubmitted) {
      return;
    }

    _isDragging = false;

    final parentComponent = parent;

    if (parentComponent is! ConsultorioFlameGame) {
      returnToOriginalPosition();
      return;
    }

    final patientPosition = Vector2(
      parentComponent.size.x / 2,
      parentComponent.size.y / 2 - 30,
    );

    final distanceToPatient = position.distanceTo(patientPosition);

    if (distanceToPatient < 110) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      playSuccessBounce();
      position.setFrom(patientPosition);
      onSelected(option, this);
    } else {
      scale = Vector2.all(1);
      returnToOriginalPosition();
    }
  }

  void returnToOriginalPosition() {
    _isDragging = false;
    _wasSubmitted = false;
    scale = Vector2.all(1);
    position.setFrom(originalPosition);
  }
}

class _ExitButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ExitButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        tooltip: 'Salir',
        icon: Icon(Icons.close, color: color),
        onPressed: onTap,
      ),
    );
  }
}