import 'package:flutter/material.dart';
import '../../domain/entities/university_career_entity.dart';

class UniversityCareerCard extends StatelessWidget {
  final UniversityCareerEntity career;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UniversityCareerCard({
    super.key,
    required this.career,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(career.name),
        subtitle: Text('Duración: ${career.duration} • Costo: \$${career.cost.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
