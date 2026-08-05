import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game_fx.dart';


class AmbientIcons extends PositionComponent {
  final Color color;
  final List<String> icons;
  final Random _rng = Random();
  late List<Offset> _points;
  late List<String> _glyphs;

  AmbientIcons({required this.color, required this.icons, required Vector2 size})
      : super(position: Vector2.zero(), size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    const count = 7;
    _points = List.generate(count, (_) => Offset(_rng.nextDouble() * size.x, _rng.nextDouble() * size.y));
    _glyphs = List.generate(count, (_) => icons[_rng.nextInt(icons.length)]);
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _points.length; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: _glyphs[i],
          style: TextStyle(fontSize: 22, color: color.withOpacity(0.07)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, _points[i]);
    }
  }
}

class ConnectorField extends PositionComponent {
  final List<StationNode> Function() stationsProvider;
  final Vector2 Function() targetProvider;
  final Color color;
  double _t = 0;

  ConnectorField({
    required this.stationsProvider,
    required this.targetProvider,
    required this.color,
    required Vector2 size,
  }) : super(position: Vector2.zero(), size: size);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
  }

  @override
  void render(Canvas canvas) {
    final target = targetProvider();

    for (final station in stationsProvider()) {
      if (station.isConsumed || station.isDragging) continue;

      final start = station.position;
      final control = Offset(
        (start.x + target.x) / 2,
        min(start.y, target.y) - 30,
      );

      final path = Path()
        ..moveTo(start.x, start.y)
        ..quadraticBezierTo(control.dx, control.dy, target.x, target.y);

      canvas.drawPath(
        path,
        Paint()
          ..color = color.withOpacity(0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );

      for (final metric in path.computeMetrics()) {
        final len = metric.length;
        final offset = len * ((_t * 0.32) % 1);
        final tangent = metric.getTangentForOffset(offset);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            3.4,
            Paint()..color = color.withOpacity(0.85),
          );
        }
      }
    }
  }
}

class HoloTarget extends PositionComponent {
  final String emoji;
  final String label;
  final Color color;
  final bool showRing;
  final bool showGlyphs;

  static const double _radius = 54;
  double _rotation = 0;

  HoloTarget({
    required this.emoji,
    required this.label,
    required this.color,
    required Vector2 position,
    this.showRing = true,
    this.showGlyphs = true,
  }) : super(position: position, size: Vector2.all(_radius * 2 + 44), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (!showGlyphs) return;

    add(TextComponent(
      text: emoji,
      position: Vector2(size.x / 2, size.y / 2 - 4),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 40)),
    ));

    add(TextComponent(
      text: label.toUpperCase(),
      position: Vector2(size.x / 2, size.y / 2 + _radius + 12),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rotation += dt * 0.6;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    final glowPaint = Paint()
      ..color = color.withOpacity(showRing ? 0.22 : 0.28)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, showRing ? 16 : 20);
    canvas.drawCircle(center, _radius + (showRing ? 8 : 16), glowPaint);

    if (!showRing) return;

    canvas.drawCircle(center, _radius, Paint()..color = const Color(0xFF0B1626));
    canvas.drawCircle(center, _radius, Paint()..color = color.withOpacity(0.10));

    canvas.drawCircle(
      center,
      _radius - 8,
      Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final dashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashCount = 22;
    const sweep = (2 * pi / dashCount) * 0.5;
    for (int i = 0; i < dashCount; i++) {
      final start = _rotation + i * (2 * pi / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: _radius),
        start,
        sweep,
        false,
        dashPaint,
      );
    }
  }

  void react() {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.18), EffectController(duration: 0.14, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.32, curve: Curves.elasticOut)),
    ]));
  }
}

class ProgressPips extends PositionComponent {
  final int total;
  final Color color;
  int _filled = 0;

  ProgressPips({required this.total, required this.color, required Vector2 position})
      : super(position: position, size: Vector2(total * 30.0, 22), anchor: Anchor.center);

  void setFilled(int filled) {
    _filled = filled.clamp(0, total);
  }

  @override
  void render(Canvas canvas) {
    if (total <= 0) return;
    const dotRadius = 9.0;
    final spacing = size.x / total;

    if (total > 1) {
      canvas.drawLine(
        Offset(spacing / 2, size.y / 2),
        Offset(size.x - spacing / 2, size.y / 2),
        Paint()
          ..color = color.withOpacity(0.25)
          ..strokeWidth = 2,
      );
    }

    for (var i = 0; i < total; i++) {
      final cx = spacing * i + spacing / 2;
      final center = Offset(cx, size.y / 2);
      final isFilled = i < _filled;

      if (isFilled) {
        canvas.drawCircle(
          center,
          dotRadius + 3,
          Paint()
            ..color = color.withOpacity(0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        canvas.drawCircle(center, dotRadius, Paint()..color = color);

        final numberPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        numberPainter.paint(
          canvas,
          center - Offset(numberPainter.width / 2, numberPainter.height / 2),
        );
      } else {
        canvas.drawCircle(center, dotRadius, Paint()..color = const Color(0xFF0F2033));
        canvas.drawCircle(
          center,
          dotRadius,
          Paint()
            ..color = color.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6,
        );
      }
    }
  }
}

class StationNode extends PositionComponent with DragCallbacks, IdleBreathing {
  final int stationNumber;
  final String label;
  final Color color;
  final void Function(StationNode piece) onDropped;
  final VoidCallback onTouched;
  final Vector2 Function() targetPositionProvider;

  final bool transparentSkin;

  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _consumed = false;

  static const double _radius = 38;
  static final Vector2 _cardSize = Vector2(150, 100);
  static final Vector2 _hitboxSize = Vector2(96, 96);

  late final String _emojiPart;
  late final String _textPart;

  StationNode({
    required this.stationNumber,
    required this.label,
    required this.color,
    required Vector2 position,
    required this.onDropped,
    required this.onTouched,
    required this.targetPositionProvider,
    this.transparentSkin = false,
  }) : super(
    position: position,
    size: (transparentSkin ? _hitboxSize : _cardSize).clone(),
    anchor: Anchor.center,
  ) {
    originalPosition = position.clone();

    final parts = label.split(' ');
    if (parts.length > 1 && _looksLikeEmoji(parts.first)) {
      _emojiPart = parts.first;
      _textPart = parts.sublist(1).join(' ');
    } else {
      _emojiPart = '';
      _textPart = label;
    }
  }

  static bool _looksLikeEmoji(String value) => value.runes.any((r) => r > 0x2100);

  Color get _accent => color;

  bool get isConsumed => _consumed;
  bool get isDragging => _isDragging;

  @override
  bool get isIdleAnimated => !_isDragging && !_consumed && !transparentSkin;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (transparentSkin) return;

    final circleCenterY = size.y / 2 - 16;

    if (_emojiPart.isNotEmpty) {
      add(TextComponent(
        text: _emojiPart,
        position: Vector2(size.x / 2, circleCenterY),
        anchor: Anchor.center,
        textRenderer: TextPaint(style: const TextStyle(fontSize: 24)),
      ));
    } else {
      add(TextComponent(
        text: _textPart,
        position: Vector2(size.x / 2, circleCenterY),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(color: _accent, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ));
    }

    if (_emojiPart.isNotEmpty) {
      add(TextComponent(
        text: _textPart,
        position: Vector2(size.x / 2, circleCenterY + _radius + 14),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
          style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 11.5, fontWeight: FontWeight.w700),
        ),
      ));
    }

    add(TextComponent(
      text: 'ESTACIÓN $stationNumber',
      position: Vector2(size.x / 2, circleCenterY + _radius + (_emojiPart.isNotEmpty ? 32 : 14)),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(color: _accent.withOpacity(0.75), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 1.1),
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    if (transparentSkin) {
      final center = Offset(size.x / 2, size.y / 2);
      canvas.drawCircle(
        center,
        size.x / 2,
        Paint()
          ..color = _accent.withOpacity(_consumed ? 0.0 : 0.14)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
      return;
    }

    final center = Offset(size.x / 2, size.y / 2 - 16);

    canvas.drawCircle(
      center,
      _radius + 10,
      Paint()
        ..color = _accent.withOpacity(_consumed ? 0.5 : 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    canvas.drawCircle(center, _radius, Paint()..color = const Color(0xFF0F2033));
    canvas.drawCircle(center, _radius, Paint()..color = _accent.withOpacity(0.10));

    canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = _accent.withOpacity(_consumed ? 1.0 : 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  void showHint(Vector2 targetPosition) {
    if (_consumed || _isDragging) return;

    final direction = targetPosition - position;
    if (direction.length > 0) {
      direction.normalize();
      final offset = direction * 32.0;

      add(SequenceEffect([
        MoveEffect.by(
          offset,
          EffectController(duration: 0.28, curve: Curves.easeOut),
        ),
        MoveEffect.by(
          -offset,
          EffectController(duration: 0.34, curve: Curves.easeInOut),
        ),
      ]));
    }

    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.16), EffectController(duration: 0.18, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.20, curve: Curves.easeIn)),
      ScaleEffect.to(Vector2.all(1.16), EffectController(duration: 0.18, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.20, curve: Curves.easeIn)),
    ]));
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_consumed) return;
    _isDragging = true;
    onTouched();
    scale = Vector2.all(1.12);
    priority = 5;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || _consumed) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging || _consumed) return;
    _isDragging = false;

    final target = targetPositionProvider();
    final distance = position.distanceTo(target);

    if (distance < 100) {
      _consumed = true;
      scale = Vector2.all(1);
      playSuccessBounce();
      position.setFrom(target);
      onDropped(this);
    } else {
      scale = Vector2.all(1);
      position.setFrom(originalPosition);
    }
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
  }) : super(position: position, size: Vector2(width, 36), anchor: Anchor.center);

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
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF0F2033).withOpacity(0.7));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}
