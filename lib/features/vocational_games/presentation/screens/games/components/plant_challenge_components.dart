import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlantPressButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  bool _locked = false;

  PlantPressButton({
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 100);

  void lock() => _locked = true;

  void pulse() {
    add(ScaleEffect.to(
      Vector2.all(1.06),
      EffectController(duration: 0.16, reverseDuration: 0.16, alternate: true),
      onComplete: () => scale = Vector2.all(1),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!_locked) onPressed();
  }
}

class PlantStatusOverlay extends PositionComponent {
  int completed;

  PlantStatusOverlay({required Vector2 size, required this.completed})
      : super(size: size, priority: 125);

  @override
  void render(Canvas canvas) {
    const stageY = <double>[0.426, 0.499, 0.589];
    for (var i = 0; i < 3; i++) {
      if (i < completed) {
        final badge = Offset(size.x * 0.168, size.y * stageY[i]);
        canvas.drawCircle(badge, 11, Paint()..color = const Color(0xFF092F2B));
        canvas.drawCircle(badge, 9, Paint()..color = const Color(0xFF55F0A4));
        final checkPaint = Paint()
          ..color = const Color(0xFF043126)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2.5;
        final check = Path()
          ..moveTo(badge.dx - 4, badge.dy)
          ..lineTo(badge.dx - 1, badge.dy + 3)
          ..lineTo(badge.dx + 5, badge.dy - 4);
        canvas.drawPath(check, checkPaint);
      }
    }

    const pointX = <double>[0.393, 0.500, 0.607];
    for (var i = 0; i < 3; i++) {
      final center = Offset(size.x * pointX[i], size.y * 0.748);
      final active = i < completed;
      canvas.drawCircle(center, 13, Paint()..color = const Color(0xFF071C2A));
      canvas.drawCircle(
        center,
        8,
        Paint()..color = active ? const Color(0xFF55F0A4) : const Color(0xFF263E50),
      );
      canvas.drawCircle(
        center,
        12,
        Paint()
          ..color = (active ? const Color(0xFF55F0A4) : const Color(0xFF496171)).withOpacity(0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }
}

class PlantFactCard extends PositionComponent {
  final String title;
  final String text;

  PlantFactCard({
    required this.title,
    required this.text,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 330);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: title,
      position: Vector2(size.x / 2, 10),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF55F0A4), fontSize: 13, fontWeight: FontWeight.w900)),
    ));
    add(TextBoxComponent(
      text: text,
      position: Vector2(size.x / 2, 34),
      size: Vector2(size.x - 28, 44),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE7FFF2), fontSize: 12, fontWeight: FontWeight.w700, height: 1.1)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071D29));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF4DE39A)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class PlantHint extends PositionComponent {
  final String text;
  PlantHint({required this.text, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 22, size.y - 8),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE5FFF1), fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.15)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071D29));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF4DE39A)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class PlantButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  PlantButton({required this.text, required this.color, required Vector2 position, required double width, required this.onPressed})
      : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071A28));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.72)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
