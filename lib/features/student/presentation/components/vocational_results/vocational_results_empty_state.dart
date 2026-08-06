import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/student_ui_colors.dart';

class VocationalResultsEmptyState extends StatelessWidget {
  const VocationalResultsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
      ),
      child: Column(
        children: [
          Icon(
            Icons.radar_rounded,
            size: 52.sp,
            color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Aún no hay resultados vocacionales',
            style: TextStyle(
              color: isDark ? Colors.white : StudentUiColors.darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Completa tus actividades para generar tu perfil vocacional.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey[600],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
