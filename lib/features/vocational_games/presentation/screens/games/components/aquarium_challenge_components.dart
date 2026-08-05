import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TemperatureControl extends PositionComponent with DragCallbacks {
  final double trackHeight;
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  double value = 0.18;
  bool isCorrect = false;

  TemperatureControl({required Vector2 position, required this.trackHeight, required this.onAttempt, required this.onCorrect})
      : super(position: position, size: Vector2(62, trackHeight), anchor: Anchor.center, priority: 150);

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
    final y = size.y * (1 - value);
    canvas.drawCircle(Offset(size.x / 2, y), 13, Paint()..color = isCorrect ? const Color(0xFF45F2A5) : const Color(0xFF8BE9FF));
  }
}

class WaterValve extends PositionComponent with TapCallbacks {
  final Vector2 tankPosition;
  final Vector2 tankSize;
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  int level = 0;
  bool isCorrect = false;

  WaterValve({required Vector2 position, required this.tankPosition, required this.tankSize, required this.onAttempt, required this.onCorrect})
      : super(position: position, size: Vector2.all(82), anchor: Anchor.center, priority: 145);

  @override
  void onTapDown(TapDownEvent event) {
    if (isCorrect) return;
    onAttempt();
    level++;
    angle += math.pi / 3;
    if (level >= 4) {
      isCorrect = true;
      onCorrect();
    }
  }
}

class FoodDispenser extends PositionComponent with TapCallbacks {
  final VoidCallback onAttempt;
  final VoidCallback onCorrect;
  int portions = 0;
  bool isCorrect = false;

  FoodDispenser({required Vector2 position, required this.onAttempt, required this.onCorrect})
      : super(position: position, size: Vector2.all(106), anchor: Anchor.center, priority: 150);

  @override
  void onTapDown(TapDownEvent event) {
    if (isCorrect) return;
    onAttempt();
    portions++;
    if (portions >= 3) {
      isCorrect = true;
      onCorrect();
    }
  }
}

class AquariumStatusDot extends PositionComponent {
  bool isCorrect = false;
  void setCorrect() => isCorrect = true;

  @override
  void render(Canvas canvas) {
    if (!isCorrect) return;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 10, Paint()..color = const Color(0xFF45F2A5));
  }
}
