import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DraggableBandage extends SpriteComponent with DragCallbacks, TapCallbacks {
  final String assetName;
  final int bandageIndex;
  final Vector2 target;
  final double acceptanceDistance;
  final VoidCallback onAttempt;
  final ValueChanged<int> onIncorrect;
  final ValueChanged<DraggableBandage> onCorrect;

  late final Vector2 _startPosition;
  bool _dragging = false;
  bool _placed = false;
  bool _locked = false;

  DraggableBandage({
    required this.assetName,
    required this.bandageIndex,
    required Vector2 position,
    required Vector2 size,
    required this.target,
    required this.acceptanceDistance,
    required this.onAttempt,
    required this.onIncorrect,
    required this.onCorrect,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 170) {
    _startPosition = position.clone();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(assetName);
  }

  void lock() {
    _locked = true;
    _dragging = false;
  }

  void pulse() {
    if (_locked || _placed) return;
    add(ScaleEffect.to(
      Vector2.all(1.08),
      EffectController(duration: 0.18, reverseDuration: 0.18, alternate: true, repeatCount: 2),
      onComplete: () { if (!_placed) scale = Vector2.all(1); },
    ));
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_locked || _placed) return;
    _dragging = true;
    priority = 260;
    scale = Vector2.all(1.05);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_locked || _placed) return;
    onAttempt();
    if (bandageIndex == 0 || bandageIndex == 2) {
      onIncorrect(bandageIndex);
    } else {
      pulse();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_dragging || _locked || _placed) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_dragging || _locked || _placed) return;
    _dragging = false;
    onAttempt();

    if (position.distanceTo(target) <= acceptanceDistance && bandageIndex == 1) {
      _placed = true;
      _locked = true;
      position.setFrom(target);
      scale = Vector2.all(0.72);
      priority = 190;
      onCorrect(this);
      return;
    }

    if (position.distanceTo(target) <= acceptanceDistance) onIncorrect(bandageIndex);
    _returnToStart();
  }

  void _returnToStart() {
    position.setFrom(_startPosition);
    scale = Vector2.all(1);
    priority = 170;
  }
}

class AidTapZone extends PositionComponent with TapCallbacks {
  final int requiredStep;
  final VoidCallback onPressed;
  bool active = false;

  AidTapZone({required this.requiredStep, required Vector2 position, required Vector2 size, required this.onPressed})
      : super(position: position, size: size, anchor: Anchor.center, priority: 150);

  @override
  void onTapDown(TapDownEvent event) {
    if (active) onPressed();
  }
}

class AidMessage extends PositionComponent {
  final String text;
  final Color color;
  AidMessage({required this.text, required this.color, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 24, size.y - 10),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.15)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF09172C));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.78)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class AppliedBandage extends PositionComponent {
  AppliedBandage({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 195);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final shape = RRect.fromRectAndRadius(rect, Radius.circular(size.y * 0.20));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFFE8D2A9));
    const strips = 6;
    final stripWidth = size.x / strips;
    for (var i = 1; i < strips; i++) {
      canvas.drawLine(Offset(stripWidth * i, 3), Offset(stripWidth * i, size.y - 3), Paint()..color = const Color(0xFFB89A6E).withOpacity(0.72));
    }
  }
}

class CirculationScan extends PositionComponent {
  final double duration;
  double _elapsed = 0;
  CirculationScan({required Vector2 position, required Vector2 size, required this.duration})
      : super(position: position, size: size, anchor: Anchor.center, priority: 205);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed = (_elapsed + dt).clamp(0.0, duration);
    if (_elapsed >= duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = _elapsed / duration;
    final centerX = size.x * (0.10 + (progress * 6).floor() * 0.145);
    final pulse = Offset(centerX, size.y / 2);
    canvas.drawCircle(pulse, 15, Paint()..color = const Color(0xFF55FFE0).withOpacity(0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    canvas.drawCircle(pulse, 6, Paint()..color = const Color(0xFFE8FFFA));
  }
}
