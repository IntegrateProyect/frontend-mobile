import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'components/game_completion_overlay.dart';
import 'components/first_aid_challenge_components.dart';

class FirstAidConfig {
  final String backgroundAsset;
  final List<String> bandageAssets;
  const FirstAidConfig({
    required this.backgroundAsset,
    required this.bandageAssets,
  });

  static const defaultConfig = FirstAidConfig(
    backgroundAsset: 'primerosauxilios.png',
    bandageAssets: <String>[
      'vendajeflojo.png',
      'vendajecorrecto.png',
      'vendajeapretado.png',
    ],
  );
}

class FirstAidChallengeComponent extends PositionComponent {
  final FirstAidConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  static const _instructions = <String>[
    'Arrastra el vendaje con la tensión correcta hasta la herida.',
    'Finalmente toca la muñeca para comprobar la circulación.',
  ];

  late final TextBoxComponent _instruction;
  final List<DraggableBandage> _bandages = <DraggableBandage>[];
  final List<AidTapZone> _zones = <AidTapZone>[];
  PositionComponent? _message;

  int _step = 0;
  int _attempts = 0;
  bool _locked = false;
  bool _scanning = false;
  final DateTime _startedAt = DateTime.now();

  FirstAidChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();

    _instruction = TextBoxComponent(
      text: _instructions.first,
      position: Vector2(size.x / 2, size.y * 0.025),
      size: Vector2(size.x - 52, 58),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 220,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFFFE8E8), fontSize: 14, fontWeight: FontWeight.w800, height: 1.2),
      ),
    );
    add(_instruction);

    await _addDraggableBandages();
    _addZone(2, Vector2(0.780, 0.515), Vector2(0.15, 0.12), _verifyCirculation);
    _updateZones();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF030E27)));
    }
  }

  Future<void> _addDraggableBandages() async {
    const positions = <double>[0.272, 0.500, 0.728];
    for (var i = 0; i < config.bandageAssets.length; i++) {
      final b = DraggableBandage(
        assetName: config.bandageAssets[i],
        bandageIndex: i,
        position: Vector2(size.x * positions[i], size.y * 0.372),
        size: Vector2.all(size.x * 0.165),
        target: Vector2(size.x * 0.505, size.y * 0.515),
        acceptanceDistance: size.x * 0.19,
        onAttempt: () => _attempts++,
        onIncorrect: (idx) => _showMessage(idx == 0 ? 'Muy flojo' : 'Muy apretado', false),
        onCorrect: _bandagePlaced,
      );
      _bandages.add(b);
      add(b);
    }
  }

  void _addZone(int step, Vector2 fraction, Vector2 sizeFraction, VoidCallback action) {
    final zone = AidTapZone(
      requiredStep: step,
      position: Vector2(size.x * fraction.x, size.y * fraction.y),
      size: Vector2(size.x * sizeFraction.x, size.y * sizeFraction.y),
      onPressed: action,
    );
    _zones.add(zone);
    add(zone);
  }

  void _bandagePlaced(DraggableBandage selected) {
    if (_locked) return;
    _step = 2;
    for (final b in _bandages) { b.removeFromParent(); }
    add(AppliedBandage(position: Vector2(size.x * 0.505, size.y * 0.515), size: Vector2(size.x * 0.190, size.y * 0.064)));
    _instruction.text = _instructions[1];
    _updateZones();
  }

  void _verifyCirculation() {
    if (_locked || _scanning) return;
    _scanning = true;
    add(CirculationScan(position: Vector2(size.x * 0.595, size.y * 0.515), size: Vector2(size.x * 0.515, size.y * 0.105), duration: 1.8));
    Future.delayed(const Duration(milliseconds: 2000), _showCompletion);
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'first_aid_girl.png',
      message: 'Curaste correctamente el brazo y completaste la actividad de primeros auxilios.',
      themeColor: const Color(0xFFFFC857),
      onContinue: () => _finish('completed'),
    ));
  }

  void _showMessage(String text, bool success) {
    _message?.removeFromParent();
    _message = AidMessage(text: text, color: success ? Colors.green : Colors.red, position: Vector2(size.x / 2, size.y * 0.8), size: Vector2(size.x - 70, 58));
    add(_message!);
  }

  void _updateZones() {
    for (final z in _zones) { z.active = z.requiredStep == _step; }
  }

  void _finish(String reason) {
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'firstAid',
      'attempts': _attempts,
      'time': elapsed,
    });
  }
}
