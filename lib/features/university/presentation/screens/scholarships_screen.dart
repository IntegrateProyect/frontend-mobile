import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../student/presentation/components/common/student_ui_colors.dart';

class ScholarshipsScreen extends StatelessWidget {
  const ScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudentUiColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Becas Disponibles',
          style: TextStyle(
            color: StudentUiColors.darkText,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stars_rounded,
              size: 80.sp,
              color: StudentUiColors.primary.withValues(alpha: 0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'Próximamente',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StudentUiColors.darkText,
              ),
            ),
            SizedBox(height: 8.h),
            const Text(
              'Estamos trabajando para traerte las mejores becas.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
