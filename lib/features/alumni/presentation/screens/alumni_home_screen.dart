import 'package:flutter/material.dart';
import '../components/success_story_card.dart';
import '../../domain/entities/success_story_entity.dart';

class AlumniHomeScreen extends StatelessWidget {
  const AlumniHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Egresado'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tus Historias de Éxito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStoryList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Compartir Historia'),
        icon: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildStoryList() {
    return Column(
      children: List.generate(2, (index) {
        return SuccessStoryCard(
          story: SuccessStoryEntity(
            id: '$index',
            alumniName: 'Juan Pérez',
            title: 'Mi camino a la Ingeniería',
            story: 'Desde pequeño me gustaba desarmar cosas. Orientate me ayudó a elegir la mejor universidad...',
            createdAt: DateTime.now(),
          ),
        );
      }),
    );
  }
}
