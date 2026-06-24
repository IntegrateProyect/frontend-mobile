import 'package:flutter/material.dart';
import '../components/consultation_card.dart';
import '../../domain/entities/student_consultation_entity.dart';

class CounselorHomeScreen extends StatelessWidget {
  const CounselorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Orientador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/counselor-profile'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Placeholder
        itemBuilder: (context, index) {
          final mockConsultation = StudentConsultationEntity(
            id: '$index',
            studentId: 's$index',
            studentName: 'Estudiante ${index + 1}',
            message: 'Hola, tengo una duda sobre la carrera de ingeniería...',
            createdAt: DateTime.now().subtract(Duration(days: index)),
            status: index == 0 ? 'pending' : 'responded',
          );
          return ConsultationCard(
            consultation: mockConsultation,
            onTap: () {},
          );
        },
      ),
    );
  }
}
