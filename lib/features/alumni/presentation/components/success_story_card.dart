import 'package:flutter/material.dart';
import '../../domain/entities/success_story_entity.dart';

class SuccessStoryCard extends StatelessWidget {
  final SuccessStoryEntity story;

  const SuccessStoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (story.imageUrl != null)
            Image.network(story.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Por ${story.alumniName}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Text(story.story, maxLines: 3, overflow: TextOverflow.ellipsis),
                TextButton(
                  onPressed: () {},
                  child: const Text('Leer más'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
