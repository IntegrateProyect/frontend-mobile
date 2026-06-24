import 'package:flutter/material.dart';
import '../../domain/entities/career_entity.dart';

class CareerCard extends StatelessWidget {
  final CareerEntity career;
  final VoidCallback onTap;

  const CareerCard({
    super.key, required this.career,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(career.name),
        subtitle: Text(career.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
