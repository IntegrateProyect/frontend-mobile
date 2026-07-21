import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';
import '../../providers/games_provider.dart';
import '../game_result_screen.dart';
import 'game_fx.dart';
import 'laboratory_challenge.dart';
import 'numeric_sequence_challenge.dart';

const Color _kBgTop = Color(0xFF0A1220);
const Color _kBgBottom = Color(0xFF0E1B2E);
const Color _kNeon = Color(0xFF29B6F6);

class LaboratorioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const LaboratorioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<LaboratorioGameScreen> createState() => _LaboratorioGameScreenState();
}

class _LaboratorioGameScreenState extends State<LaboratorioGameScreen> {
  late final LaboratorioFlameGame _game;

  @override
  void initState() {
    super.initState();
    _game = LaboratorioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_kBgTop, _kBgBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget<LaboratorioFlameGame>(game: _game),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: _ExitButton(onTap: () => Navigator.of(context).pop()),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 14,
              right: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: _game.streakNotifier,
                builder: (context, streak, _) => _NeonStreakBadge(streak: streak),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LaboratorioFlameGame extends FlameGame {
  final BuildContext context;
  final GameEntity gameEntity;
  final String miniGameKey;

  late final TextBoxComponent questionText;

  /// Puede contener LaboratoryChallengeComponent o
  /// NumericSequenceChallengeComponent — ambos son PositionComponent
  /// y comparten el mismo contrato onFinish(level, meta).
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
  Color backgroundColor() => const Color(0x00000000); // el degradado lo pone el Container de Flutter

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(_StarField(starCount: 46));

    add(TextComponent(
      text: 'Laboratorio',
      position: Vector2(size.x / 2, 65),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE8F6FF),
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    if (!context.mounted) return;
    _updateGameStage();
  }

  void _updateGameStage() {
    if (!context.mounted) return;

    final provider = context.read<GamesProvider>();

    if (provider.questions.isEmpty) {
      _showMessage('No hay preguntas disponibles.');
      return;
    }

    if (provider.savedIndex < 0 || provider.savedIndex >= provider.questions.length) {
      return;
    }

    final currentQuestion = provider.questions[provider.savedIndex];

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
          style: const TextStyle(
            color: Color(0xFFB9E4FF),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
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
    if (question.options.isEmpty) {
      _showMessage('Esta actividad no tiene opciones para guardar el avance.');
      return;
    }

    final config = LaboratoryChallengeConfig.fromQuestion(question.text);

    final challenge = config.useNumericSequenceChallenge
        ? NumericSequenceChallengeComponent(
      config: NumericSequenceConfig.defaultConfig,
      position: Vector2(size.x / 2, 178),
      size: Vector2(size.x - 32, size.y - 198),
      onFinish: _submitEngagementLevel,
    )
        : LaboratoryChallengeComponent(
      config: config,
      position: Vector2(size.x / 2, 178),
      size: Vector2(size.x - 32, size.y - 198),
      onFinish: _submitEngagementLevel,
    );

    activeChallenge = challenge;
    add(challenge);
  }

  Future<void> _submitEngagementLevel(int level, Map<String, dynamic> meta) async {
    if (_isSubmitting || !context.mounted) return;

    final provider = context.read<GamesProvider>();
    final currentIndex = provider.savedIndex;

    if (currentIndex < 0 || currentIndex >= provider.questions.length) return;

    final currentQuestion = provider.questions[currentIndex];

    if (currentQuestion.options.isEmpty) {
      _showMessage('No se pudo registrar esta actividad.');
      return;
    }

    _isSubmitting = true;

    final safeIndex = level.clamp(0, currentQuestion.options.length - 1).toInt();
    final selectedOption = currentQuestion.options[safeIndex];

    if (level >= 3) {
      streakNotifier.value += 1;
    } else {
      streakNotifier.value = 0;
    }

    try {
      await provider.sendAnswer(
        gameId: gameEntity.id,
        questionId: currentQuestion.id,
        optionId: selectedOption.id,
        answer: selectedOption.text,
        weights: selectedOption.weights,
        currentIndex: currentIndex + 1,
        progressKey: miniGameKey,
        interactionData: meta,
      );

      if (!context.mounted) return;

      if (currentIndex + 1 < provider.questions.length) {
        _isSubmitting = false;
        _updateGameStage();
      } else {
        final result = await provider.finishGame(gameEntity.id, statusKey: miniGameKey);
        if (!context.mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => GameResultScreen(result: result)),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Error al guardar el nivel de interacción: $error');
      debugPrintStack(stackTrace: stackTrace);
      _isSubmitting = false;
      streakNotifier.value = 0;
      _showMessage('No se pudo guardar el avance. Inténtalo nuevamente.');
      _updateGameStage();
    }
  }

  void _showMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }
}

class _StarField extends Component {
  final int starCount;
  final Random _rng = Random();
  late List<Offset> _positions;
  late List<double> _phases;
  late List<double> _radii;
  double _time = 0;

  _StarField({required this.starCount});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final game = findGame()!;
    final w = game.size.x;
    final h = game.size.y;

    _positions = List.generate(starCount, (_) => Offset(_rng.nextDouble() * w, _rng.nextDouble() * h));
    _phases = List.generate(starCount, (_) => _rng.nextDouble() * pi * 2);
    _radii = List.generate(starCount, (_) => 0.6 + _rng.nextDouble() * 1.6);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _positions.length; i++) {
      final twinkle = 0.35 + 0.45 * (0.5 + 0.5 * sin(_time * 1.4 + _phases[i]));
      canvas.drawCircle(
        _positions[i],
        _radii[i],
        Paint()..color = Colors.white.withOpacity(twinkle * 0.6),
      );
    }
  }
}

class _NeonStreakBadge extends StatelessWidget {
  final int streak;

  const _NeonStreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2033).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kNeon.withOpacity(0.6), width: 1.4),
        boxShadow: [
          BoxShadow(color: _kNeon.withOpacity(0.25), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            'Racha x$streak',
            style: const TextStyle(
              color: Color(0xFFE8F6FF),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ExitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2033).withOpacity(0.85),
        shape: BoxShape.circle,
        border: Border.all(color: _kNeon.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: IconButton(
        tooltip: 'Salir',
        icon: const Icon(Icons.close, color: Color(0xFFE8F6FF)),
        onPressed: onTap,
      ),
    );
  }
}