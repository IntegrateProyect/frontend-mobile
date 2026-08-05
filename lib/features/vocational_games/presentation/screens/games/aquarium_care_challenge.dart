import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/game_completion_overlay.dart';
import 'components/aquarium_challenge_components.dart';

class AquariumCareConfig {
  final String backgroundAsset;

  const AquariumCareConfig({required this.backgroundAsset});

  static const defaultConfig = AquariumCareConfig(
    backgroundAsset: 'cuidaracuario.png',
  );
}

class AquariumCareChallengeComponent extends PositionComponent {
  final AquariumCareConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final TemperatureControl _temperature;
  late final WaterValve _waterValve;
  late final FoodDispenser _foodDispenser;
  late final List<AquariumStatusDot> _indicators;

  TextBoxComponent? _instruction;
  PositionComponent? _message;
  int _completedControls = 0;
  int _attempts = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  AquariumCareChallengeComponent({
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
    _addIndicators();
    _addControls();
    _addButtons();
  }

  Future<void> _addBackground() async {
    try {
      add(SpriteComponent(
        sprite: await Sprite.load(config.backgroundAsset),
        size: size.clone(),
        priority: -100,
      ));
    } catch (error) {
      add(RectangleComponent(
        size: size.clone(),
        priority: -100,
        paint: Paint()..color = const Color(0xFF03152A),
      ));
    }
  }

  void _addInstruction() {
    _instruction = TextBoxComponent(
      text: 'Ajusta la temperatura, llena el agua hasta la línea verde y agrega la cantidad correcta de alimento.',
      position: Vector2(size.x / 2, 16),
      size: Vector2(size.x - 48, 58),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 220,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE7F8FF),
          fontSize: 13,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
    add(_instruction!);
  }

  void _addIndicators() {
    _indicators = [
      AquariumStatusDot()..position = Vector2(size.x * 0.345, size.y * 0.224),
      AquariumStatusDot()..position = Vector2(size.x * 0.493, size.y * 0.224),
      AquariumStatusDot()..position = Vector2(size.x * 0.638, size.y * 0.224),
    ];
    addAll(_indicators);
  }

  void _addControls() {
    _temperature = TemperatureControl(
      position: Vector2(size.x * 0.090, size.y * 0.493),
      trackHeight: size.y * 0.275,
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(0, 'Temperatura adecuada: el pez estará cómodo.'),
    );
    add(_temperature);

    _waterValve = WaterValve(
      position: Vector2(size.x * 0.892, size.y * 0.355),
      tankPosition: Vector2(size.x * 0.176, size.y * 0.317),
      tankSize: Vector2(size.x * 0.618, size.y * 0.220),
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(1, 'Nivel correcto: el agua llegó a la línea verde.'),
    );
    add(_waterValve);

    _foodDispenser = FoodDispenser(
      position: Vector2(size.x * 0.493, size.y * 0.756),
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(2, 'Cantidad correcta de alimento.'),
    );
    add(_foodDispenser);
  }

  void _markCorrect(int index, String message) {
    if (_locked || _indicators[index].isCorrect) return;
    _indicators[index].setCorrect();
    _completedControls++;
    
    if (_completedControls == 3) {
      Future.delayed(const Duration(milliseconds: 500), _showCompletion);
    }
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'cuidadora_acuario.png',
      title: '¡Acuario Listo!',
      message: 'Has equilibrado correctamente el hábitat del pez.',
      themeColor: const Color(0xFF45E6B0),
      onContinue: () => _finish('completed'),
    ));
  }

  void _addButtons() {
    add(_SimpleButton(
      text: 'Saltar',
      position: Vector2(size.x / 2, size.y - 38),
      onPressed: () => _finish('skipped'),
    ));
  }

  void _finish(String reason) {
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'aquariumCare',
      'time': elapsed,
      'endReason': reason,
    });
  }
}

class _SimpleButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;
  _SimpleButton({required this.text, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(100, 36), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center));
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}
