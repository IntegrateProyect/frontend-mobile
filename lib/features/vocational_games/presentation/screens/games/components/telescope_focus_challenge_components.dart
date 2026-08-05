import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class InvisibleFocusDial extends PositionComponent with DragCallbacks {
  final double correctStart;
  final double correctEnd;
  final ValueChanged<double> onFocusChanged;
  final VoidCallback onAdjustmentFinished;

  double focus;
  double? _previousAngle;
  Vector2? _pointerPosition;
  bool _dragging = false;
  bool _locked = false;

  InvisibleFocusDial({
    required Vector2 position,
    required Vector2 size,
    required double initialFocus,
    required this.correctStart,
    required this.correctEnd,
    required this.onFocusChanged,
    required this.onAdjustmentFinished,
  })  : focus = initialFocus,
        super(
        position: position,
        size: size,
        anchor: Anchor.center,
        priority: 150,
      );

  void lock() {
    _locked = true;
    _dragging = false;
    _previousAngle = null;
    _pointerPosition = null;
  }

  double _angleFor(Vector2 point) {
    final center = size / 2;
    return atan2(point.y - center.y, point.x - center.x);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_locked) return;
    _dragging = true;
    _pointerPosition = event.localPosition.clone();
    _previousAngle = _angleFor(_pointerPosition!);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_dragging || _locked) return;

    _pointerPosition ??= size / 2;
    _pointerPosition!.add(event.localDelta);
    final currentAngle = _angleFor(_pointerPosition!);
    final previousAngle = _previousAngle ?? currentAngle;

    var delta = currentAngle - previousAngle;
    if (delta > pi) delta -= 2 * pi;
    if (delta < -pi) delta += 2 * pi;

    focus = (focus + delta / (2 * pi)).clamp(0.0, 1.0);
    _previousAngle = currentAngle;
    onFocusChanged(focus);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_dragging || _locked) return;
    _dragging = false;
    _previousAngle = null;
    _pointerPosition = null;
    onAdjustmentFinished();
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.455;
    const startAngle = -pi;
    const totalSweep = pi * 1.5;

    final targetStart = startAngle + totalSweep * correctStart;
    final targetSweep = totalSweep * (correctEnd - correctStart);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      targetStart,
      targetSweep,
      false,
      Paint()
        ..color = const Color(0xFF65F5B5)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8,
    );

    final handleAngle = startAngle + totalSweep * focus;
    final handle = Offset(
      center.dx + cos(handleAngle) * radius,
      center.dy + sin(handleAngle) * radius,
    );

    canvas.drawCircle(handle, 17, Paint()..color = const Color(0xFF07162F).withOpacity(0.82));
    canvas.drawCircle(handle, 14, Paint()..color = const Color(0xFF49E9F6));
  }
}

class FocusedStar extends PositionComponent {
  double focus;
  FocusedStar({required Vector2 position, required Vector2 size, required this.focus})
      : super(position: position, size: size, anchor: Anchor.center, priority: 100);

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final blur = 1.5 + (1 - focus) * 13;
    final glowRadius = size.x * (0.16 + (1 - focus) * 0.24);

    canvas.drawCircle(
      center,
      glowRadius,
      Paint()
        ..color = const Color(0xFFFFD66A).withOpacity(0.38)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );
    canvas.drawCircle(center, 3.5 + focus * 3.2, Paint()..color = Colors.white);
  }
}

class FocusProgress extends PositionComponent {
  double focus;
  FocusProgress({required Vector2 position, required Vector2 size, required this.focus})
      : super(position: position, size: size, anchor: Anchor.center, priority: 110);

  @override
  void render(Canvas canvas) {
    final activeCount = focus < 0.34 ? 1 : focus < 0.67 ? 2 : 3;
    final spacing = size.x / 4;
    for (var i = 0; i < 3; i++) {
      if (i >= activeCount) continue;
      canvas.drawCircle(Offset(spacing * (i + 1), size.y / 2), 5.5, Paint()..color = const Color(0xFF49E9F6));
    }
  }
}

class FocusButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  FocusButton({required this.text, required this.color, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(108, 36), anchor: Anchor.center, priority: 300);

  @override
  Future<void> onLoad() async {
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(size.toRect(), Radius.circular(size.y / 2));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF0C1B31).withOpacity(0.92));
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.70)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}
