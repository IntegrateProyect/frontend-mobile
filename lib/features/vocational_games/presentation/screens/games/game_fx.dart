import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BurstParticles extends PositionComponent {
  final Color color;
  final int count;
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  double _age = 0;
  static const double _lifespan = 0.85;

  BurstParticles({
    required Vector2 position,
    required this.color,
    this.count = 20,
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 70 + _rng.nextDouble() * 110;
      _particles.add(
        _Particle(
          velocity: Vector2(cos(angle), sin(angle)) * speed,
          radius: 2 + _rng.nextDouble() * 4.5,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    for (final particle in _particles) {
      particle.position += particle.velocity * dt;
      particle.velocity *= 0.93;
    }
    if (_age >= _lifespan) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_age / _lifespan).clamp(0.0, 1.0);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    final paint = Paint()..color = color.withOpacity(opacity);
    for (final particle in _particles) {
      canvas.drawCircle(
        particle.position.toOffset(),
        particle.radius * (1 - progress * 0.35),
        paint,
      );
    }
  }
}

class _Particle {
  Vector2 position = Vector2.zero();
  Vector2 velocity;
  double radius;

  _Particle({
    required this.velocity,
    required this.radius,
  });
}

class PulsingTargetRing extends PositionComponent {
  final Color color;
  final double baseRadius;
  double _time = 0;

  PulsingTargetRing({
    required Vector2 position,
    required this.color,
    required this.baseRadius,
  }) : super(position: position, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final pulse = (sin(_time * 2.6) + 1) / 2;
    final paint = Paint()
      ..color = color.withOpacity(0.16 + pulse * 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 + pulse * 2.2;
    canvas.drawCircle(
      Offset.zero,
      baseRadius + pulse * 16,
      paint,
    );
  }
}

class AmbientFloaters extends PositionComponent
    with HasGameReference<FlameGame> {
  final Color color;
  final int count;
  final List<_Floater> _floaters = [];
  final Random _rng = Random();
  double _time = 0;

  AmbientFloaters({
    required this.color,
    this.count = 12,
  });

  @override
  int get priority => -10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final gameSize = game.size;
    for (int i = 0; i < count; i++) {
      _floaters.add(
        _Floater(
          position: Vector2(
            _rng.nextDouble() * gameSize.x,
            _rng.nextDouble() * gameSize.y,
          ),
          speed: 6 + _rng.nextDouble() * 12,
          radius: 2 + _rng.nextDouble() * 3.2,
          phase: _rng.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    final gameSize = game.size;
    for (final floater in _floaters) {
      floater.position.y -= floater.speed * dt;
      if (floater.position.y < -10) {
        floater.position.y = gameSize.y + 10;
        floater.position.x = _rng.nextDouble() * gameSize.x;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color.withOpacity(0.30);
    for (final floater in _floaters) {
      final wobble = sin(_time * 1.3 + floater.phase) * 9;
      canvas.drawCircle(
        Offset(floater.position.x + wobble, floater.position.y),
        floater.radius,
        paint,
      );
    }
  }
}

class _Floater {
  Vector2 position;
  double speed;
  double radius;
  double phase;

  _Floater({
    required this.position,
    required this.speed,
    required this.radius,
    required this.phase,
  });
}

mixin IdleBreathing on PositionComponent {
  double idleTime = 0;

  bool get isIdleAnimated;

  void updateBreathing(double dt) {
    if (!isIdleAnimated) return;
    idleTime += dt;
    scale = Vector2.all(1 + sin(idleTime * 2.4) * 0.035);
  }

  void playSuccessBounce() {
    add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.28),
            EffectController(
              duration: 0.12,
              curve: Curves.easeOut,
            ),
          ),
          ScaleEffect.to(
            Vector2.all(1),
            EffectController(
              duration: 0.22,
              curve: Curves.elasticOut,
            ),
          ),
        ],
      ),
    );
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;
  final Color color;

  const StreakBadge({
    super.key,
    required this.streak,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (streak < 2) return const SizedBox.shrink();
    return TweenAnimationBuilder<double>(
      key: ValueKey(streak),
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              'Racha x$streak',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingPraise extends PositionComponent {
  final String text;
  final Color color;
  double _age = 0;
  static const double _lifespan = 1;

  FloatingPraise({
    required Vector2 position,
    required this.text,
    required this.color,
  }) : super(position: position, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    position.y -= dt * 26;
    if (_age >= _lifespan) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_age / _lifespan).clamp(0.0, 1.0);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withOpacity(opacity),
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(-painter.width / 2, -painter.height / 2),
    );
  }
}

const List<String> praisePhrases = [
  '¡Bien!',
  '¡Genial!',
  '¡Vas muy bien!',
  '¡Excelente!',
  '¡Sigue así!',
];

String randomPraise(Random rng) {
  return praisePhrases[rng.nextInt(praisePhrases.length)];
}
