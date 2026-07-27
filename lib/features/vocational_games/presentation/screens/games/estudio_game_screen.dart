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

class EstudioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const EstudioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<EstudioGameScreen> createState() =>
      _EstudioGameScreenState();
}

class _EstudioGameScreenState
    extends State<EstudioGameScreen> {
  late final EstudioFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = EstudioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<EstudioFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF1E1B4B),
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
                  color: const Color(0xFF7C3AED),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EstudioFlameGame extends FlameGame {
  final BuildContext context;
  final GameEntity gameEntity;
  final String miniGameKey;

  late final TextComponent questionText;
  late final TextComponent instructionText;
  late final CreativeCanvasComponent canvas;

  final List<CreativeOptionComponent> activeOptions = [];
  final ValueNotifier<int> streakNotifier = ValueNotifier<int>(0);
  final Random _rng = Random();

  bool _textsCreated = false;
  bool _isSubmitting = false;

  EstudioFlameGame({
    required this.context,
    required this.gameEntity,
    required this.miniGameKey,
  });

  @override
  Color backgroundColor() {
    return const Color(0xFFF5F3FF);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      AmbientFloaters(color: const Color(0xFFB39DDB)),
    );

    add(
      TextComponent(
        text: 'Estudio creativo',
        position: Vector2(size.x / 2, 65),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF1E1B4B),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      PulsingTargetRing(
        position: Vector2(size.x / 2, size.y / 2 - 20),
        color: const Color(0xFF8B5CF6),
        baseRadius: 120,
      ),
    );

    canvas = CreativeCanvasComponent(
      position: Vector2(
        size.x / 2,
        size.y / 2 - 20,
      ),
    );

    add(canvas);

    // Espera a que CreativeCanvasComponent.onLoad() inicialice
    // sus componentes late, incluidos _label y _badge.
    await canvas.loaded;

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

    // Tematiza el lienzo según la categoría real de la pregunta.
    canvas.updateContent(currentQuestion.text);

    for (final option in activeOptions) {
      option.removeFromParent();
    }

    activeOptions.clear();

    if (!_textsCreated) {
      questionText = TextComponent(
        text: currentQuestion.text,
        position: Vector2(size.x / 2, 120),
        anchor: Anchor.center,
        size: Vector2(size.x - 50, 65),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF1E1B4B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una idea y arrástrala hasta el lienzo',
        position: Vector2(size.x / 2, 170),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.grey,
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
      const Color(0xFF818CF8),
      const Color(0xFFF472B6),
      const Color(0xFF34D399),
      const Color(0xFFFB923C),
      const Color(0xFFA78BFA),
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

      final component = CreativeOptionComponent(
        option: option,
        color: colors[index % colors.length],
        category: category,
        position: Vector2(
          xPosition,
          size.y - 115,
        ),
        onSelected: _submitAnswer,
      );

      activeOptions.add(component);
      add(component);
    }
  }

  Future<void> _submitAnswer(
      GameQuestionOptionEntity option,
      CreativeOptionComponent piece,
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
        position: canvas.position.clone(),
        color: piece.color,
      ),
    );

    canvas.reactToAnswer(piece.color);

    add(
      FloatingPraise(
        position: canvas.position - Vector2(0, 120),
        text: randomPraise(_rng),
        color: const Color(0xFF6D28D9),
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

        if (provider.areAllGamesCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameResultScreen(
                result: result,
              ),
            ),
          );
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('¡Minijuego completado! Completa los demás para ver tus resultados.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
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

/// Lienzo central. Cada acierto agrega una "pincelada" de color
/// nueva y hace un pequeño rebote. El badge y la etiqueta cambian
/// según la categoría real de cada pregunta (arte, música,
/// escritura creativa, etc.).
class CreativeCanvasComponent extends PositionComponent {
  final List<CircleComponent> _strokes = [];
  final Random _rng = Random();
  late TextComponent _label;
  late TextComponent _badge;

  VocationalCategory _currentCategory = VocationalCategory.artistico;

  CreativeCanvasComponent({
    required Vector2 position,
  }) : super(
    position: position,
    size: Vector2(220, 210),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleComponent(
        position: Vector2(5, 6),
        size: size,
        paint: Paint()..color = Colors.black.withOpacity(0.10),
      ),
    );

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.white,
      ),
    );

    add(
      RectangleComponent(
        size: Vector2(size.x, 16),
        paint: Paint()..color = const Color(0xFF818CF8),
      ),
    );

    add(
      CircleComponent(
        radius: 30,
        position: Vector2(60, 85),
        paint: Paint()
          ..color = const Color(0xFFF472B6).withOpacity(0.35),
      ),
    );

    add(
      CircleComponent(
        radius: 38,
        position: Vector2(125, 105),
        paint: Paint()
          ..color = const Color(0xFF34D399).withOpacity(0.30),
      ),
    );

    add(
      CircleComponent(
        radius: 24,
        position: Vector2(165, 65),
        paint: Paint()
          ..color = const Color(0xFFFB923C).withOpacity(0.35),
      ),
    );

    _badge = TextComponent(
      text: '🎨',
      position: Vector2(size.x - 24, 40),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 26),
      ),
    );
    add(_badge);

    _label = TextComponent(
      text: 'LIENZO',
      position: Vector2(size.x / 2, size.y - 30),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF6366F1),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_label);
  }

  /// Tematiza el lienzo: pincel para arte, nota para música,
  /// pluma para escritura creativa, etc.
  void updateContent(String questionText) {
    _currentCategory = GameMapper.detectCategory(questionText);
    _badge.text = _emojiFor(_currentCategory);
  }

  void reactToAnswer(Color color) {
    final stroke = CircleComponent(
      radius: 12 + _rng.nextDouble() * 14,
      position: Vector2(
        20 + _rng.nextDouble() * (size.x - 40),
        30 + _rng.nextDouble() * (size.y - 70),
      ),
      anchor: Anchor.center,
      paint: Paint()..color = color.withOpacity(0.5),
    );

    add(stroke);
    _strokes.add(stroke);

    _label.text = _strokes.length >= 3 ? '¡OBRA DE ARTE!' : 'LIENZO';

    add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.08),
            EffectController(duration: 0.13, curve: Curves.easeOut),
          ),
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.24, curve: Curves.elasticOut),
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

/// Opción arrastrable. Respira suavemente en reposo.
class CreativeOptionComponent extends PositionComponent
    with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;

  final void Function(
      GameQuestionOptionEntity option,
      CreativeOptionComponent piece,
      ) onSelected;

  late final Vector2 originalPosition;

  bool _isDragging = false;
  bool _wasSubmitted = false;

  CreativeOptionComponent({
    required this.option,
    required this.color,
    required this.category,
    required Vector2 position,
    required this.onSelected,
  }) : super(
    position: position,
    size: Vector2(85, 105),
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
      CircleComponent(
        radius: 35,
        position: Vector2(size.x / 2 + 3, 38),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.black.withOpacity(0.15),
      ),
    );

    add(
      CircleComponent(
        radius: 35,
        position: Vector2(size.x / 2, 35),
        anchor: Anchor.center,
        paint: Paint()..color = color,
      ),
    );

    add(
      TextComponent(
        text: '✦',
        position: Vector2(size.x / 2, 35),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      TextComponent(
        text: GameOptionLabels.fromOriginal(
          originalText: option.text,
          category: category,
        ),
        position: Vector2(size.x / 2, 88),
        anchor: Anchor.center,
        size: Vector2(82, 35),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF1E1B4B),
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

    if (parentComponent is! EstudioFlameGame) {
      returnToOriginalPosition();
      return;
    }

    final canvasPosition = Vector2(
      parentComponent.size.x / 2,
      parentComponent.size.y / 2 - 20,
    );

    final distanceToCanvas = position.distanceTo(canvasPosition);

    if (distanceToCanvas <= 135) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      playSuccessBounce();
      position.setFrom(canvasPosition);
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