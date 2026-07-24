import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';

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

  late final _TemperatureControl _temperature;
  late final _WaterValve _waterValve;
  late final _FoodDispenser _foodDispenser;
  late final List<_AquariumStatusDot> _indicators;

  TextBoxComponent? _instruction;
  PositionComponent? _message;
  int _completedControls = 0;
  int _attempts = 0;
  int _hintIndex = 0;
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
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
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
    _indicators = <_AquariumStatusDot>[
      _AquariumStatusDot(position: Vector2(size.x * 0.345, size.y * 0.224)),
      _AquariumStatusDot(position: Vector2(size.x * 0.493, size.y * 0.224)),
      _AquariumStatusDot(position: Vector2(size.x * 0.638, size.y * 0.224)),
    ];
    addAll(_indicators);
  }

  void _addControls() {
    _temperature = _TemperatureControl(
      position: Vector2(size.x * 0.090, size.y * 0.493),
      trackHeight: size.y * 0.275,
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(0, 'Temperatura adecuada: el pez estará cómodo y activo.'),
    );
    add(_temperature);

    _waterValve = _WaterValve(
      position: Vector2(size.x * 0.892, size.y * 0.355),
      tankPosition: Vector2(size.x * 0.176, size.y * 0.317),
      tankSize: Vector2(size.x * 0.618, size.y * 0.220),
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(1, 'Nivel correcto: el agua llegó a la línea verde.'),
    );
    add(_waterValve);

    _foodDispenser = _FoodDispenser(
      position: Vector2(size.x * 0.493, size.y * 0.756),
      tankTarget: Vector2(size.x * 0.500, size.y * 0.405),
      onAttempt: () => _attempts++,
      onCorrect: () => _markCorrect(2, 'Cantidad correcta: alimentar de más puede ensuciar el agua.'),
    );
    add(_foodDispenser);
  }

  void _markCorrect(int index, String message) {
    if (_locked || _indicators[index].isCorrect) return;
    _indicators[index].setCorrect();
    _completedControls++;
    _showMessage(message, const Color(0xFF45F2A5));
    add(BurstParticles(
      position: _indicators[index].position,
      color: const Color(0xFF45F2A5),
    ));

    if (_completedControls == 3) {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (isMounted) _finish('completed');
      });
    }
  }

  void _showHint() {
    if (_locked) return;
    const hints = <String>[
      'Observa la zona verde del control izquierdo: ahí está el rango saludable.',
      'La línea verde del tanque marca el nivel de agua que debes alcanzar.',
      'Con el alimento, una cantidad pequeña y medida es mejor que llenar el recipiente.',
      'Los indicadores superiores verdes muestran qué cuidados ya completaste.',
    ];
    final index = _hintIndex.clamp(0, hints.length - 1).toInt();
    _showMessage(hints[index], const Color(0xFF5ADCF5));
    if (_hintIndex < hints.length - 1) _hintIndex++;
  }

  void _showMessage(String text, Color color) {
    _message?.removeFromParent();
    late final _AquariumMessage message;
    message = _AquariumMessage(
      text: text,
      color: color,
      position: Vector2(size.x / 2, 105),
      size: Vector2(size.x - 64, 54),
      onDismiss: () {
        if (identical(_message, message)) {
          message.removeFromParent();
          _message = null;
        }
      },
    );
    _message = message;
    add(message);
  }

  void _addButtons() {
    add(_AquariumButton(
      text: '💡 Pista',
      color: const Color(0xFF45E6B0),
      position: Vector2(size.x / 2 - 62, size.y - 38),
      onPressed: _showHint,
    ));
    add(_AquariumButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 38),
      onPressed: () => _finish('skipped'),
    ));
  }

  int _level() {
    if (_completedControls == 3) return 4;
    if (_completedControls == 2) return 3;
    if (_completedControls == 1) return 2;
    if (_attempts > 0) return 1;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    final level = _level();
    final meta = <String, dynamic>{
      'activityKind': 'biology',
      'challengeType': 'aquariumCare',
      'temperatureCorrect': _temperature.isCorrect,
      'waterCorrect': _waterValve.isCorrect,
      'foodCorrect': _foodDispenser.isCorrect,
      'completedControls': _completedControls,
      'attempts': _attempts,
      'completionTimeSeconds': DateTime.now().difference(_startedAt).inSeconds,
      'endReason': reason,
    };

    // Saltar termina inmediatamente. Al completar correctamente se muestra
    // primero la felicitación y el resultado se envía al tocar Continuar.
    if (reason != 'completed') {
      onFinish(level, meta);
      return;
    }

    _message?.removeFromParent();
    _message = null;
    add(
      _AquariumCompletionOverlay(
        size: size.clone(),
        onContinue: () => onFinish(level, meta),
      ),
    );
  }
}

class _TemperatureControl extends PositionComponent with DragCallbacks {
  final double trackHeight;
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  double value = 0.18;
  bool isCorrect = false;

  _TemperatureControl({
    required Vector2 position,
    required this.trackHeight,
    required this.onAttempt,
    required this.onCorrect,
  }) : super(position: position, size: Vector2(62, trackHeight), anchor: Anchor.center, priority: 150);

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isCorrect) return;
    value = (value - event.localDelta.y / trackHeight).clamp(0.0, 1.0).toDouble();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    onAttempt();
    if (value >= 0.43 && value <= 0.62) {
      value = 0.52;
      isCorrect = true;
      onCorrect();
    }
  }

  @override
  void render(Canvas canvas) {
    if (isCorrect) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(3, 3, size.x - 6, size.y - 6), const Radius.circular(28)),
        Paint()..color = const Color(0xFF45F2A5).withOpacity(0.12),
      );
    }
    final y = size.y * (1 - value);
    canvas.drawCircle(Offset(size.x / 2, y), 18, Paint()..color = const Color(0xFF071D36));
    canvas.drawCircle(Offset(size.x / 2, y), 13, Paint()..color = isCorrect ? const Color(0xFF45F2A5) : const Color(0xFF8BE9FF));
    canvas.drawCircle(Offset(size.x / 2 - 4, y - 4), 3, Paint()..color = Colors.white.withOpacity(0.8));
  }
}

class _WaterValve extends PositionComponent with TapCallbacks {
  final Vector2 tankPosition;
  final Vector2 tankSize;
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  int level = 0;
  bool isCorrect = false;
  double rotation = 0;

  _WaterValve({required Vector2 position, required this.tankPosition, required this.tankSize, required this.onAttempt, required this.onCorrect})
      : super(position: position, size: Vector2.all(82), anchor: Anchor.center, priority: 145);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (isCorrect) return;
    onAttempt();
    level++;
    rotation += math.pi / 3;
    angle = rotation;
    parent?.add(_WaterRiseEffect(position: tankPosition, size: tankSize, progress: level / 4));
    if (level >= 4) {
      isCorrect = true;
      onCorrect();
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final wheel = Paint()
      ..color = isCorrect ? const Color(0xFF45F2A5) : const Color(0xFF53DFF4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(center, 31, wheel);
    for (var i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      canvas.drawLine(
        center + Offset(math.cos(angle) * 8, math.sin(angle) * 8),
        center + Offset(math.cos(angle) * 27, math.sin(angle) * 27),
        wheel,
      );
    }
    if (!isCorrect) return;
    canvas.drawCircle(center, 38, Paint()..color = const Color(0xFF45F2A5).withOpacity(0.18));
    canvas.drawCircle(center, 34, Paint()..color = const Color(0xFF45F2A5)..style = PaintingStyle.stroke..strokeWidth = 3);
  }
}

class _WaterRiseEffect extends PositionComponent {
  final double progress;
  double age = 0;
  _WaterRiseEffect({required Vector2 position, required Vector2 size, required this.progress})
      : super(position: position, size: size, priority: 20);

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age > 0.7) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final height = size.y * progress.clamp(0.0, 1.0).toDouble();
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - height, size.x, height),
      Paint()..color = const Color(0xFF28CFF3).withOpacity(0.10),
    );
  }
}

class _FoodDispenser extends PositionComponent with TapCallbacks {
  final Vector2 tankTarget;
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  int portions = 0;
  bool isCorrect = false;

  _FoodDispenser({required Vector2 position, required this.tankTarget, required this.onAttempt, required this.onCorrect})
      : super(position: position, size: Vector2.all(106), anchor: Anchor.center, priority: 150);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (isCorrect) return;
    onAttempt();
    portions++;
    parent?.add(_FallingFood(start: position.clone(), target: tankTarget.clone()));
    if (portions >= 3) {
      isCorrect = true;
      onCorrect();
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isCorrect) return;
    final center = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(center, 48, Paint()..color = const Color(0xFF45F2A5).withOpacity(0.16));
    canvas.drawCircle(center, 44, Paint()..color = const Color(0xFF45F2A5)..style = PaintingStyle.stroke..strokeWidth = 3);
  }
}

class _FallingFood extends PositionComponent {
  final Vector2 start;
  final Vector2 target;
  double t = 0;
  _FallingFood({required this.start, required this.target}) : super(position: start, size: Vector2.all(1), priority: 210);

  @override
  void update(double dt) {
    super.update(dt);
    t = (t + dt * 1.6).clamp(0.0, 1.0).toDouble();
    position.setFrom(start + (target - start) * t);
    if (t >= 1) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(i * 8.0 - 8, i.isEven ? 0 : 6), 5, Paint()..color = const Color(0xFFFFC34D));
    }
  }
}

class _AquariumStatusDot extends PositionComponent {
  bool isCorrect = false;
  _AquariumStatusDot({required Vector2 position}) : super(position: position, size: Vector2.all(34), anchor: Anchor.center, priority: 230);
  void setCorrect() => isCorrect = true;

  @override
  void render(Canvas canvas) {
    if (!isCorrect) return;
    final center = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(center, 15, Paint()..color = const Color(0xFF45F2A5).withOpacity(0.35));
    canvas.drawCircle(center, 10, Paint()..color = const Color(0xFF45F2A5));
    final check = Path()..moveTo(11, 17)..lineTo(15, 21)..lineTo(24, 12);
    canvas.drawPath(check, Paint()..color = const Color(0xFF052A28)..style = PaintingStyle.stroke..strokeWidth = 2.8..strokeCap = StrokeCap.round);
  }
}

class _AquariumMessage extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onDismiss;
  _AquariumMessage({required this.text, required this.color, required Vector2 position, required Vector2 size, required this.onDismiss})
      : super(position: position, size: size, anchor: Anchor.center, priority: 360);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 22, size.y - 8),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.2, fontWeight: FontWeight.w800)),
    ));
    add(TimerComponent(period: 3.5, removeOnFinish: true, onTick: onDismiss));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071B32).withOpacity(0.96));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onDismiss();
}

class _AquariumButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _AquariumButton({required this.text, required this.color, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(108, 36), anchor: Anchor.center, priority: 330);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071B32).withOpacity(0.92));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _AquariumCompletionOverlay extends PositionComponent {
  final VoidCallback onContinue;

  _AquariumCompletionOverlay({
    required Vector2 size,
    required this.onContinue,
  }) : super(size: size, priority: 10000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final panelWidth = (size.x - 34).clamp(286.0, 430.0).toDouble();
    final panelHeight = (size.y * 0.52).clamp(330.0, 440.0).toDouble();
    final panel = _AquariumCompletionPanel(
      position: size / 2,
      size: Vector2(panelWidth, panelHeight),
    );
    add(panel);

    try {
      final character = await Sprite.load('cuidadora_acuario.png');
      final characterHeight = panelHeight * 0.64;
      final characterWidth =
          characterHeight * character.srcSize.x / character.srcSize.y;
      panel.add(
        SpriteComponent(
          sprite: character,
          position: Vector2(panelWidth * 0.25, panelHeight * 0.56),
          size: Vector2(characterWidth, characterHeight),
          anchor: Anchor.center,
          priority: 2,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar cuidadora_acuario.png: $error');
      panel.add(
        TextComponent(
          text: '🧑‍🔬🐠',
          position: Vector2(panelWidth * 0.25, panelHeight * 0.53),
          anchor: Anchor.center,
          priority: 2,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 58),
          ),
        ),
      );
    }

    panel.add(
      TextComponent(
        text: '¡Felicidades!',
        position: Vector2(panelWidth * 0.70, panelHeight * 0.20),
        anchor: Anchor.center,
        priority: 3,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF45E6B0),
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

    panel.add(
      TextBoxComponent(
        text:
        'Cuidaste correctamente el acuario. Equilibraste la temperatura, '
            'el nivel del agua y la cantidad de alimento para mantener al pez '
            'sano y su hábitat estable.',
        position: Vector2(panelWidth * 0.49, panelHeight * 0.30),
        size: Vector2(panelWidth * 0.45, panelHeight * 0.36),
        priority: 3,
        align: Anchor.topLeft,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    panel.add(
      _AquariumContinueButton(
        position: Vector2(panelWidth * 0.70, panelHeight * 0.83),
        size: Vector2(panelWidth * 0.43, 52),
        onPressed: onContinue,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF001226).withOpacity(0.84),
    );
  }
}

class _AquariumCompletionPanel extends PositionComponent {
  _AquariumCompletionPanel({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 1,
  );

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(28),
    );
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF12304A));
    canvas.drawRRect(
      shape,
      Paint()
        ..color = const Color(0xFF45E6B0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }
}

class _AquariumContinueButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  bool _pressed = false;

  _AquariumContinueButton({
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 5,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextComponent(
        text: 'Continuar',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF071726),
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Radius.circular(size.y / 2),
    );
    canvas.drawRRect(
      shape,
      Paint()
        ..color = _pressed
            ? const Color(0xFF36C796)
            : const Color(0xFF45E6B0),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_pressed) return;
    _pressed = true;
    onPressed();
  }
}