import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../game_fx.dart';

class DraggableMedicalCard extends SpriteComponent with DragCallbacks, IdleBreathing {
  final String assetName;
  final int cardIndex;
  final double placedScale;
  final double dropDistance;
  final Vector2 Function() targetPositionProvider;
  final bool Function() canPlaceProvider;
  final VoidCallback onTouched;
  final VoidCallback onWrongOrder;
  final void Function(DraggableMedicalCard card) onDropped;

  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _isPlaced = false;
  bool _locked = false;
  bool _wasCounted = false;

  DraggableMedicalCard({
    required this.assetName,
    required this.cardIndex,
    required this.placedScale,
    required this.dropDistance,
    required Vector2 position,
    required Vector2 size,
    required this.targetPositionProvider,
    required this.canPlaceProvider,
    required this.onTouched,
    required this.onWrongOrder,
    required this.onDropped,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 20) {
    originalPosition = position.clone();
  }

  bool get isPlaced => _isPlaced;
  bool get wasCounted => _wasCounted;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      sprite = await Sprite.load(assetName);
    } catch (e) {
      add(TextComponent(
        text: _fallbackEmoji(),
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(style: const TextStyle(fontSize: 48)),
      ));
    }
  }

  String _fallbackEmoji() {
    switch (cardIndex) {
      case 0: return '🧤';
      case 1: return '🧪';
      case 2: return '🔬';
      default: return '🧰';
    }
  }

  @override
  bool get isIdleAnimated => !_isDragging && !_isPlaced && !_locked;

  void markAsCounted() => _wasCounted = true;
  void lock() { _locked = true; _isDragging = false; if (!_isPlaced) scale = Vector2.all(1); }

  void showHint() {
    if (_locked || _isPlaced || _isDragging) return;
    add(ScaleEffect.to(
      Vector2.all(1.06),
      EffectController(duration: 0.22, reverseDuration: 0.22, alternate: true, repeatCount: 3),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_locked || _isPlaced) return;
    _isDragging = true;
    onTouched();
    priority = 100;
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

    final target = targetPositionProvider();
    if (position.distanceTo(target) <= dropDistance) {
      if (canPlaceProvider()) {
        _isPlaced = true;
        position.setFrom(target);
        scale = Vector2.all(placedScale);
        priority = 30;
        onDropped(this);
      } else {
        _returnToOriginalPosition();
        onWrongOrder();
      }
    } else {
      _returnToOriginalPosition();
    }
  }

  void _returnToOriginalPosition() {
    position.setFrom(originalPosition);
    scale = Vector2.all(1);
    priority = 20;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;
    _returnToOriginalPosition();
  }
}

class HintBanner extends PositionComponent {
  final String text;
  final Color color;
  final double duration;
  final VoidCallback? onDismiss;

  HintBanner({
    required this.text,
    this.color = const Color(0xFFFF4D6D),
    this.duration = 4,
    this.onDismiss,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 300);

  @override
  void onRemove() {
    onDismiss?.call();
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 28, size.y - 12),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFFFE1E8), fontSize: 13.5, fontWeight: FontWeight.w800, height: 1.2),
      ),
    ));
    add(TimerComponent(period: duration, onTick: removeFromParent));
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(18));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF102840).withOpacity(0.96));
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.82)..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }
}

class GhostButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  GhostButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
    double width = 100,
  }) : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 200);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(color: color.withOpacity(0.95), fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF0F2033).withOpacity(0.78));
    canvas.drawRRect(rect, Paint()..color = color.withOpacity(0.55)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}
