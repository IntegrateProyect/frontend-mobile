import 'package:flutter/material.dart';

class StudentProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String nextStep;

  const StudentProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('Siguiente paso: $nextStep', style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
