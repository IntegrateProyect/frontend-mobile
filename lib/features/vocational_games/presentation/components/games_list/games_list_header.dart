import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GamesListHeader extends StatelessWidget {
  const GamesListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elige tu aventura\nvocacional',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1D1B4B),
            height: 1.1,
          ),
        ).animate().fadeIn().slideX(begin: -0.15),
        const SizedBox(height: 12),
        Text(
          'Cada área se juega diferente según el tipo de interés.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.grey.shade400 : Colors.grey[600],
            height: 1.35,
          ),
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: 24),
      ],
    );
  }
}