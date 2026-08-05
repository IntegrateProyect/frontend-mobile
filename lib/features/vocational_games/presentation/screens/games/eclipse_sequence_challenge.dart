import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/game_completion_overlay.dart';
import 'components/eclipse_sequence_challenge_components.dart';

class EclipseSequenceConfig {
  final String backgroundAsset;
  final List<String> cardAssets;
  final List<Vector2> slotFractions;
  final List<Vector2> cardFractions;
  final List<Vector2> cardSizeFractions;
  final List<String> hintMessages;
  final double placedScale;
  final double dropDistance;

  const EclipseSequenceConfig({
    required this.backgroundAsset,
    required this.cardAssets,
    required this.slotFractions,
    required this.cardFractions,
    required this.cardSizeFractions,
    required this.hintMessages,
    required this.placedScale,
    required this.dropDistance,
  });

  static final EclipseSequenceConfig defaultConfig = EclipseSequenceConfig(
    backgroundAsset: 'faseeclipse.png',
    cardAssets: const ['Sol.png', 'Eclipseparcial.png', 'Eclipsetotal.png'],
    slotFractions: [Vector2(0.185, 0.545), Vector2(0.500, 0.545), Vector2(0.810, 0.545)],
    cardFractions: [Vector2(0.180, 0.742), Vector2(0.500, 0.742), Vector2(0.815, 0.742)],
    cardSizeFractions: [Vector2(0.285, 0.168), Vector2(0.285, 0.168), Vector2(0.285, 0.168)],
    hintMessages: const ['Pon el Sol primero', 'Sigue el eclipse parcial', 'Termina con el total'],
    placedScale: 0.64,
    dropDistance: 170,
  );
}

class EclipseSequenceChallengeComponent extends PositionComponent {
  final EclipseSequenceConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  final List<DraggableEclipseCard> _cards = [];
  int _placedCards = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  EclipseSequenceChallengeComponent({required this.config, required this.onFinish, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    await _addCards();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF010B26)));
    }
  }

  Future<void> _addCards() async {
    for (var i = 0; i < config.cardAssets.length; i++) {
      final posF = config.cardFractions[i];
      final sizeF = config.cardSizeFractions[i];
      add(DraggableEclipseCard(
        assetName: config.cardAssets[i],
        cardIndex: i,
        position: Vector2(size.x * posF.x, size.y * posF.y),
        size: Vector2(size.x * sizeF.x, size.y * sizeF.y),
        placedScale: config.placedScale,
        dropDistance: config.dropDistance,
        targetPositionProvider: () => Vector2(size.x * config.slotFractions[i].x, size.y * config.slotFractions[i].y),
        onTouched: () {},
        onAttempt: () {},
        onDropped: _onCardDropped,
      ));
    }
  }

  void _onCardDropped(DraggableEclipseCard card) {
    if (_locked) return;
    _placedCards++;
    if (_placedCards >= config.cardAssets.length) _showCompletion();
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'adolescente_eclipse.png',
      message: 'Aprendiste a reconocer las fases de un eclipse y su secuencia.',
      themeColor: const Color(0xFFB388FF),
      onContinue: () => _finish('completed'),
    ));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'eclipseSequence',
      'time': DateTime.now().difference(_startedAt).inSeconds,
    });
  }
}
