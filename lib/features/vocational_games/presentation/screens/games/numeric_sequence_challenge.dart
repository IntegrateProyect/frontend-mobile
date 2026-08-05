import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'components/game_completion_overlay.dart';
import 'components/numeric_sequence_challenge_components.dart';

class NumericSequenceConfig {
  final String backgroundAsset;
  final List<String> sequenceValues;
  final int missingIndex;
  final List<Vector2> flaskFractions;
  final List<String> optionLabels;
  final List<Vector2> optionFractions;
  final String correctAnswer;

  const NumericSequenceConfig({
    required this.backgroundAsset,
    required this.sequenceValues,
    required this.missingIndex,
    required this.flaskFractions,
    required this.optionLabels,
    required this.optionFractions,
    this.correctAnswer = '16',
  });

  static final NumericSequenceConfig defaultConfig = NumericSequenceConfig(
    backgroundAsset: 'rompecabezasnumericos.png',
    sequenceValues: const ['2', '4', '8', '?', '32'],
    missingIndex: 3,
    flaskFractions: [Vector2(0.145, 0.45), Vector2(0.335, 0.45), Vector2(0.525, 0.45), Vector2(0.685, 0.44), Vector2(0.875, 0.45)],
    optionLabels: const ['12', '16', '24'],
    optionFractions: [Vector2(0.21, 0.685), Vector2(0.51, 0.685), Vector2(0.80, 0.685)],
    correctAnswer: '16',
  );
}

class NumericSequenceChallengeComponent extends PositionComponent {
  final NumericSequenceConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final FlaskTargetGlow _targetGlow;
  late final FeedbackBanner _feedbackBanner;
  final List<DraggableNumberCard> _cards = [];
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  NumericSequenceChallengeComponent({required this.config, required this.onFinish, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addInstruction();
    
    final targetFraction = config.flaskFractions[config.missingIndex];
    final targetPos = Vector2(size.x * targetFraction.x, size.y * targetFraction.y);

    _targetGlow = FlaskTargetGlow(position: targetPos, size: Vector2(size.x * 0.19, size.y * 0.17));
    add(_targetGlow);

    for (var i = 0; i < config.optionLabels.length; i++) {
      final f = config.optionFractions[i];
      add(DraggableNumberCard(
        label: config.optionLabels[i],
        position: Vector2(size.x * f.x, size.y * f.y),
        targetPositionProvider: () => targetPos,
        onTouched: () {},
        onHoverChanged: (h) => _targetGlow.setHovering(h),
        onDropped: _onCardDropped,
      ));
    }

    _feedbackBanner = FeedbackBanner(position: Vector2(size.x / 2, size.y * 0.16), size: Vector2(size.x - 42, 58));
    add(_feedbackBanner);
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF06172D)));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Observa el patrón y arrastra la tarjeta correcta hasta el frasco vacío.',
      position: Vector2(size.x / 2, 16),
      size: Vector2(size.x - 36, 54),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFD9F4FF), fontSize: 13, fontWeight: FontWeight.bold)),
    ));
  }

  void _onCardDropped(DraggableNumberCard card) {
    if (_locked) return;
    if (card.label == config.correctAnswer) {
      _showCompletion();
    } else {
      card.showWrongAndReturn();
      _feedbackBanner.showMessage('Inténtalo de nuevo', Colors.red);
    }
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'adolescente_cientifica_numerica.png',
      message: '¡Excelente! Descubriste el patrón: cada número es el doble del anterior.',
      themeColor: const Color(0xFF35D69A),
      onContinue: () => _finish('completed'),
    ));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'numericSequence',
      'time': DateTime.now().difference(_startedAt).inSeconds,
    });
  }
}
