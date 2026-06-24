import 'package:flutter/material.dart';
import '../components/game_card.dart';
import '../../domain/entities/game_entity.dart';

class GamesListScreen extends StatelessWidget {
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juegos Vocacionales')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4, // Placeholder
        itemBuilder: (context, index) {
          final mockGame = GameEntity(
            id: '$index',
            title: 'Juego ${index + 1}',
            description: 'Explora tus habilidades a través de este desafío.',
            imageUrl: '',
            type: 'simulation',
          );
          return GameCard(
            game: mockGame,
            onTap: () => Navigator.pushNamed(context, '/game-detail'),
          );
        },
      ),
    );
  }
}
