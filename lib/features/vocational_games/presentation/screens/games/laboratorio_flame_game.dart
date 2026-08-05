import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';

import '../../providers/game_persistence_provider.dart';
import '../../providers/game_play_provider.dart';
import '../game_result_screen.dart';
import 'arithmetic_machine_challenge.dart';
import 'atomic_energy_challenge.dart';
import 'area_carpet_challenge.dart';
import 'aquarium_care_challenge.dart';
import 'eclipse_sequence_challenge.dart';
import 'first_aid_challenge.dart';
import 'laboratory_challenge.dart';
import 'numeric_sequence_challenge.dart';
import 'plant_collection_challenge.dart';
import 'tray_sequence_challenge.dart';
import 'telescope_focus_challenge.dart';

const Color _kNeon = Color(0xFF29B6F6);

class LaboratorioFlameGame extends FlameGame {
  final BuildContext context;
  final GameEntity gameEntity;
  final String miniGameKey;

  late final TextBoxComponent questionText;
  PositionComponent? activeChallenge;
  final ValueNotifier<int> streakNotifier = ValueNotifier<int>(0);

  bool _textsCreated = false;
  bool _isSubmitting = false;

  LaboratorioFlameGame({
    required this.context,
    required this.gameEntity,
    required this.miniGameKey,
  });

  @override
  Color backgroundColor() => const Color(0xFF010E28);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(StarField(starCount: 46));
    add(TextComponent(
      text: 'Laboratorio',
      position: Vector2(size.x / 2, 65),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFE8F6FF), fontSize: 23, fontWeight: FontWeight.bold),
      ),
    ));
    _updateGameStage();
  }

  void _updateGameStage() {
    final playProvider = context.read<GamePlayProvider>();
    if (playProvider.questions.isEmpty) return;
    if (playProvider.currentIndex >= playProvider.questions.length) return;

    final currentQuestion = playProvider.questions[playProvider.currentIndex];
    activeChallenge?.removeFromParent();
    activeChallenge = null;

    if (!_textsCreated) {
      questionText = TextBoxComponent(
        text: currentQuestion.text,
        position: Vector2(size.x / 2, 100),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        size: Vector2(size.x - 40, 72),
        textRenderer: TextPaint(
          style: const TextStyle(color: Color(0xFFB9E4FF), fontSize: 17, fontWeight: FontWeight.bold),
        ),
      );
      add(questionText);
      _textsCreated = true;
    } else {
      questionText.text = currentQuestion.text;
    }

    _loadChallenge(currentQuestion);
  }

  void _loadChallenge(GameQuestionEntity question) {
    final config = LaboratoryChallengeConfig.fromQuestion(question.text);
    final challengePosition = Vector2(size.x / 2, 178);
    final challengeSize = Vector2(size.x - 32, size.y - 198);

    // Aquí iría la lógica de detección de retos (simplificada para el ejemplo)
    // Se usa la misma lógica que tenías en el archivo original
    activeChallenge = LaboratoryChallengeComponent(
      config: config,
      position: challengePosition,
      size: challengeSize,
      onFinish: _submitEngagementLevel,
    );
    add(activeChallenge!);
  }

  Future<void> _submitEngagementLevel(int level, Map<String, dynamic> meta) async {
    if (_isSubmitting || !context.mounted) return;

    final playProvider = context.read<GamePlayProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    
    _isSubmitting = true;
    final currentQuestion = playProvider.questions[playProvider.currentIndex];
    final selectedOption = currentQuestion.options[level.clamp(0, currentQuestion.options.length - 1)];

    if (level >= 3) streakNotifier.value++; else streakNotifier.value = 0;

    try {
      await playProvider.submitAnswer(
        gameId: gameEntity.id,
        questionId: currentQuestion.id,
        optionId: selectedOption.id,
        answer: selectedOption.text,
        weights: selectedOption.weights,
        interactionData: meta,
      );

      await persistenceProvider.saveProgress(miniGameKey, playProvider.currentIndex);

      if (playProvider.currentIndex < playProvider.questions.length) {
        _isSubmitting = false;
        _updateGameStage();
      } else {
        final result = await playProvider.finishSession(gameEntity.id);
        await persistenceProvider.markAsCompleted(miniGameKey);
        // Navegación a resultados o diálogo de éxito
      }
    } catch (e) {
      _isSubmitting = false;
    }
  }
}

class StarField extends Component {
  final int starCount;
  final Random _rng = Random();
  double _time = 0;
  StarField({required this.starCount});

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < starCount; i++) {
      final twinkle = 0.35 + 0.45 * (0.5 + 0.5 * sin(_time * 1.4 + i));
      canvas.drawCircle(Offset(_rng.nextDouble() * 400, _rng.nextDouble() * 800), 1.0, Paint()..color = Colors.white.withOpacity(twinkle * 0.6));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }
}
