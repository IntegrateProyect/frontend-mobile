import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import 'consultorio_flame_game.dart';
import 'game_fx.dart';

class ConsultorioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const ConsultorioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<ConsultorioGameScreen> createState() =>
      _ConsultorioGameScreenState();
}

class _ConsultorioGameScreenState
    extends State<ConsultorioGameScreen> {
  late final ConsultorioFlameGame _game;

  @override
  void initState() {
    super.initState();

    _game = ConsultorioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<ConsultorioFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              color: const Color(0xFF0D47A1),
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
                  color: const Color(0xFF1565C0),
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
