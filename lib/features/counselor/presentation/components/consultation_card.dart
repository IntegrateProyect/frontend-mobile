import 'package:flutter/material.dart';
import '../../domain/entities/student_consultation_entity.dart';
import 'package:intl/intl.dart';

class ConsultationCard extends StatelessWidget {
  final StudentConsultationEntity consultation;
  final VoidCallback onTap;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(consultation.studentName),
        subtitle: Text(
          consultation.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('dd/MM/yy').format(consultation.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: consultation.status == 'pending' ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                consultation.status == 'pending' ? 'Pendiente' : 'Respondido',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
