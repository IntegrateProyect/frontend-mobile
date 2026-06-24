import 'package:flutter/material.dart';
import '../../domain/entities/university_entity.dart';

class UniversityCard extends StatelessWidget {
  final UniversityEntity university;
  final VoidCallback onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: university.logoUrl != null 
          ? Image.network(university.logoUrl!, width: 40, height: 40)
          : const Icon(Icons.account_balance, size: 40),
        title: Text(university.name),
        subtitle: Text(university.location),
        onTap: onTap,
      ),
    );
  }
}
