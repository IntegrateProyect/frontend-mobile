import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/game_completion_overlay.dart';
import 'components/tray_sequence_challenge_components.dart';

class TraySequenceConfig {
  final String backgroundAsset;
  final String instruction;
  final List<String> itemAssets;
  final List<Vector2> slotFractions;
  final List<Vector2> itemFractions;
  final List<Vector2> itemSizeFractions;
  final List<String> hintMessages;
  final List<String> factMessages;
  final double dropDistance;
  final double placedScale;

  const TraySequenceConfig({
    required this.backgroundAsset,
    required this.instruction,
    required this.itemAssets,
    required this.slotFractions,
    required this.itemFractions,
    required this.itemSizeFractions,
    required this.hintMessages,
    required this.factMessages,
    required this.dropDistance,
    required this.placedScale,
  });

  static final TraySequenceConfig analisisSangre = TraySequenceConfig(
    backgroundAsset: 'analisissangre.png',
    instruction: 'Arrastra los elementos a la bandeja en el orden correcto.',
    itemAssets: const ['guantes.png', 'tubo_sangre.png', 'microscopio.png'],
    slotFractions: [Vector2(0.22, 0.395), Vector2(0.50, 0.395), Vector2(0.78, 0.395)],
    itemFractions: [Vector2(0.190, 0.704), Vector2(0.500, 0.704), Vector2(0.815, 0.704)],
    itemSizeFractions: [Vector2(0.290, 0.174), Vector2(0.290, 0.174), Vector2(0.290, 0.174)],
    hintMessages: const ['Ponte los guantes.', 'Prepara el tubo.', 'Usa el microscopio.'],
    factMessages: const ['¡Bien!', 'Muy bien.', 'Excelente.'],
    dropDistance: 160,
    placedScale: 0.72,
  );
}

class TraySequenceChallengeComponent extends PositionComponent {
  final TraySequenceConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  final List<DraggableMedicalCard> _cards = [];
  int _filledCount = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  TraySequenceChallengeComponent({required this.config, required this.onFinish, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addInstruction();
    await _addDraggableCards();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF021229)));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: config.instruction,
      position: Vector2(size.x / 2, 40),
      size: Vector2(size.x - 64, 68),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFEAF7FF), fontSize: 13.5, fontWeight: FontWeight.bold)),
    ));
  }

  Future<void> _addDraggableCards() async {
    for (var i = 0; i < config.itemAssets.length; i++) {
      final posF = config.itemFractions[i];
      final sizeF = config.itemSizeFractions[i];
      add(DraggableMedicalCard(
        assetName: config.itemAssets[i],
        cardIndex: i,
        position: Vector2(size.x * posF.x, size.y * posF.y),
        size: Vector2(size.x * sizeF.x, size.y * sizeF.y),
        placedScale: config.placedScale,
        dropDistance: config.dropDistance,
        targetPositionProvider: () => Vector2(size.x * config.slotFractions[i].x, size.y * config.slotFractions[i].y),
        canPlaceProvider: () => i == _filledCount,
        onWrongOrder: () {},
        onTouched: () {},
        onDropped: _onCardDropped,
      ));
    }
  }

  void _onCardDropped(DraggableMedicalCard card) {
    if (_locked) return;
    _filledCount++;
    if (_filledCount >= config.itemAssets.length) _showCompletion();
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'adolescente_laboratorio.png',
      message: 'Aprendiste a seguir el orden básico de un análisis de sangre.',
      themeColor: const Color(0xFF45E6B0),
      onContinue: () => _finish('completed'),
    ));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'traySequence',
      'time': DateTime.now().difference(_startedAt).inSeconds,
    });
  }
}
