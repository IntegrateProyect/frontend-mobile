import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'components/game_completion_overlay.dart';
import 'components/arithmetic_machine_components.dart';

class ArithmeticMachineConfig {
  final String backgroundAsset;
  final int initialValue;
  final int targetValue;
  final List<String> operationLabels;
  final List<int Function(int)> operations;
  final int correctOperationIndex;

  ArithmeticMachineConfig({
    required this.backgroundAsset,
    required this.initialValue,
    required this.targetValue,
    required this.operationLabels,
    required this.operations,
    required this.correctOperationIndex,
  });

  static final ArithmeticMachineConfig defaultConfig = ArithmeticMachineConfig(
    backgroundAsset: 'mecanisacionesaritmeticas.png',
    initialValue: 4,
    targetValue: 8,
    operationLabels: const ['+2', '×2', '−2'],
    operations: [
      (value) => value + 2,
      (value) => value * 2,
      (value) => value - 2,
    ],
    correctOperationIndex: 1,
  );
}

class ArithmeticMachineChallengeComponent extends PositionComponent {
  final ArithmeticMachineConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  final List<OperationButton> _operationButtons = [];
  final DateTime _startedAt = DateTime.now();

  late final AnimatedGear _leftGear;
  late final AnimatedGear _rightGear;
  late final TextComponent _resultDisplay;

  PositionComponent? _messageBanner;
  int? _selectedOperation;
  int _attempts = 0;
  bool _touchedAny = false;
  bool _locked = false;

  ArithmeticMachineChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addDisplays();
    _addGears();
    _addOperationButtons();
    _addLever();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF010B26)));
    }
  }

  void _addDisplays() {
    add(TextComponent(
      text: '${config.initialValue}',
      position: Vector2(size.x * 0.180, size.y * 0.442),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF58F0C1), fontSize: 34, fontWeight: FontWeight.w900)),
    ));

    _resultDisplay = TextComponent(
      text: '${config.targetValue}',
      position: Vector2(size.x * 0.815, size.y * 0.442),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFFF746C), fontSize: 34, fontWeight: FontWeight.w900)),
    );
    add(_resultDisplay);
  }

  void _addGears() {
    _leftGear = AnimatedGear(position: Vector2(size.x * 0.455, size.y * 0.442), size: Vector2.all(size.x * 0.105), color: const Color(0xFF28DDEB), speed: 2.7);
    _rightGear = AnimatedGear(position: Vector2(size.x * 0.555, size.y * 0.442), size: Vector2.all(size.x * 0.105), color: const Color(0xFFFF951F), speed: -2.7);
    add(_leftGear);
    add(_rightGear);
  }

  void _addOperationButtons() {
    final positions = [Vector2(size.x * 0.302, size.y * 0.590), Vector2(size.x * 0.500, size.y * 0.590), Vector2(size.x * 0.690, size.y * 0.590)];
    final colors = [const Color(0xFF58E4C0), const Color(0xFFFFA51E), const Color(0xFF9664F5)];

    for (var i = 0; i < 3; i++) {
      final btn = OperationButton(
        label: config.operationLabels[i],
        color: colors[i],
        position: positions[i],
        size: Vector2.all(size.x * 0.145),
        onPressed: () => _selectOperation(i),
      );
      _operationButtons.add(btn);
      add(btn);
    }
  }

  void _selectOperation(int index) {
    if (_locked) return;
    _touchedAny = true;
    _selectedOperation = index;
    _leftGear.active = true;
    _rightGear.active = true;
  }

  void _addLever() {
    add(LeverControl(
      position: Vector2(size.x * 0.935, size.y * 0.585),
      size: Vector2(size.x * 0.115, size.y * 0.205),
      onPressed: _confirmOperation,
    ));
  }

  void _confirmOperation() {
    if (_locked || _selectedOperation == null) return;
    _attempts++;
    final result = config.operations[_selectedOperation!](config.initialValue);

    if (result == config.targetValue && _selectedOperation == config.correctOperationIndex) {
      _locked = true;
      _leftGear.active = false;
      _rightGear.active = false;
      add(GameCompletionOverlay(
        size: size.clone(),
        onContinue: () => _finish('completed'),
        characterAsset: 'adolescente_mecanica.png',
        title: '¡Mecanización lograda!',
        message: 'Has configurado correctamente la máquina aritmética.',
        themeColor: const Color(0xFFFFC247),
      ));
    } else {
      _leftGear.active = false;
      _rightGear.active = false;
      _selectedOperation = null;
    }
  }

  void _finish(String reason) {
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'arithmeticMachine',
      'attempts': _attempts,
      'time': elapsed,
      'endReason': reason,
    });
  }
}
