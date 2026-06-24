import 'package:flutter/material.dart';
import '../../domain/entities/scholarship_entity.dart';

class ScholarshipCard extends StatelessWidget {
  final ScholarshipEntity scholarship;
  final VoidCallback onTap;

  const ScholarshipCard({
    super.key,
    required this.scholarship,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(scholarship.title),
        subtitle: Text(scholarship.provider),
        trailing: scholarship.amount != null 
          ? Text('\$${scholarship.amount!.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
          : null,
        onTap: onTap,
      ),
    );
  }
}
