import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class StudentGreeting extends StatelessWidget {
  final String name;

  const StudentGreeting({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, $name! 👋',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: StudentUiColors.darkText,
            height: 1.05,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Tu futuro comienza hoy.',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}