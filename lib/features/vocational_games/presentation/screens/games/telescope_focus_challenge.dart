import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TelescopeFocusConfig {
  final String backgroundAsset;
  final double initialFocus;
  final double correctStart;
  final double correctEnd;

  const TelescopeFocusConfig({
    required this.backgroundAsset,
    required this.initialFocus,
    required this.correctStart,
    required this.correctEnd,
  });

  static const TelescopeFocusConfig defaultConfig = TelescopeFocusConfig(
    backgroundAsset: 'telescopioregalo.png',
    initialFocus: 0.10,
    correctStart: 0.72,
    correctEnd: 0.84,
  );
}

class TelescopeFocusChallengeComponent extends PositionComponent {
  final TelescopeFocusConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final _FocusedStar _star;
  late final _FocusIndicators _indicators;
  late final _FocusDial _dial;

  double _focus = 0;
  double _maximumFocus = 0;
  int _adjustments = 0;
  bool _touchedAny = false;
  bool _locked = false;

  final DateTime _startedAt = DateTime.now();

  TelescopeFocusChallengeComponent({
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
    _focus = config.initialFocus;
    _maximumFocus = _focus;
    await _addBackground();
    _addInstruction();
    _addStar();
    _addIndicators();
    _addDial();
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
          paint: Paint()..color = const Color(0xFF030B23),
        ),
      );
    }
  }

  void _addInstruction() {
    add(
      TextBoxComponent(
        text: 'Gira la perilla circular hasta que la estrella quede nítida y el indicador entre en la zona verde.',
        position: Vector2(size.x / 2, size.y * 0.028),
        size: Vector2(size.x - 54, 62),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 200,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFE4F9FF),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  void _addStar() {
    _star = _FocusedStar(
      position: Vector2(size.x * 0.716, size.y * 0.232),
      size: Vector2.all(size.x * 0.165),
      focus: _focus,
    );
    add(_star);
  }

  void _addIndicators() {
    _indicators = _FocusIndicators(
      position: Vector2(size.x * 0.500, size.y * 0.585),
      size: Vector2(size.x * 0.235, 30),
      focus: _focus,
    );
    add(_indicators);
  }

  void _addDial() {
    _dial = _FocusDial(
      position: Vector2(size.x * 0.500, size.y * 0.795),
      size: Vector2.all(size.x * 0.610),
      focus: _focus,
      correctStart: config.correctStart,
      correctEnd: config.correctEnd,
      onFocusChanged: _onFocusChanged,
      onAdjustmentFinished: _onAdjustmentFinished,
    );
    add(_dial);
  }

  void _onFocusChanged(double value) {
    if (_locked) return;
    _touchedAny = true;
    _focus = value.clamp(0.0, 1.0);
    _maximumFocus = max(_maximumFocus, _focus);
    _star.focus = _focus;
    _indicators.focus = _focus;
  }

  void _onAdjustmentFinished() {
    if (_locked) return;
    _adjustments++;
    if (_focus >= config.correctStart && _focus <= config.correctEnd) {
      _finish();
    }
  }

  void _finish() {
    if (_locked) return;
    _locked = true;
    _dial.lock();
    _star.focus = 1;
    _indicators.focus = 1;

    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(
      4,
      <String, dynamic>{
        'activityKind': 'astronomy',
        'challengeType': 'telescopeFocus',
        'finalFocus': _focus,
        'maximumFocus': _maximumFocus,
        'adjustments': _adjustments,
        'touchedAny': _touchedAny,
        'completionTimeSeconds': elapsed,
        'endReason': 'completed',
      },
    );
  }
}

class _FocusDial extends PositionComponent with DragCallbacks {
  final double correctStart;
  final double correctEnd;
  final ValueChanged<double> onFocusChanged;
  final VoidCallback onAdjustmentFinished;

  double focus;
  bool _dragging = false;
  bool _locked = false;

  _FocusDial({
    required Vector2 position,
    required Vector2 size,
    required this.focus,
    required this.correctStart,
    required this.correctEnd,
    required this.onFocusChanged,
    required this.onAdjustmentFinished,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 120,
  );

  void lock() {
    _locked = true;
    _dragging = false;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_locked) return;
    _dragging = true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_dragging || _locked) return;

    // Movimiento tangencial: derecha/arriba aumenta el enfoque;
    // izquierda/abajo lo disminuye.
    final change =
        (event.localDelta.x - event.localDelta.y) / (size.x * 1.15);
    focus = (focus + change).clamp(0.0, 1.0);
    onFocusChanged(focus);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_dragging || _locked) return;
    _dragging = false;
    onAdjustmentFinished();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_locked) return;
    _dragging = false;
    onAdjustmentFinished();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.465;
    final start = -pi * 0.85;
    final sweep = pi * 1.70;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      Paint()
        ..color = const Color(0xFF26365E).withOpacity(0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start + sweep * correctStart,
      sweep * (correctEnd - correctStart),
      false,
      Paint()
        ..color = const Color(0xFF65F5B5)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8,
    );

    final pointerAngle = start + sweep * focus;
    final pointer = Offset(
      center.dx + cos(pointerAngle) * radius,
      center.dy + sin(pointerAngle) * radius,
    );

    canvas.drawCircle(
      pointer,
      10,
      Paint()..color = const Color(0xFF49E9F6),
    );
    canvas.drawCircle(
      pointer,
      15,
      Paint()
        ..color = const Color(0xFF49E9F6).withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
  }
}

class _FocusedStar extends PositionComponent {
  double focus;

  _FocusedStar({
    required Vector2 position,
    required Vector2 size,
    required this.focus,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 100,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = Offset(size.x / 2, size.y / 2);
    final blur = 2 + (1 - focus) * 18;
    final glowRadius = size.x * (0.23 + (1 - focus) * 0.22);

    canvas.drawCircle(
      center,
      size.x * 0.48,
      Paint()..color = const Color(0xFF031334).withOpacity(0.72),
    );
    canvas.drawCircle(
      center,
      glowRadius,
      Paint()
        ..color = const Color(0xFFFFD66A).withOpacity(0.48)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );
    canvas.drawCircle(
      center,
      4 + focus * 4,
      Paint()..color = Colors.white,
    );

    if (focus > 0.62) {
      final length = size.x * (0.18 + focus * 0.12);
      final paint = Paint()
        ..color = const Color(0xFFFFE8A6).withOpacity(focus)
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(center.dx - length, center.dy),
        Offset(center.dx + length, center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - length),
        Offset(center.dx, center.dy + length),
        paint,
      );
    }
  }
}

class _FocusIndicators extends PositionComponent {
  double focus;

  _FocusIndicators({
    required Vector2 position,
    required Vector2 size,
    required this.focus,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 110,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final activeCount = focus < 0.34
        ? 1
        : focus < 0.67
        ? 2
        : 3;
    final spacing = size.x / 4;

    for (var index = 0; index < 3; index++) {
      final center = Offset(spacing * (index + 1), size.y / 2);
      final active = index < activeCount;
      canvas.drawCircle(
        center,
        8,
        Paint()
          ..color = active
              ? const Color(0xFF49E9F6)
              : const Color(0xFF26365E),
      );
      if (active) {
        canvas.drawCircle(
          center,
          12,
          Paint()
            ..color = const Color(0xFF49E9F6).withOpacity(0.35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );
      }
    }
  }
}