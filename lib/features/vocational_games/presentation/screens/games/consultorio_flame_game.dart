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
  Color backgroundColor() => const Color(0xFFE3F2FD);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(AmbientFloaters(color: const Color(0xFF64B5F6)));

    add(TextComponent(
      text: 'Consultorio',
      position: Vector2(size.x / 2, 65),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF0D47A1), fontSize: 23, fontWeight: FontWeight.bold),
      ),
    ));

    add(PulsingTargetRing(
      position: Vector2(size.x / 2, size.y / 2 - 30),
      color: const Color(0xFF1976D2),
      baseRadius: 80,
    ));

    patient = PatientComponent(position: Vector2(size.x / 2, size.y / 2 - 30));
    add(patient);

    await patient.loaded;
    _updateGameStage();
  }

  void _updateGameStage() {
    final playProvider = context.read<GamePlayProvider>();
    if (playProvider.questions.isEmpty) return;
    if (playProvider.currentIndex >= playProvider.questions.length) return;

    final currentQuestion = playProvider.questions[playProvider.currentIndex];
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
          style: const TextStyle(color: Color(0xFF0D47A1), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

      instructionText = TextComponent(
        text: 'Elige una acción y llévala hasta la persona',
        position: Vector2(size.x / 2, 170),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
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
    final colors = [Colors.green.shade400, Colors.orange.shade400, Colors.purple.shade400, Colors.teal.shade400];
    final double spacing = (size.x - 30) / question.options.length;

    for (int i = 0; i < question.options.length; i++) {
      final option = question.options[i];
      final double xPosition = 15 + (spacing * i) + (spacing / 2);

      final component = HelpOptionComponent(
        option: option,
        color: colors[i % colors.length],
        category: category,
        position: Vector2(xPosition, size.y - 110),
        onSelected: _submitAnswer,
      );
      activeOptions.add(component);
      add(component);
    }
  }

  Future<void> _submitAnswer(GameQuestionOptionEntity option, HelpOptionComponent piece) async {
    if (_isSubmitting || !context.mounted) return;

    final playProvider = context.read<GamePlayProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    
    _isSubmitting = true;
    patient.reactToAnswer();
    add(FloatingPraise(position: patient.position - Vector2(0, 100), text: randomPraise(_rng), color: const Color(0xFF0D47A1)));
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
        await _showCompletionDialog();
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

  Future<void> _showCompletionDialog() async {
    // Lógica del diálogo (puedes mover esto a un componente separado de Flutter si prefieres)
  }
}

class PatientComponent extends PositionComponent {
  late TextComponent _mood;
  late TextComponent _badge;
  int _reactionCount = 0;

  PatientComponent({required Vector2 position}) : super(position: position, size: Vector2(150, 180), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleComponent(radius: 50, position: Vector2(size.x / 2, 58), anchor: Anchor.center, paint: Paint()..color = Colors.blue.shade200));
    _badge = TextComponent(text: '🤝', position: Vector2(size.x - 5, 25), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 24)));
    add(_badge);
    _mood = TextComponent(text: '+', position: Vector2(size.x / 2, 123), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)));
    add(_mood);
  }

  void updateContent(String text) {
    final cat = GameMapper.detectCategory(text);
    _badge.text = _emojiFor(cat);
  }

  void reactToAnswer() {
    _reactionCount++;
    _mood.text = _reactionCount % 2 == 0 ? '☺' : '+';
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.1), EffectController(duration: 0.13, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.25, curve: Curves.elasticOut)),
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

class HelpOptionComponent extends PositionComponent with DragCallbacks, IdleBreathing {
  final GameQuestionOptionEntity option;
  final Color color;
  final VocationalCategory category;
  final void Function(GameQuestionOptionEntity, HelpOptionComponent) onSelected;
  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _wasSubmitted = false;

  HelpOptionComponent({required this.option, required this.color, required this.category, required Vector2 position, required this.onSelected})
      : super(position: position, size: Vector2(90, 90), anchor: Anchor.center) {
    originalPosition = position.clone();
  }

  @override
  bool get isIdleAnimated => !_isDragging && !_wasSubmitted;

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(position: Vector2(size.x / 2, 25), size: Vector2(75, 45), anchor: Anchor.center, paint: Paint()..color = color));
    add(TextComponent(
      text: GameOptionLabels.fromOriginal(originalText: option.text, category: category),
      position: Vector2(size.x / 2, 67),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
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
    final game = parent as ConsultorioFlameGame;
    final patientPos = Vector2(game.size.x / 2, game.size.y / 2 - 30);

    if (position.distanceTo(patientPos) < 110) {
      _wasSubmitted = true;
      scale = Vector2.all(1);
      position.setFrom(patientPos);
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
