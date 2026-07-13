import 'dart:math';

import 'package:flutter/material.dart';

enum GameSceneType {
  music,
  mechanic,
  art,
  space,
  bio,
  math,
  literary,
  social,
  persuasive,
  general,
}

class GameSceneResolver {
  const GameSceneResolver._();

  static GameSceneType fromText(String raw) {
    final text = raw.toLowerCase();

    if (_contains(text, [
      'música',
      'musica',
      'concierto',
      'instrumento',
    ])) {
      return GameSceneType.music;
    }

    if (_contains(text, [
      'licuadora',
      'máquina',
      'maquina',
      'taladro',
      'reparar',
    ])) {
      return GameSceneType.mechanic;
    }

    if (_contains(text, [
      'pintar',
      'arte',
      'dibujar',
      'mosaicos',
    ])) {
      return GameSceneType.art;
    }

    if (_contains(text, [
      'eclipse',
      'telescopio',
      'estrellas',
      'observatorio',
    ])) {
      return GameSceneType.space;
    }

    if (_contains(text, [
      'sangre',
      'plantas',
      'abejas',
      'insectos',
    ])) {
      return GameSceneType.bio;
    }

    if (_contains(text, [
      'calcular',
      'numérico',
      'numerico',
      'porcentajes',
      'matemáticos',
      'matematicos',
    ])) {
      return GameSceneType.math;
    }

    if (_contains(text, [
      'escribir',
      'cuentos',
      'novelas',
      'literatura',
    ])) {
      return GameSceneType.literary;
    }

    if (_contains(text, [
      'ayudar',
      'orfelinatos',
      'consejero',
      'escuchar',
    ])) {
      return GameSceneType.social;
    }

    if (_contains(text, [
      'debates',
      'convencer',
      'defender',
      'líder',
      'lider',
    ])) {
      return GameSceneType.persuasive;
    }

    return GameSceneType.general;
  }

  static bool _contains(
      String text,
      List<String> words,
      ) {
    return words.any(text.contains);
  }
}

extension GameSceneVisual on GameSceneType {
  String get emoji {
    switch (this) {
      case GameSceneType.music:
        return '🎵';
      case GameSceneType.mechanic:
        return '⚙️';
      case GameSceneType.art:
        return '🎨';
      case GameSceneType.space:
        return '🪐';
      case GameSceneType.bio:
        return '🧬';
      case GameSceneType.math:
        return '🧮';
      case GameSceneType.literary:
        return '📖';
      case GameSceneType.social:
        return '🤝';
      case GameSceneType.persuasive:
        return '📢';
      case GameSceneType.general:
        return '🎯';
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case GameSceneType.music:
        return const LinearGradient(
          colors: [
            Color(0xFFFFF7E8),
            Color(0xFFFFD36E),
          ],
        );

      case GameSceneType.mechanic:
        return const LinearGradient(
          colors: [
            Color(0xFFFFF1E9),
            Color(0xFFE7F0FF),
          ],
        );

      case GameSceneType.art:
        return const LinearGradient(
          colors: [
            Color(0xFFE6F7FF),
            Color(0xFFFFF4D8),
          ],
        );

      case GameSceneType.space:
        return const LinearGradient(
          colors: [
            Color(0xFFEAE8FF),
            Color(0xFF1D1B4B),
          ],
        );

      case GameSceneType.bio:
        return const LinearGradient(
          colors: [
            Color(0xFFE8FFF2),
            Color(0xFFC7F2D4),
          ],
        );

      case GameSceneType.math:
        return const LinearGradient(
          colors: [
            Color(0xFFEDEAFF),
            Color(0xFFD9F0FF),
          ],
        );

      case GameSceneType.literary:
        return const LinearGradient(
          colors: [
            Color(0xFFFFF4E8),
            Color(0xFFE8D2B8),
          ],
        );

      case GameSceneType.social:
        return const LinearGradient(
          colors: [
            Color(0xFFFFEAF2),
            Color(0xFFFFD4E5),
          ],
        );

      case GameSceneType.persuasive:
        return const LinearGradient(
          colors: [
            Color(0xFFFFF3E0),
            Color(0xFFFFB74D),
          ],
        );

      case GameSceneType.general:
        return const LinearGradient(
          colors: [
            Color(0xFFEDEAFF),
            Color(0xFFF8F9FE),
          ],
        );
    }
  }
}

class InteractiveGameScene extends StatelessWidget {
  final GameSceneType scene;
  final Animation<double> animation;

  const InteractiveGameScene({
    super.key,
    required this.scene,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: scene.gradient,
          ),
          child: CustomPaint(
            painter: _InteractiveScenePainter(
              scene: scene,
              progress: animation.value,
            ),
          ),
        );
      },
    );
  }
}

class SuccessGameScene extends StatelessWidget {
  final GameSceneType scene;
  final Animation<double> animation;

  const SuccessGameScene({
    super.key,
    required this.scene,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: scene.gradient,
          ),
          child: CustomPaint(
            painter: _SuccessScenePainter(
              progress: animation.value,
            ),
          ),
        );
      },
    );
  }
}

class _InteractiveScenePainter extends CustomPainter {
  final GameSceneType scene;
  final double progress;

  const _InteractiveScenePainter({
    required this.scene,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final movement = sin(progress * pi * 2);

    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.32);

    canvas.drawCircle(
      Offset(
        size.width * 0.22,
        size.height * 0.18,
      ),
      60,
      backgroundPaint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.82,
        size.height * 0.25,
      ),
      42,
      backgroundPaint,
    );

    _drawEmoji(
      canvas: canvas,
      emoji: scene.emoji,
      position: center + Offset(0, movement * 10),
      fontSize: 110,
    );
  }

  void _drawEmoji({
    required Canvas canvas,
    required String emoji,
    required Offset position,
    required double fontSize,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        position.dx - painter.width / 2,
        position.dy - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(
      covariant _InteractiveScenePainter oldDelegate,
      ) {
    return oldDelegate.progress != progress ||
        oldDelegate.scene != scene;
  }
}

class _SuccessScenePainter extends CustomPainter {
  final double progress;

  const _SuccessScenePainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      40 + (progress * 80),
      circlePaint,
    );

    final painter = TextPainter(
      text: const TextSpan(
        text: '✅',
        style: TextStyle(fontSize: 110),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(
      covariant _SuccessScenePainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}