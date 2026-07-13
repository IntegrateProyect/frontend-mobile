import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../domain/entities/vocational_mini_game_entity.dart';
import 'mini_game_status_button.dart';
import 'mini_game_visual.dart';

class VocationalMiniGameCard extends StatelessWidget {
  final VocationalMiniGameEntity miniGame;
  final MiniGameStatus status;
  final double progress;
  final int animationIndex;
  final VoidCallback onTap;

  const VocationalMiniGameCard({
    super.key,
    required this.miniGame,
    required this.status,
    required this.progress,
    required this.animationIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visual = MiniGameVisual.fromCategory(miniGame.category);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 315,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: visual.mainColor.withOpacity(0.38),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  visual.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return _fallbackBackground(visual);
                  },
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.42),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 1,
                      colors: [
                        visual.mainColor.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              _buildIcon(visual),
              _buildInformation(visual),
              _buildProgress(visual),
              _buildActions(visual),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (animationIndex * 90).ms)
          .slideY(
        begin: 0.18,
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _buildIcon(MiniGameVisual visual) {
    return Positioned(
      left: 20,
      top: 24,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: visual.mainColor.withOpacity(0.88),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Colors.white.withOpacity(0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: visual.neonColor.withOpacity(0.45),
              blurRadius: 18,
            ),
          ],
        ),
        child: Icon(
          visual.icon,
          color: Colors.white,
          size: 46,
        ),
      ),
    );
  }

  Widget _buildInformation(MiniGameVisual visual) {
    return Positioned(
      left: 122,
      right: 18,
      top: 24,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shadowText(
              visual.label,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
            const SizedBox(height: 6),
            _shadowText(
              miniGame.title,
              fontSize: 23,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            _shadowText(
              miniGame.description,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              color: Colors.white.withOpacity(0.94),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(MiniGameVisual visual) {
    final validProgress = progress.clamp(0.0, 1.0).toDouble();
    final percentage = (validProgress * 100).round();

    return Positioned(
      left: 24,
      bottom: 96,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 37,
              lineWidth: 8,
              percent: validProgress,
              progressColor: visual.neonColor,
              backgroundColor: Colors.white.withOpacity(0.28),
              center: Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            _shadowText(
              '${miniGame.questions.length} retos\ndisponibles',
              fontSize: 18,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(MiniGameVisual visual) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 22,
      child: Row(
        children: [
          Expanded(
            child: MiniGameStatusButton(
              status: status,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: visual.neonColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: visual.neonColor.withOpacity(0.75),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  _actionText(),
                  style: TextStyle(
                    color: visual.buttonTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  Icons.play_arrow_rounded,
                  color: visual.buttonTextColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _actionText() {
    switch (status) {
      case MiniGameStatus.completed:
        return 'Repetir';
      case MiniGameStatus.inProgress:
        return 'Continuar';
      case MiniGameStatus.notStarted:
        return 'Jugar';
    }
  }

  Widget _fallbackBackground(MiniGameVisual visual) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: visual.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _shadowText(
      String text, {
        required double fontSize,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w900,
        double letterSpacing = 0,
        int maxLines = 1,
      }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: 1.12,
        shadows: const [
          Shadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}