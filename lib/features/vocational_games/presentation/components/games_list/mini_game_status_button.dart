import 'package:flutter/material.dart';

import '../../../domain/entities/vocational_mini_game_entity.dart';

class MiniGameStatusButton extends StatelessWidget {
  final MiniGameStatus status;

  const MiniGameStatusButton({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final data = _statusData(status);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.65),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            data.icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            data.text,
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
        ],
      ),
    );
  }

  _StatusData _statusData(MiniGameStatus status) {
    switch (status) {
      case MiniGameStatus.completed:
        return const _StatusData(
          text: 'Completado',
          icon: Icons.check_circle,
        );
      case MiniGameStatus.inProgress:
        return const _StatusData(
          text: 'En progreso',
          icon: Icons.timelapse,
        );
      case MiniGameStatus.notStarted:
        return const _StatusData(
          text: 'Sin iniciar',
          icon: Icons.radio_button_unchecked,
        );
    }
  }
}

class _StatusData {
  final String text;
  final IconData icon;

  const _StatusData({
    required this.text,
    required this.icon,
  });
}