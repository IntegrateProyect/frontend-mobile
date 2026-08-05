import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class NucleusParticles extends PositionComponent {
  int protons;
  int neutrons;
  NucleusParticles({required Vector2 position, required Vector2 size, required this.protons, required this.neutrons})
      : super(position: position, size: size, anchor: Anchor.center, priority: 160);

  @override
  void render(Canvas canvas) {
    final particles = <Color>[
      ...List<Color>.filled(protons, const Color(0xFFFF514E)),
      ...List<Color>.filled(neutrons, const Color(0xFFF2F4F8)),
    ];
    const offsets = <Offset>[
      Offset(-16, -12), Offset(16, 12), Offset(15, -13), Offset(-15, 14),
    ];
    final center = Offset(size.x / 2, size.y / 2);
    for (var i = 0; i < particles.length && i < offsets.length; i++) {
      final p = center + offsets[i];
      canvas.drawCircle(p, 15, Paint()..color = particles[i]);
      canvas.drawCircle(p - const Offset(4, 5), 4, Paint()..color = Colors.white.withOpacity(0.75));
    }
  }
}

class OrbitElectrons extends PositionComponent {
  int count;
  OrbitElectrons({required Vector2 size, required this.count}) : super(size: size, priority: 165);

  @override
  void render(Canvas canvas) {
    final slots = <Offset>[
      Offset(size.x * 0.728, size.y * 0.398),
      Offset(size.x * 0.262, size.y * 0.585),
      Offset(size.x * 0.740, size.y * 0.585),
    ];
    for (var i = 0; i < count && i < slots.length; i++) {
      canvas.drawCircle(slots[i], 12, Paint()..color = const Color(0xFF119DFF));
      canvas.drawCircle(slots[i] - const Offset(3, 4), 3.5, Paint()..color = Colors.white.withOpacity(0.82));
    }
  }
}

class AtomButton extends PositionComponent with TapCallbacks {
  final Color color;
  final VoidCallback onPressed;
  AtomButton({required Vector2 position, required Vector2 size, required this.color, required this.onPressed})
      : super(position: position, size: size, anchor: Anchor.center, priority: 190);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class TouchRipple extends PositionComponent {
  final Color color;
  double _age = 0;
  TouchRipple({required Vector2 position, required this.color})
      : super(position: position, size: Vector2.all(1), anchor: Anchor.center, priority: 250);

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= 0.45) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_age / 0.45).clamp(0.0, 1.0);
    canvas.drawCircle(Offset.zero, 22 + 34 * t, Paint()..color = color.withOpacity((1 - t) * 0.55)..style = PaintingStyle.stroke..strokeWidth = 4 * (1 - t));
  }
}

class AtomMessage extends PositionComponent {
  final String text;
  final Color color;
  AtomMessage({required this.text, required this.color, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 330);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(text: text, position: size / 2, size: Vector2(size.x - 22, size.y - 8), anchor: Anchor.center, align: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800, height: 1.15))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF0B1233));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class SmallAtomButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  SmallAtomButton({required this.text, required this.color, required Vector2 position, required double width, required this.onPressed})
      : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF0B1233));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.70)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
