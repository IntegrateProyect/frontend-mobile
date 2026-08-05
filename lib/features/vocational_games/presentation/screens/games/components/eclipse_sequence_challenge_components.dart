import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../game_fx.dart';

class DraggableEclipseCard extends SpriteComponent with DragCallbacks {
  final String assetName;
  final int cardIndex;
  final double placedScale;
  final double dropDistance;
  final Vector2 Function() targetPositionProvider;
  final VoidCallback onTouched;
  final VoidCallback onAttempt;
  final void Function(DraggableEclipseCard card) onDropped;

  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _isPlaced = false;
  bool _locked = false;
  bool _wasCounted = false;

  DraggableEclipseCard({
    required this.assetName,
    required this.cardIndex,
    required this.placedScale,
    required this.dropDistance,
    required Vector2 position,
    required Vector2 size,
    required this.targetPositionProvider,
    required this.onTouched,
    required this.onAttempt,
    required this.onDropped,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 20) {
    originalPosition = position.clone();
  }

  bool get isPlaced => _isPlaced;
  bool get wasCounted => _wasCounted;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(assetName);
  }

  void markAsCounted() => _wasCounted = true;

  void lock() {
    _locked = true;
    _isDragging = false;
    if (!_isPlaced) scale = Vector2.all(1);
  }

  void showHint() {
    if (_locked || _isPlaced || _isDragging) return;
    add(ScaleEffect.to(
      Vector2.all(1.08),
      EffectController(duration: 0.22, reverseDuration: 0.22, alternate: true, repeatCount: 3),
      onComplete: () { if (!_isPlaced && !_isDragging) scale = Vector2.all(1); },
    ));
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_locked || _isPlaced) return;
    _isDragging = true;
    priority = 100;
    scale = Vector2.all(1);
    onTouched();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || _locked || _isPlaced) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_isDragging || _locked || _isPlaced) return;
    _isDragging = false;
    onAttempt();
    final target = targetPositionProvider();
    if (position.distanceTo(target) <= dropDistance) {
      _isPlaced = true;
      position.setFrom(target);
      scale = Vector2.all(placedScale);
      priority = 30;
      onDropped(this);
    } else {
      position.setFrom(originalPosition);
      scale = Vector2.all(1);
      priority = 20;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;
    position.setFrom(originalPosition);
    scale = Vector2.all(1);
    priority = 20;
  }
}

class EclipseHintBanner extends PositionComponent {
  final String text;
  final Color color;
  final double duration;

  EclipseHintBanner({
    required this.text,
    required Vector2 position,
    required Vector2 size,
    this.color = const Color(0xFFB388FF),
    this.duration = 4,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 28, size.y - 12),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFF1E9FF), fontSize: 13.5, fontWeight: FontWeight.w800, height: 1.2)),
    ));
    add(TimerComponent(period: duration, onTick: removeFromParent));
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(18));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF16163B).withOpacity(0.96));
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.85)..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }
}

class EclipseButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  EclipseButton({required this.text, required this.color, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(108, 36), anchor: Anchor.center, priority: 250);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color.withOpacity(0.98), fontSize: 12.5, fontWeight: FontWeight.w800)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(size.toRect(), Radius.circular(size.y / 2));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF101731).withOpacity(0.90));
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.65)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}
