import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import 'estudio_flame_game.dart';
import 'game_fx.dart';

class EstudioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const EstudioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<EstudioGameScreen> createState() =>
      _EstudioGameScreenState();
}

class _EstudioGameScreenState
    extends State<EstudioGameScreen> {
  late final EstudioFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = EstudioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<EstudioFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF1E1B4B),
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
                  color: const Color(0xFF7C3AED),
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
            color: Colors.black.withOpacity(0.12),
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
