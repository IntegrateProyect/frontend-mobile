import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/vocational_mini_game_entity.dart';
import '../../presentation/providers/games_provider.dart';
import '../../presentation/providers/game_persistence_provider.dart';
import 'games_list_header.dart';
import 'vocational_mini_game_card.dart';

class GamesListBody extends StatelessWidget {
  final List<VocationalMiniGameEntity> miniGames;
  final Function(VocationalMiniGameEntity) onGameTap;

  const GamesListBody({
    super.key,
    required this.miniGames,
    required this.onGameTap,
  });

  @override
  Widget build(BuildContext context) {
    final persistence = context.watch<GamePersistenceProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(22),
      children: [
        const GamesListHeader(),
        ...miniGames.asMap().entries.map((entry) {
          final miniGame = entry.value;
          final status = persistence.getMiniGameStatus(miniGame.statusKey);
          final progress = persistence.getMiniGameProgress(
            miniGame.statusKey,
            miniGame.questions.length,
          );

          return VocationalMiniGameCard(
            miniGame: miniGame,
            status: status,
            progress: progress,
            animationIndex: entry.key,
            onTap: () => onGameTap(miniGame),
          );
        }),
      ],
    );
  }
}
