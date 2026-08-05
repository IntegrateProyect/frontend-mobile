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

import '../../providers/game_persistence_provider.dart';
import '../../providers/game_play_provider.dart';
import '../../providers/games_provider.dart';
import '../game_result_screen.dart';
import 'game_fx.dart';
import 'game_option_labels.dart';

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
  Color backgroundColor() => const Color(0xFFF5F3FF);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(AmbientFloaters(color: const Color(0xFFB39DDB)));

    add(TextComponent(
      text: 'Estudio creativo',
      position: Vector2(size.x / 2, 65),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF1E1B4B), fontSize: 23, fontWeight: FontWeight.bold),
      ),
    ));

    add(PulsingTargetRing(
      position: Vector2(size.x / 2, size.y / 2 - 20),
      color: const Color(0xFF8B5CF6),
      baseRadius: 120,
    ));

    canvas = CreativeCanvasComponent(position: Vector2(size.x / 2, size.y / 2 - 20));
    add(canvas);

    await canvas.loaded;
    _updateGameStage();
  }

  void _updateGameStage() {
    final playProvider = context.read<GamePlayProvider>();
    if (playProvider.questions.isEmpty) return;
    if (playProvider.currentIndex >= playProvider.questions.length) return;

    final currentQuestion = playProvider.questions[playProvider.currentIndex];
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
          style: const TextStyle(color: Color(0xFF1E1B4B), fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una idea y arrástrala hasta el lienzo',
        position: Vector2(size.x / 2, 170),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    final category = GameMapper.detectCategory(question.text);
    final colors = [const Color(0xFF818CF8), const Color(0xFFF472B6), const Color(0xFF34D399), const Color(0xFFFB923C), const Color(0xFFA78BFA)];
    final double spacing = (size.x - 30) / question.options.length;

    for (int i = 0; i < question.options.length; i++) {
      final option = question.options[i];
      final double xPosition = 15 + (spacing * i) + (spacing / 2);

      final component = CreativeOptionComponent(
        option: option,
        color: colors[i % colors.length],
        category: category,
        position: Vector2(xPosition, size.y - 115),
        onSelected: _submitAnswer,
      );
      activeOptions.add(component);
      add(component);
    }
  }

  Future<void> _submitAnswer(GameQuestionOptionEntity option, CreativeOptionComponent piece) async {
    if (_isSubmitting || !context.mounted) return;

    final playProvider = context.read<GamePlayProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    
    _isSubmitting = true;
    canvas.reactToAnswer(piece.color);
    add(FloatingPraise(position: canvas.position - Vector2(0, 120), text: randomPraise(_rng), color: const Color(0xFF6D28D9)));
    streakNotifier.value++;

    try {
      final currentQuestion = playProvider.questions[playProvider.currentIndex];
      await playProvider.submitAnswer(
        gameId: gameEntity.id,
        questionId: currentQuestion.id,
        optionId: option.id,
        answer: option.text,
        weights: option.weights,
      );

      await persistenceProvider.saveProgress(miniGameKey, playProvider.currentIndex);

      if (playProvider.currentIndex < playProvider.questions.length) {
        _isSubmitting = false;
        _updateGameStage();
      } else {
        final result = await playProvider.finishSession(gameEntity.id);
        await persistenceProvider.markAsCompleted(miniGameKey);
        
        final gamesProvider = context.read<GamesProvider>();
        if (persistenceProvider.areAllCompleted(gamesProvider.miniGames)) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      _isSubmitting = false;
      streakNotifier.value = 0;
      piece.returnToOriginalPosition();
    }
  }
}

class CreativeCanvasComponent extends PositionComponent {
  final List<CircleComponent> _strokes = [];
  final Random _rng = Random();
  late TextComponent _label;
  late TextComponent _badge;
  VocationalCategory _currentCategory = VocationalCategory.artistico;

  CreativeCanvasComponent({required Vector2 position}) : super(position: position, size: Vector2(220, 210), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(size: size, paint: Paint()..color = Colors.white));
    _badge = TextComponent(text: '🎨', position: Vector2(size.x - 24, 40), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 26)));
    add(_badge);
    _label = TextComponent(text: 'LIENZO', position: Vector2(size.x / 2, size.y - 30), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF6366F1), fontSize: 14, fontWeight: FontWeight.bold)));
    add(_label);
  }

  void updateContent(String text) {
    _currentCategory = GameMapper.detectCategory(text);
    _badge.text = _emojiFor(_currentCategory);
  }

  void reactToAnswer(Color color) {
    final stroke = CircleComponent(
      radius: 12 + _rng.nextDouble() * 14,
      position: Vector2(20 + _rng.nextDouble() * (size.x - 40), 30 + _rng.nextDouble() * (size.y - 70)),
      anchor: Anchor.center,
      paint: Paint()..color = color.withOpacity(0.5),
    );
    add(stroke);
    _strokes.add(stroke);
    _label.text = _strokes.length >= 3 ? '¡OBRA DE ARTE!' : 'LIENZO';
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.08), EffectController(duration: 0.13, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.24, curve: Curves.elasticOut)),
    ]));
  }

  String _emojiFor(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo: return '🧮';
      case VocationalCategory.fisico: return '🪐';
      case VocationalCategory.biologico: return '🧬';
      case VocationalCategory.mecanico: return '⚙️';
      case VocationalCategory.social: return '🤝';
      case VocationalCategory.literario: return '📖';
      case VocationalCategory.persuasivo: return '📢';
      case VocationalCategory.artistico: return '🎨';
      case VocationalCategory.musical: return '🎵';
    }
  }
}

class CreativeOptionComponent extends PositionComponent with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;
  final void Function(GameQuestionOptionEntity, CreativeOptionComponent) onSelected;
  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _wasSubmitted = false;

  CreativeOptionComponent({required this.option, required this.color, required this.category, required Vector2 position, required this.onSelected})
      : super(position: position, size: Vector2(85, 105), anchor: Anchor.center) {
    originalPosition = position.clone();
  }

  @override
  bool get isIdleAnimated => !_isDragging && !_wasSubmitted;

  @override
  Future<void> onLoad() async {
    add(CircleComponent(radius: 35, position: Vector2(size.x / 2, 35), anchor: Anchor.center, paint: Paint()..color = color));
    add(TextComponent(
      text: GameOptionLabels.fromOriginal(originalText: option.text, category: category),
      position: Vector2(size.x / 2, 88),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF1E1B4B), fontSize: 10, fontWeight: FontWeight.bold)),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_wasSubmitted) return;
    _isDragging = true;
    scale = Vector2.all(1.08);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) => position.add(event.localDelta);

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    final game = parent as EstudioFlameGame;
    final canvasPos = Vector2(game.size.x / 2, game.size.y / 2 - 20);

    if (position.distanceTo(canvasPos) <= 135) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      position.setFrom(canvasPos);
      onSelected(option, this);
    } else {
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
