import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import 'taller_flame_game.dart';
import 'game_fx.dart';

class TallerGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const TallerGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<TallerGameScreen> createState() => _TallerGameScreenState();
}

class _TallerGameScreenState extends State<TallerGameScreen> {
  late final TallerFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = TallerFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<TallerFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF3E2723),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 16,
            child: ValueListenableBuilder<int>(
              valueListenable: _game.streakNotifier,
              builder: (context, streak, _) {
                return StreakBadge(
                  streak: streak,
                  color: const Color(0xFF6D4C41),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _ExitButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        tooltip: 'Salir',
        icon: Icon(Icons.close, color: color),
        onPressed: onTap,
      ),
    );
  }
}
