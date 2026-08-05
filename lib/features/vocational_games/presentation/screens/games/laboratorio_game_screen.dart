import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/game_entity.dart';
import 'laboratorio_flame_game.dart';

const Color _kLaboratoryBackground = Color(0xFF010E28);
const Color _kNeon = Color(0xFF29B6F6);

class LaboratorioGameScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const LaboratorioGameScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<LaboratorioGameScreen> createState() => _LaboratorioGameScreenState();
}

class _LaboratorioGameScreenState extends State<LaboratorioGameScreen> {
  late final LaboratorioFlameGame _game;

  @override
  void initState() {
    super.initState();
    _game = LaboratorioFlameGame(
      context: context,
      gameEntity: widget.game,
      miniGameKey: widget.miniGameKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kLaboratoryBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<LaboratorioFlameGame>(
              game: _game,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _ExitButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 16,
            child: ValueListenableBuilder<int>(
              valueListenable: _game.streakNotifier,
              builder: (context, streak, _) {
                return _NeonStreakBadge(
                  streak: streak,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonStreakBadge extends StatelessWidget {
  final int streak;
  const _NeonStreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2033).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kNeon.withOpacity(0.6), width: 1.4),
        boxShadow: [
          BoxShadow(color: _kNeon.withOpacity(0.25), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            'Racha x$streak',
            style: const TextStyle(
              color: Color(0xFFE8F6FF),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ExitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2033).withOpacity(0.85),
        shape: BoxShape.circle,
        border: Border.all(color: _kNeon.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: IconButton(
        tooltip: 'Salir',
        icon: const Icon(Icons.close, color: Color(0xFFE8F6FF)),
        onPressed: onTap,
      ),
    );
  }
}
