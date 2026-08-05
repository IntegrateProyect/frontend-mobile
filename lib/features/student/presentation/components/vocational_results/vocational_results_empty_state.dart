import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/student_ui_colors.dart';

class VocationalResultsEmptyState extends StatelessWidget {
  const VocationalResultsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.radar_rounded,
            size: 52.sp,
            color: StudentUiColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Aún no hay resultados vocacionales',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Completa tus actividades para generar tu perfil vocacional.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
