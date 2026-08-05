import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CarpetTile extends PositionComponent with TapCallbacks {
  final void Function(CarpetTile tile) onCovered;
  bool covered = false;

  CarpetTile({
    required Vector2 position,
    required Vector2 size,
    required this.onCovered,
  }) : super(position: position, size: size, priority: 100);

  void cover() => covered = true;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onCovered(this);
  }

  @override
  void render(Canvas canvas) {
    if (!covered) return;
    final rect = Rect.fromLTWH(1.2, 1.2, size.x - 2.4, size.y - 2.4);
    final carpetPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFB12B), Color(0xFFE87500)],
      ).createShader(rect);
    canvas.drawRect(rect, carpetPaint);

    canvas.save();
    canvas.clipRect(rect);
    final fiber = Paint()
      ..color = const Color(0xFFFFD27A).withOpacity(0.18)
      ..strokeWidth = 0.7;
    for (double x = -size.y; x < size.x; x += 7) {
      canvas.drawLine(Offset(x, size.y), Offset(x + size.y, 0), fiber);
    }
    canvas.restore();

    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFFFC45A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}

class AreaProgressPips extends PositionComponent {
  final int total;
  int covered = 0;

  AreaProgressPips({
    required Vector2 position,
    required Vector2 size,
    required this.total,
  }) : super(position: position, size: size, priority: 228);

  @override
  void render(Canvas canvas) {
    const columns = 5;
    final unitWidth = size.x / columns;
    final unitHeight = size.y / (total / columns);

    for (var index = 0; index < total; index++) {
      if (index >= covered) continue;
      final column = index % columns;
      final row = index ~/ columns;
      final rect = Rect.fromLTWH(
        column * unitWidth + unitWidth * 0.09,
        row * unitHeight + unitHeight * 0.10,
        unitWidth * 0.80,
        unitHeight * 0.78,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.5)),
        Paint()..color = const Color(0xFFFFA31A),
      );
    }
  }
}

class MeasurementLabel extends PositionComponent {
  final String text;

  MeasurementLabel({required this.text, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 220);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF72E6FF), fontSize: 13, fontWeight: FontWeight.w900),
      ),
    ));
  }
}

class AreaMessage extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onDismiss;

  AreaMessage({required this.text, required Vector2 position, required Vector2 size, required this.onDismiss})
      : super(position: position, size: size, anchor: Anchor.center, priority: 350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 22, size.y - 8),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF72E6FF), fontSize: 12.5, fontWeight: FontWeight.w800),
      ),
    ));
    add(TimerComponent(period: 3, removeOnFinish: true, onTick: onDismiss));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF081831).withOpacity(0.96));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF29B6F6)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onDismiss();
}

class AreaButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  AreaButton({required this.text, required this.color, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(108, 36), anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF081831).withOpacity(0.92));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
