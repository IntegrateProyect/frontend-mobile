import 'dart:math';

// Reto interactivo de mecanizaciones aritméticas.

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

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

  static final ArithmeticMachineConfig defaultConfig =
  ArithmeticMachineConfig(
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

  final List<_OperationButton> _operationButtons = [];
  final DateTime _startedAt = DateTime.now();

  late final _AnimatedGear _leftGear;
  late final _AnimatedGear _rightGear;
  late final TextComponent _resultDisplay;

  PositionComponent? _messageBanner;
  int? _selectedOperation;
  int _attempts = 0;
  int _hintsUsed = 0;
  bool _touchedAny = false;
  bool _locked = false;

  ArithmeticMachineChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.topCenter,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _validateConfig();
    await _addBackground();
    _addInstruction();
    _addDisplays();
    _addGears();
    _addOperationButtons();
    _addLever();
    _addBottomButtons();
  }

  void _validateConfig() {
    if (config.operationLabels.length != 3 ||
        config.operations.length != 3 ||
        config.correctOperationIndex < 0 ||
        config.correctOperationIndex >= 3) {
      throw ArgumentError('La máquina necesita exactamente tres operaciones.');
    }
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(
        SpriteComponent(
          sprite: sprite,
          position: Vector2.zero(),
          size: size.clone(),
          priority: -100,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
      add(
        RectangleComponent(
          size: size.clone(),
          priority: -100,
          paint: Paint()..color = const Color(0xFF010B26),
        ),
      );
    }
  }

  void _addInstruction() {
    add(
      TextBoxComponent(
        text: 'Elige la operación que transforma el número inicial en el resultado. Después toca la palanca para confirmar.',
        position: Vector2(size.x / 2, size.y * 0.035),
        size: Vector2(size.x - 54, 64),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 200,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFDDF7FF),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  void _addDisplays() {
    add(
      TextComponent(
        text: '${config.initialValue}',
        position: Vector2(size.x * 0.180, size.y * 0.442),
        anchor: Anchor.center,
        priority: 100,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF58F0C1),
            fontSize: 34,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(color: Color(0xFF34EAB5), blurRadius: 14),
            ],
          ),
        ),
      ),
    );

    _resultDisplay = TextComponent(
      text: '${config.targetValue}',
      position: Vector2(size.x * 0.815, size.y * 0.442),
      anchor: Anchor.center,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFF746C),
          fontSize: 34,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: Color(0xFFFF5E58), blurRadius: 14),
          ],
        ),
      ),
    );
    add(_resultDisplay);
  }

  void _addGears() {
    _leftGear = _AnimatedGear(
      position: Vector2(size.x * 0.455, size.y * 0.442),
      size: Vector2.all(size.x * 0.105),
      color: const Color(0xFF28DDEB),
      speed: 2.7,
    );
    _rightGear = _AnimatedGear(
      position: Vector2(size.x * 0.555, size.y * 0.442),
      size: Vector2.all(size.x * 0.105),
      color: const Color(0xFFFF951F),
      speed: -2.7,
    );
    add(_leftGear);
    add(_rightGear);
  }

  void _addOperationButtons() {
    final positions = <Vector2>[
      Vector2(size.x * 0.302, size.y * 0.590),
      Vector2(size.x * 0.500, size.y * 0.590),
      Vector2(size.x * 0.690, size.y * 0.590),
    ];
    final colors = <Color>[
      const Color(0xFF58E4C0),
      const Color(0xFFFFA51E),
      const Color(0xFF9664F5),
    ];

    for (var index = 0; index < 3; index++) {
      final button = _OperationButton(
        label: config.operationLabels[index],
        color: colors[index],
        position: positions[index],
        size: Vector2.all(size.x * 0.145),
        onPressed: () => _selectOperation(index),
      );
      _operationButtons.add(button);
      add(button);
    }
  }

  void _selectOperation(int index) {
    if (_locked) return;
    _touchedAny = true;
    _selectedOperation = index;
    for (var i = 0; i < _operationButtons.length; i++) {
      _operationButtons[i].selected = i == index;
    }
    _leftGear.active = true;
    _rightGear.active = true;
    final preview = config.operations[index](config.initialValue);
    _showMessage(
      'Operación ${config.operationLabels[index]} seleccionada. Resultado: $preview. Ahora toca la palanca.',
      const Color(0xFF29DDF2),
    );
  }

  void _addLever() {
    add(
      _LeverControl(
        position: Vector2(size.x * 0.935, size.y * 0.585),
        size: Vector2(size.x * 0.115, size.y * 0.205),
        onPressed: _confirmOperation,
      ),
    );
  }

  void _confirmOperation() {
    if (_locked) return;
    if (_selectedOperation == null) {
      _showMessage(
        'Primero selecciona uno de los tres botones de operación.',
        const Color(0xFFFFC247),
      );
      return;
    }

    _attempts++;
    final selected = _selectedOperation!;
    final result = config.operations[selected](config.initialValue);

    if (result == config.targetValue &&
        selected == config.correctOperationIndex) {
      _locked = true;
      _resultDisplay.text = '$result';
      _showMessage('¡Correcto! La máquina obtuvo $result.', const Color(0xFF45E5AC));
      for (final button in _operationButtons) {
        button.lock();
      }
      add(
        TimerComponent(
          period: 0.8,
          removeOnFinish: true,
          onTick: () => _finish(reason: 'completed', forceLevel: 4),
        ),
      );
    } else {
      _leftGear.active = false;
      _rightGear.active = false;
      _showMessage(
        '$result no es el resultado esperado. Prueba otra operación.',
        const Color(0xFFFF746C),
      );
      _selectedOperation = null;
      for (final button in _operationButtons) {
        button.selected = false;
      }
    }
  }

  void _addBottomButtons() {
    add(
      _MachineActionButton(
        text: '💡 Pista',
        color: const Color(0xFF29DDF2),
        position: Vector2(size.x / 2 - 62, size.y - 40),
        width: 108,
        onPressed: _showHint,
      ),
    );
    add(
      _MachineActionButton(
        text: 'Saltar',
        color: const Color(0xFF90A4AE),
        position: Vector2(size.x / 2 + 62, size.y - 40),
        width: 108,
        onPressed: () => _finish(reason: 'skipped'),
      ),
    );
  }

  void _showHint() {
    if (_locked) return;
    _hintsUsed++;
    final index = config.correctOperationIndex;
    _operationButtons[index].pulse();
    _showMessage(
      'Pista: busca una operación que convierta ${config.initialValue} en ${config.targetValue}.',
      const Color(0xFFFFC247),
    );
  }

  void _showMessage(String text, Color color) {
    _messageBanner?.removeFromParent();
    final banner = _MachineBanner(
      text: text,
      color: color,
      position: Vector2(size.x / 2, size.y * 0.185),
      size: Vector2(size.x - 70, 64),
    );
    _messageBanner = banner;
    add(banner);
  }

  int _currentLevel() {
    if (_attempts >= 2) return 3;
    if (_attempts == 1) return 2;
    if (_touchedAny) return 1;
    return 0;
  }

  void _finish({required String reason, int? forceLevel}) {
    if (_locked && reason != 'completed') return;
    _locked = true;
    _leftGear.active = false;
    _rightGear.active = false;
    for (final button in _operationButtons) {
      button.lock();
    }
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(
      forceLevel ?? _currentLevel(),
      <String, dynamic>{
        'activityKind': 'numeric',
        'challengeType': 'arithmeticMachine',
        'initialValue': config.initialValue,
        'targetValue': config.targetValue,
        'selectedOperation': _selectedOperation == null
            ? null
            : config.operationLabels[_selectedOperation!],
        'attempts': _attempts,
        'hintsUsed': _hintsUsed,
        'touchedAny': _touchedAny,
        'completionTimeSeconds': elapsed,
        'endReason': reason,
      },
    );
  }
}

class _AnimatedGear extends PositionComponent {
  final Color color;
  final double speed;
  bool active = false;

  _AnimatedGear({
    required Vector2 position,
    required Vector2 size,
    required this.color,
    required this.speed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 110);

  @override
  void update(double dt) {
    super.update(dt);
    if (active) angle += speed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = Offset(size.x / 2, size.y / 2);
    final outerRadius = size.x * 0.45;
    final paint = Paint()..color = color.withOpacity(active ? 0.95 : 0.35);
    for (var i = 0; i < 10; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * pi / 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(0, -outerRadius),
            width: size.x * 0.17,
            height: size.x * 0.20,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
    canvas.drawCircle(center, size.x * 0.34, paint);
    canvas.drawCircle(
      center,
      size.x * 0.15,
      Paint()..color = const Color(0xFF06152E),
    );
  }
}

class _OperationButton extends PositionComponent with TapCallbacks {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  bool selected = false;
  bool _locked = false;

  _OperationButton({
    required this.label,
    required this.color,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 160);

  void lock() => _locked = true;

  void pulse() {
    if (_locked) return;
    add(
      ScaleEffect.to(
        Vector2.all(1.16),
        EffectController(
          duration: 0.22,
          reverseDuration: 0.22,
          alternate: true,
          repeatCount: 3,
        ),
        onComplete: () => scale = Vector2.all(1),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextComponent(
        text: label,
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!selected) return;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x * 0.48,
      Paint()
        ..color = color.withOpacity(0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!_locked) onPressed();
  }
}

class _LeverControl extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  _LeverControl({
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 180);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _MachineBanner extends PositionComponent {
  final String text;
  final Color color;
  _MachineBanner({
    required this.text,
    required this.color,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextBoxComponent(
        text: text,
        position: size / 2,
        size: Vector2(size.x - 26, size.y - 12),
        anchor: Anchor.center,
        align: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF10243E).withOpacity(0.96));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}

class _MachineActionButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _MachineActionButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
    double width = 100,
  }) : super(
    position: position,
    size: Vector2(width, 36),
    anchor: Anchor.center,
    priority: 300,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextComponent(
        text: text,
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            color: color.withOpacity(0.98),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF101D35).withOpacity(0.9));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
