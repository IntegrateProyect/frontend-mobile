import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_question_entity.dart';
import '../../providers/games_provider.dart';
import '../game_result_screen.dart';
import 'arithmetic_machine_challenge.dart';
import 'atomic_energy_challenge.dart';
import 'area_carpet_challenge.dart';
import 'aquarium_care_challenge.dart';
import 'eclipse_sequence_challenge.dart';
import 'first_aid_challenge.dart';
import 'game_fx.dart';
import 'laboratory_challenge.dart';
import 'numeric_sequence_challenge.dart';
import 'plant_collection_challenge.dart';
import 'tray_sequence_challenge.dart';
import 'telescope_focus_challenge.dart';

const Color _kLaboratoryBackground = Color(0xFF010E28);
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
      backgroundColor: _kLaboratoryBackground,
      body: ColoredBox(
        color: _kLaboratoryBackground,
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget<LaboratorioFlameGame>(
                game: _game,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: _ExitButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 14,
              right: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: _game.streakNotifier,
                builder: (context, streak, _) {
                  return _NeonStreakBadge(
                    streak: streak,
                  );
                },
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

  /// Puede contener cualquiera de los retos del Laboratorio.
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
  Color backgroundColor() => _kLaboratoryBackground;

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

    final normalizedQuestion = question.text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');

    final isArithmeticMachine =
        normalizedQuestion.contains('mecaniz') ||
            normalizedQuestion.contains('aritmet');

    final isTelescopeFocus =
        normalizedQuestion.contains('telescopio') &&
            (normalizedQuestion.contains('regalo') ||
                normalizedQuestion.contains('enfoque') ||
                normalizedQuestion.contains('enfocar'));

    // Detección directa para impedir que esta pregunta caiga en el reto
    // procedural genérico de HERBARIO.
    final isPlantCollection =
        normalizedQuestion.contains('colecciones de plantas') ||
            normalizedQuestion.contains('coleccion de plantas') ||
            normalizedQuestion.contains('herbario');

    final isFirstAid = normalizedQuestion.contains('primeros auxilios');

    final isAtomicEnergy =
        normalizedQuestion.contains('energia atomica') ||
            normalizedQuestion.contains('atomo');

    final isCarpetArea =
        normalizedQuestion.contains('area de un cuarto') ||
            normalizedQuestion.contains('alfombrarse') ||
            normalizedQuestion.contains('alfombrar');

    final isAquariumCare =
        normalizedQuestion.contains('cuidar un pequeno acuario') ||
            normalizedQuestion.contains('cuidado del acuario') ||
            normalizedQuestion.contains('acuario');

    final config = LaboratoryChallengeConfig.fromQuestion(question.text);

    debugPrint(
      'RETO SELECCIONADO: ${question.text} '
          '-> MAQUINA=$isArithmeticMachine, ENFOQUE=$isTelescopeFocus, '
          'PLANTAS=$isPlantCollection',
    );

    final usesFullTelescopeTemplate =
        isTelescopeFocus || config.useTelescopeFocusChallenge;

    // La plantilla del telescopio llega hasta los bordes de la pantalla.
    // Así no queda encerrada en un rectángulo de otro tono.
    final challengePosition = Vector2(
      size.x / 2,
      usesFullTelescopeTemplate ? 145 : 178,
    );
    final challengeSize = Vector2(
      usesFullTelescopeTemplate ? size.x : size.x - 32,
      usesFullTelescopeTemplate ? size.y - 145 : size.y - 198,
    );

    final PositionComponent challenge;
    // Debe evaluarse antes del componente procedural genérico.
    if (isAquariumCare || config.useAquariumCareChallenge) {
      challenge = AquariumCareChallengeComponent(
        config: AquariumCareConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isCarpetArea || config.useAreaCarpetChallenge) {
      challenge = AreaCarpetChallengeComponent(
        config: AreaCarpetConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isAtomicEnergy || config.useAtomicEnergyChallenge) {
      challenge = AtomicEnergyChallengeComponent(
        config: AtomicEnergyConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isFirstAid || config.useFirstAidChallenge) {
      challenge = FirstAidChallengeComponent(
        config: FirstAidConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isPlantCollection || config.usePlantCollectionChallenge) {
      challenge = PlantCollectionChallengeComponent(
        config: PlantCollectionConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isTelescopeFocus || config.useTelescopeFocusChallenge) {
      challenge = TelescopeFocusChallengeComponent(
        config: TelescopeFocusConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (isArithmeticMachine) {
      challenge = ArithmeticMachineChallengeComponent(
        config: ArithmeticMachineConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (config.useNumericSequenceChallenge) {
      challenge = NumericSequenceChallengeComponent(
        config: NumericSequenceConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (config.useEclipseSequenceChallenge) {
      challenge = EclipseSequenceChallengeComponent(
        config: EclipseSequenceConfig.defaultConfig,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else if (config.useTraySequenceChallenge) {
      challenge = TraySequenceChallengeComponent(
        config: TraySequenceConfig.analisisSangre,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    } else {
      challenge = LaboratoryChallengeComponent(
        config: config,
        position: challengePosition,
        size: challengeSize,
        onFinish: _submitEngagementLevel,
      );
    }

    activeChallenge = challenge;
    add(challenge);
  }

  Future<void> _submitEngagementLevel(int level, Map<String, dynamic> meta) async {
    if (_isSubmitting || !context.mounted) return;

    final provider = context.read<GamesProvider>();
    final currentIndex = provider.savedIndex;

    if (currentIndex < 0 || currentIndex >= provider.questions.length) return;

    final currentQuestion = provider.questions[currentIndex];
    final normalizedCurrentQuestion = currentQuestion.text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');

    // El acuario es la última actividad del Laboratorio. Aunque el backend
    // entregue más preguntas después, al terminar este reto se cierra el juego.
    final isLastLaboratoryActivity =
        normalizedCurrentQuestion.contains('cuidar un pequeno acuario') ||
            normalizedCurrentQuestion.contains('cuidado del acuario') ||
            normalizedCurrentQuestion.contains('acuario');

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

      if (!isLastLaboratoryActivity &&
          currentIndex + 1 < provider.questions.length) {
        _isSubmitting = false;
        _updateGameStage();
      } else {
        final result = await provider.finishGame(gameEntity.id, statusKey: miniGameKey);
        if (!context.mounted) return;

        if (provider.areAllGamesCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => GameResultScreen(result: result)),
          );
        } else {
          await _showIncompleteGamesDialog();

          if (!context.mounted) return;

          Navigator.of(context).pop();
        }
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

  Future<void> _showIncompleteGamesDialog() async {
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC010817),
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 26),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              decoration: BoxDecoration(
                color: const Color(0xFF102A43),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _kNeon,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _kNeon.withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kNeon.withOpacity(0.16),
                      border: Border.all(
                        color: _kNeon,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.science_rounded,
                      color: _kNeon,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '\u00A1Secci\u00F3n completada!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF67E8FF),
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Terminaste todas las actividades del Laboratorio.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Completa los dem\u00E1s juegos para obtener tus resultados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB9E4FF),
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _kNeon,
                        foregroundColor: const Color(0xFF061B2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Continuar con los juegos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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