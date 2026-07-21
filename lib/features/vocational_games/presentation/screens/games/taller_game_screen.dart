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

class TallerGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const TallerGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<TallerGameScreen> createState() => _TallerGameScreenState();
}

class _TallerGameScreenState extends State<TallerGameScreen> {
  late final TallerFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = TallerFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<TallerFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF3E2723),
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
                  color: const Color(0xFF6D4C41),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TallerFlameGame extends FlameGame {
  final BuildContext context;
  final GameEntity gameEntity;
  final String miniGameKey;

  late final TextComponent questionText;
  late final TextComponent instructionText;
  late final AssemblyAreaComponent assembly;

  final List<PieceComponent> activeOptions = [];
  final ValueNotifier<int> streakNotifier = ValueNotifier<int>(0);
  final Random _rng = Random();

  bool _textsCreated = false;
  bool _isSubmitting = false;

  TallerFlameGame({
    required this.context,
    required this.gameEntity,
    required this.miniGameKey,
  });

  @override
  Color backgroundColor() {
    return const Color(0xFFEFEBE9);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      AmbientFloaters(color: const Color(0xFFBCAAA4)),
    );

    add(
      TextComponent(
        text: 'Taller de habilidades',
        position: Vector2(size.x / 2, 65),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      PulsingTargetRing(
        position: Vector2(size.x / 2, size.y / 2 - 20),
        color: const Color(0xFF8D6E63),
        baseRadius: 78,
      ),
    );

    assembly = AssemblyAreaComponent(
      position: Vector2(
        size.x / 2,
        size.y / 2 - 20,
      ),
    );

    add(assembly);

    // Flame agrega componentes de forma asíncrona. Esperamos a que
    // AssemblyAreaComponent.onLoad() inicialice _gear y _innerFill.
    await assembly.loaded;

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
      _showMessage('No hay preguntas disponibles.');
      return;
    }

    if (provider.savedIndex < 0 ||
        provider.savedIndex >= provider.questions.length) {
      return;
    }

    final currentQuestion =
    provider.questions[provider.savedIndex];

    // Tematiza el engrane/área de ensamble según la categoría real.
    assembly.updateContent(currentQuestion.text);

    for (final option in activeOptions) {
      option.removeFromParent();
    }

    activeOptions.clear();

    if (!_textsCreated) {
      questionText = TextComponent(
        text: currentQuestion.text,
        position: Vector2(size.x / 2, 125),
        anchor: Anchor.center,
        size: Vector2(size.x - 60, 70),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una pieza y colócala en el mecanismo',
        position: Vector2(size.x / 2, 180),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.brown,
            fontSize: 13,
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

  void _loadOptions(GameQuestionEntity question) {
    final colors = <Color>[
      Colors.blueGrey,
      Colors.orange.shade700,
      Colors.cyan.shade700,
      Colors.deepOrange.shade400,
    ];

    if (question.options.isEmpty) {
      _showMessage('Esta pregunta no tiene opciones.');
      return;
    }

    final category = GameMapper.detectCategory(question.text);

    final double availableWidth = size.x - 40;
    final double spacing =
        availableWidth / question.options.length;

    for (int i = 0; i < question.options.length; i++) {
      final option = question.options[i];

      final double xPosition =
          20 + (spacing * i) + (spacing / 2);

      final component = PieceComponent(
        option: option,
        color: colors[i % colors.length],
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
      PieceComponent piece,
      ) async {
    if (_isSubmitting || !context.mounted) {
      return;
    }

    _isSubmitting = true;

    final provider = context.read<GamesProvider>();
    final currentIndex = provider.savedIndex;

    if (currentIndex < 0 ||
        currentIndex >= provider.questions.length) {
      _isSubmitting = false;
      return;
    }

    add(
      BurstParticles(
        position: assembly.position.clone(),
        color: const Color(0xFF8D6E63),
      ),
    );

    assembly.reactToAnswer();

    add(
      FloatingPraise(
        position: assembly.position - Vector2(0, 100),
        text: randomPraise(_rng),
        color: const Color(0xFF4E342E),
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
      debugPrint('Error al enviar la respuesta: $error');
      debugPrintStack(stackTrace: stackTrace);

      _isSubmitting = false;
      streakNotifier.value = 0;

      for (final piece in activeOptions) {
        piece.returnToOriginalPosition();
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

/// Área central donde el usuario suelta la pieza. El emoji central
/// y el color cambian según la categoría real de cada pregunta;
/// solo rota como engrane cuando la categoría es mecánica.
class AssemblyAreaComponent extends PositionComponent {
  late TextComponent _gear;
  late CircleComponent _innerFill;

  final List<Color> _fillColors = [
    const Color(0xFFBCAAA4),
    const Color(0xFF80CBC4),
    const Color(0xFFFFCC80),
    const Color(0xFF90CAF9),
  ];

  int _reactionCount = 0;
  double _rotation = 0;
  VocationalCategory _currentCategory = VocationalCategory.mecanico;

  AssemblyAreaComponent({
    required Vector2 position,
  }) : super(
    position: position,
    size: Vector2(150, 150),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      CircleComponent(
        radius: 70,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()
          ..color = Colors.grey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8,
      ),
    );

    _innerFill = CircleComponent(
      radius: 42,
      position: size / 2,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.brown.withOpacity(0.12)
        ..style = PaintingStyle.fill,
    );
    add(_innerFill);

    _gear = TextComponent(
      text: '⚙️',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 45,
          color: Color(0xFF6D4C41),
        ),
      ),
    );
    add(_gear);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rotation += dt * 0.3;

    // Solo el engrane (mecánico) tiene sentido rotando.
    if (_currentCategory == VocationalCategory.mecanico) {
      _gear.angle = _rotation;
    }
  }

  /// Cambia el emoji del área central: engrane si es mecánico,
  /// megáfono si es liderazgo/persuasión, etc.
  void updateContent(String questionText) {
    _currentCategory = GameMapper.detectCategory(questionText);
    _gear.text = _emojiFor(_currentCategory);

    if (_currentCategory != VocationalCategory.mecanico) {
      _gear.angle = 0;
    }
  }

  void reactToAnswer() {
    _reactionCount++;

    _innerFill.paint = Paint()
      ..color = _fillColors[_reactionCount % _fillColors.length]
          .withOpacity(0.28);

    add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.14),
            EffectController(duration: 0.13, curve: Curves.easeOut),
          ),
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.26, curve: Curves.elasticOut),
          ),
        ],
      ),
    );

    if (_currentCategory == VocationalCategory.mecanico) {
      _gear.add(
        RotateEffect.by(
          pi / 2,
          EffectController(duration: 0.35, curve: Curves.easeOutBack),
        ),
      );
    }
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

/// Pieza que puede arrastrarse. Respira suavemente en reposo.
class PieceComponent extends PositionComponent
    with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;

  final void Function(
      GameQuestionOptionEntity option,
      PieceComponent piece,
      ) onSelected;

  late final Vector2 originalPosition;

  bool _isDragging = false;
  bool _wasSubmitted = false;

  PieceComponent({
    required this.option,
    required this.color,
    required this.category,
    required Vector2 position,
    required this.onSelected,
  }) : super(
    position: position,
    size: Vector2(85, 100),
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
        size: Vector2(58, 58),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.black.withOpacity(0.18),
      ),
    );

    add(
      RectangleComponent(
        position: Vector2(size.x / 2, 25),
        size: Vector2(58, 58),
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
        position: Vector2(size.x / 2, 72),
        anchor: Anchor.center,
        size: Vector2(80, 36),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF3E2723),
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

    if (parentComponent is! TallerFlameGame) {
      returnToOriginalPosition();
      return;
    }

    final targetPosition = Vector2(
      parentComponent.size.x / 2,
      parentComponent.size.y / 2 - 20,
    );

    final distanceToTarget = position.distanceTo(targetPosition);

    if (distanceToTarget <= 100) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      playSuccessBounce();
      position.setFrom(targetPosition);
      onSelected(option, this);
    } else {
      scale = Vector2.all(1);
      returnToOriginalPosition();
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);

    _isDragging = false;
    scale = Vector2.all(1);

    returnToOriginalPosition();
  }

  void returnToOriginalPosition() {
    _wasSubmitted = false;
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
            color: Colors.black.withOpacity(0.15),
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