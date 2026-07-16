import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentGreeting extends StatelessWidget {
  final String name;
  final String? groupName;
  final String? counselorName;

  const StudentGreeting({
    super.key,
    required this.name,
    this.groupName,
    this.counselorName,
  });

  @override
  Widget build(BuildContext context) {
    final String studentName = _cleanValue(
      name,
      fallback: 'Estudiante',
    );

    final String studentGroup = _cleanValue(
      groupName,
      fallback: 'Sin grupo asignado',
    );

    final String counselor = _cleanValue(
      counselorName,
      fallback: 'Por asignar',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, $studentName! 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1D1B4B),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 5.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 12.5.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            children: [
              const TextSpan(
                text: 'Grupo: ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(text: studentGroup),
              const TextSpan(text: '  •  '),
              const TextSpan(
                text: 'Orientador: ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(text: counselor),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _cleanValue(
      String? value, {
        required String fallback,
      }) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty ||
        text.toLowerCase() == 'null' ||
        text.toLowerCase() == 'undefined') {
      return fallback;
    }

    return text;
  }
}