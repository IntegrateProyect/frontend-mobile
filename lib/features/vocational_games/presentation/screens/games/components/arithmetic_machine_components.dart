import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class AnimatedGear extends PositionComponent {
  final Color color;
  final double speed;
  bool active = false;

  AnimatedGear({
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
    final center = Offset(size.x / 2, size.y / 2);
    final outerRadius = size.x * 0.45;
    final paint = Paint()..color = color.withOpacity(active ? 0.95 : 0.35);
    for (var i = 0; i < 10; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * pi / 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, -outerRadius), width: size.x * 0.17, height: size.x * 0.20),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
    canvas.drawCircle(center, size.x * 0.34, paint);
    canvas.drawCircle(center, size.x * 0.15, Paint()..color = const Color(0xFF06152E));
  }
}

class OperationButton extends PositionComponent with TapCallbacks {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  bool _locked = false;

  OperationButton({
    required this.label,
    required this.color,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 160);

  void lock() => _locked = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: label,
      position: Vector2(size.x / 2, size.y / 2 + 10),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_locked) return;
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(0.92), EffectController(duration: 0.08)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.14)),
    ]));
    onPressed();
  }
}

class LeverControl extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  bool _animating = false;
  double _animationTime = 0;
  static const double _animationDuration = 0.62;

  LeverControl({required Vector2 position, required Vector2 size, required this.onPressed}) 
      : super(position: position, size: size, anchor: Anchor.center, priority: 180);

  @override
  void update(double dt) {
    super.update(dt);
    if (!_animating) return;
    _animationTime += dt;
    if (_animationTime >= _animationDuration) {
      _animationTime = 0;
      _animating = false;
      onPressed();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _animating ? sin((_animationTime / _animationDuration) * pi) : 0.0;
    final pivot = Offset(size.x * 0.50, size.y * 0.82);
    final restingKnob = Offset(size.x * 0.50, size.y * 0.18);
    final pulledKnob = Offset(size.x * 0.30, size.y * 0.69);
    final knob = Offset.lerp(restingKnob, pulledKnob, progress)!;

    canvas.drawLine(pivot, knob, Paint()..color = Colors.white70..strokeWidth = 6..strokeCap = StrokeCap.round);
    canvas.drawCircle(pivot, size.x * 0.16, Paint()..color = const Color(0xFF223852));
    canvas.drawCircle(knob, size.x * 0.27, Paint()..color = const Color(0xFFFF6659));
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_animating) return;
    _animating = true;
    _animationTime = 0;
  }
}
