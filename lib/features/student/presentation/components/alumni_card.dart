import 'package:flutter/material.dart';
import '../../domain/entities/alumni_entity.dart';

class AlumniCard extends StatelessWidget {
  final AlumniEntity alumni;
  final VoidCallback onTap;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: alumni.profileImageUrl != null 
            ? NetworkImage(alumni.profileImageUrl!) 
            : null,
          child: alumni.profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(alumni.name),
        subtitle: Text('${alumni.career} @ ${alumni.university}'),
        onTap: onTap,
      ),
    );
  }
}
