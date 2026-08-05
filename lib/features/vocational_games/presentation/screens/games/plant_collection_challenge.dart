import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'components/game_completion_overlay.dart';
import 'components/plant_challenge_components.dart';

class PlantCollectionConfig {
  final String backgroundAsset;
  final int samplesTotal;
  final List<String> hints;

  const PlantCollectionConfig({
    required this.backgroundAsset,
    required this.samplesTotal,
    required this.hints,
  });

  static const defaultConfig = PlantCollectionConfig(
    backgroundAsset: 'coleccionplantas.png',
    samplesTotal: 3,
    hints: <String>[
      'Toca la prensa circular verde para colocar la primera muestra.',
      'Muy bien. Vuelve a tocar la prensa para observar la segunda muestra.',
      'Falta una muestra. Toca nuevamente la prensa para clasificarla.',
    ],
  );
}

class PlantCollectionChallengeComponent extends PositionComponent {
  final PlantCollectionConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final PlantPressButton _press;
  late final PlantStatusOverlay _status;
  PositionComponent? _hint;
  PositionComponent? _fact;

  int _samples = 0;
  int _touches = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  PlantCollectionChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addInstruction();

    _status = PlantStatusOverlay(
      size: size.clone(),
      completed: 0,
    );
    add(_status);

    _press = PlantPressButton(
      position: Vector2(size.x * 0.5, size.y * 0.420),
      size: Vector2(size.x * 0.30, size.x * 0.20),
      onPressed: _processSample,
    );
    add(_press);

    _addButtons();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(
        sprite: sprite,
        position: Vector2.zero(),
        size: size.clone(),
        priority: -100,
      ));
    } catch (error) {
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
      add(RectangleComponent(
        size: size.clone(),
        priority: -100,
        paint: Paint()..color = const Color(0xFF01182A),
      ));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Toca la prensa para observar y clasificar las tres muestras de hojas.',
      position: Vector2(size.x / 2, size.y * 0.025),
      size: Vector2(size.x - 48, 58),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 200,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE4FFF2),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    ));
  }

  void _processSample() {
    if (_locked) return;
    _touches++;
    if (_samples >= config.samplesTotal) return;

    _samples++;
    _status.completed = _samples;
    _press.pulse();
    _hint?.removeFromParent();
    _hint = null;
    _showClassificationFact(_samples - 1);

    if (_samples >= config.samplesTotal) {
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (!_locked) _showCompletion();
      });
    }
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    _press.lock();
    _hint?.removeFromParent();
    _fact?.removeFromParent();
    _hint = null;
    _fact = null;

    add(
      GameCompletionOverlay(
        size: size.clone(),
        characterAsset: 'adolescente_botanica.png',
        title: '¡Felicidades!',
        message: '¡Excelente trabajo!\n\nObservaste y clasificaste correctamente las tres muestras. Ahora puedes reconocer plantas por la forma y las partes de sus hojas.',
        themeColor: const Color(0xFF55F0A4),
        onContinue: () => _deliverFinish('completed'),
      ),
    );
  }

  void _showClassificationFact(int index) {
    const facts = <String>[
      'Las hojas simples tienen una sola lámina, aunque pueden presentar cortes o formas muy distintas.',
      'Cada parte de una hoja compuesta se llama folíolo y todas juntas forman una sola hoja.',
      'Las hojas de margen entero tienen un borde liso, sin dientes ni divisiones visibles.',
    ];
    _fact?.removeFromParent();
    final card = PlantFactCard(
      title: '🌿 ¿Sabías que?  ${index + 1}/3',
      text: facts[index.clamp(0, facts.length - 1)],
      position: Vector2(size.x / 2, size.y * 0.185),
      size: Vector2(size.x - 72, 88),
    );
    _fact = card;
    add(card);
  }

  void _addButtons() {
    add(PlantButton(
      text: '💡 Pista',
      color: const Color(0xFF4DE39A),
      position: Vector2(size.x / 2 - 62, size.y - 40),
      width: 108,
      onPressed: _showHint,
    ));
    add(PlantButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 40),
      width: 108,
      onPressed: () => _finish('skipped'),
    ));
  }

  void _showHint() {
    if (_locked) return;
    _hint?.removeFromParent();
    final index = _samples.clamp(0, config.hints.length - 1);
    final banner = PlantHint(
      text: config.hints[index],
      position: Vector2(size.x / 2, size.y - 96),
      size: Vector2(size.x - 64, 52),
    );
    _hint = banner;
    add(banner);
    _press.pulse();
  }

  int _level() {
    if (_samples >= config.samplesTotal) return 4;
    if (_samples == 2) return 3;
    if (_samples == 1) return 2;
    if (_touches > 0) return 1;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    _press.lock();
    _hint?.removeFromParent();
    _fact?.removeFromParent();
    _deliverFinish(reason);
  }

  void _deliverFinish(String reason) {
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(reason == 'completed' ? 4 : _level(), <String, dynamic>{
      'activityKind': 'biology',
      'challengeType': 'plantCollection',
      'samplesProcessed': _samples,
      'samplesTotal': config.samplesTotal,
      'touches': _touches,
      'completionTimeSeconds': elapsed,
      'endReason': reason,
    });
  }
}
