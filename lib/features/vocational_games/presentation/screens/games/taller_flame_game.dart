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
  Color backgroundColor() => const Color(0xFFEFEBE9);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(AmbientFloaters(color: const Color(0xFFBCAAA4)));

    add(TextComponent(
      text: 'Taller de habilidades',
      position: Vector2(size.x / 2, 65),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF3E2723), fontSize: 23, fontWeight: FontWeight.bold),
      ),
    ));

    add(PulsingTargetRing(
      position: Vector2(size.x / 2, size.y / 2 - 20),
      color: const Color(0xFF8D6E63),
      baseRadius: 78,
    ));

    assembly = AssemblyAreaComponent(position: Vector2(size.x / 2, size.y / 2 - 20));
    add(assembly);

    await assembly.loaded;
    _updateGameStage();
  }

  void _updateGameStage() {
    final playProvider = context.read<GamePlayProvider>();
    if (playProvider.questions.isEmpty) return;
    if (playProvider.currentIndex >= playProvider.questions.length) return;

    final currentQuestion = playProvider.questions[playProvider.currentIndex];
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
          style: const TextStyle(color: Color(0xFF3E2723), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una pieza y colócala en el mecanismo',
        position: Vector2(size.x / 2, 180),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.brown, fontSize: 13),
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
    final colors = [Colors.blueGrey, Colors.orange.shade700, Colors.cyan.shade700, Colors.deepOrange.shade400];
    final category = GameMapper.detectCategory(question.text);
    final double spacing = (size.x - 40) / question.options.length;

    for (int i = 0; i < question.options.length; i++) {
      final option = question.options[i];
      final double xPosition = 20 + (spacing * i) + (spacing / 2);

      final component = PieceComponent(
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

  Future<void> _submitAnswer(GameQuestionOptionEntity option, PieceComponent piece) async {
    if (_isSubmitting || !context.mounted) return;

    final playProvider = context.read<GamePlayProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    
    _isSubmitting = true;
    assembly.reactToAnswer();
    add(FloatingPraise(position: assembly.position - Vector2(0, 100), text: randomPraise(_rng), color: const Color(0xFF4E342E)));
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

class AssemblyAreaComponent extends PositionComponent {
  late TextComponent _gear;
  late CircleComponent _innerFill;
  final List<Color> _fillColors = [const Color(0xFFBCAAA4), const Color(0xFF80CBC4), const Color(0xFFFFCC80), const Color(0xFF90CAF9)];
  int _reactionCount = 0;
  double _rotation = 0;
  VocationalCategory _currentCategory = VocationalCategory.mecanico;

  AssemblyAreaComponent({required Vector2 position}) : super(position: position, size: Vector2(150, 150), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleComponent(radius: 70, position: size / 2, anchor: Anchor.center, paint: Paint()..color = Colors.grey.shade400..style = PaintingStyle.stroke..strokeWidth = 8));
    _innerFill = CircleComponent(radius: 42, position: size / 2, anchor: Anchor.center, paint: Paint()..color = Colors.brown.withOpacity(0.12));
    add(_innerFill);
    _gear = TextComponent(text: '⚙️', position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 45, color: Color(0xFF6D4C41))));
    add(_gear);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_currentCategory == VocationalCategory.mecanico) {
      _rotation += dt * 0.3;
      _gear.angle = _rotation;
    }
  }

  void updateContent(String text) {
    _currentCategory = GameMapper.detectCategory(text);
    _gear.text = _emojiFor(_currentCategory);
    if (_currentCategory != VocationalCategory.mecanico) _gear.angle = 0;
  }

  void reactToAnswer() {
    _reactionCount++;
    _innerFill.paint = Paint()..color = _fillColors[_reactionCount % _fillColors.length].withOpacity(0.28);
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.14), EffectController(duration: 0.13, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.26, curve: Curves.elasticOut)),
    ]));
    if (_currentCategory == VocationalCategory.mecanico) {
      _gear.add(RotateEffect.by(pi / 2, EffectController(duration: 0.35, curve: Curves.easeOutBack)));
    }
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

class PieceComponent extends PositionComponent with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;
  final void Function(GameQuestionOptionEntity, PieceComponent) onSelected;
  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _wasSubmitted = false;

  PieceComponent({required this.option, required this.color, required this.category, required Vector2 position, required this.onSelected})
      : super(position: position, size: Vector2(85, 100), anchor: Anchor.center) {
    originalPosition = position.clone();
  }

  @override
  bool get isIdleAnimated => !_isDragging && !_wasSubmitted;

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(position: Vector2(size.x / 2 + 3, 28), size: Vector2(58, 58), anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.18)));
    add(RectangleComponent(position: Vector2(size.x / 2, 25), size: Vector2(58, 58), anchor: Anchor.center, paint: Paint()..color = color));
    add(TextComponent(
      text: GameOptionLabels.fromOriginal(originalText: option.text, category: category),
      position: Vector2(size.x / 2, 72),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF3E2723), fontSize: 10, fontWeight: FontWeight.bold)),
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
    final game = parent as TallerFlameGame;
    final targetPos = Vector2(game.size.x / 2, game.size.y / 2 - 20);

    if (position.distanceTo(targetPos) <= 100) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      position.setFrom(targetPos);
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
