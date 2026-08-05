import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';


class FlaskTargetGlow extends PositionComponent {
  bool _hovering = false;
  double _hintTime = 0;
  double _errorTime = 0;
  double _successTime = 0;
  double _time = 0;

  FlaskTargetGlow({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 2);

  void setHovering(bool value) => _hovering = value;
  void showHint() => _hintTime = 1.2;
  void showError() => _errorTime = 0.55;
  void showSuccess() => _successTime = 1.2;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_hintTime > 0) _hintTime -= dt;
    if (_errorTime > 0) _errorTime -= dt;
    if (_successTime > 0) _successTime -= dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final pulse = 0.5 + 0.5 * sin(_time * 5).abs();
    Color color = const Color(0xFF22DCEB);
    double opacity = 0.16;

    if (_hovering) opacity = 0.52;
    if (_hintTime > 0) opacity = 0.30 + pulse * 0.28;
    if (_errorTime > 0) { color = const Color(0xFFFF4D67); opacity = 0.52; }
    if (_successTime > 0) { color = const Color(0xFF35D69A); opacity = 0.62; }

    canvas.drawCircle(center, min(size.x, size.y) / 2, Paint()..color = color.withOpacity(opacity)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));
  }
}

class DraggableNumberCard extends PositionComponent with DragCallbacks {
  final String label;
  final void Function(DraggableNumberCard card) onDropped;
  final VoidCallback onTouched;
  final ValueChanged<bool> onHoverChanged;
  final Vector2 Function() targetPositionProvider;
  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _disabled = false;
  double _shakeTime = 0;
  double _hintTime = 0;

  DraggableNumberCard({
    required this.label,
    required Vector2 position,
    required this.targetPositionProvider,
    required this.onTouched,
    required this.onHoverChanged,
    required this.onDropped,
  }) : super(position: position, size: Vector2(88, 92), anchor: Anchor.center, priority: 5) {
    originalPosition = position.clone();
  }

  Color get cardColor {
    switch (label) {
      case '12': return const Color(0xFF35B99A);
      case '16': return const Color(0xFFF26332);
      case '24': return const Color(0xFF0798A6);
      default: return const Color(0xFFF26332);
    }
  }

  void disable() { _disabled = true; _isDragging = false; scale = Vector2.all(1); onHoverChanged(false); }

  void showWrongAndReturn() {
    _isDragging = false;
    position.setFrom(originalPosition);
    scale = Vector2.all(1);
    _shakeTime = 0.48;
    onHoverChanged(false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_shakeTime > 0) {
      _shakeTime -= dt;
      position.x = originalPosition.x + sin(_shakeTime * 55) * 7;
      if (_shakeTime <= 0) position.setFrom(originalPosition);
    }
  }

  @override
  void render(Canvas canvas) {
    final cardRect = RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, size.x - 4, size.y - 4), const Radius.circular(19));
    canvas.drawRRect(cardRect, Paint()..color = cardColor);
    TextPainter(
      text: TextSpan(text: label, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)),
      textDirection: TextDirection.ltr,
    )..layout()..paint(canvas, Offset((size.x - 27) / 2, 27));
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_disabled) return;
    _isDragging = true;
    onTouched();
    scale = Vector2.all(1.10);
    priority = 20;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || _disabled) return;
    position.add(event.localDelta);
    onHoverChanged(position.distanceTo(targetPositionProvider()) <= 88);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_isDragging || _disabled) return;
    _isDragging = false;
    if (position.distanceTo(targetPositionProvider()) <= 88) {
      onDropped(this);
    } else {
      returnToOriginalPosition();
    }
  }

  void returnToOriginalPosition() { scale = Vector2.all(1); position.setFrom(originalPosition); priority = 5; onHoverChanged(false); }
}

class FeedbackBanner extends PositionComponent {
  String _message = '';
  Color _color = const Color(0xFF29B6F6);
  double _visibleTime = 0;

  FeedbackBanner({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter, priority: 12);

  void showMessage(String message, Color color) { _message = message; _color = color; _visibleTime = 5; }

  @override
  void update(double dt) {
    super.update(dt);
    if (_visibleTime > 0) _visibleTime -= dt;
  }

  @override
  void render(Canvas canvas) {
    if (_message.isEmpty || _visibleTime <= 0) return;
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(14));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF07192B).withOpacity(0.91));
    TextPainter(
      text: TextSpan(text: _message, style: TextStyle(color: _color, fontSize: 11.5, fontWeight: FontWeight.w700)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 22)..paint(canvas, Offset((size.x - 100) / 2, (size.y - 20) / 2));
  }
}
