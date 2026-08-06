import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/student_ui_colors.dart';

class IncompleteGamesState extends StatelessWidget {
  final VoidCallback onContinue;

  const IncompleteGamesState({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          Icon(
            Icons.sports_esports_outlined,
            size: 80.sp,
            color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary.withOpacity(0.8),
          ),
          SizedBox(height: 20.h),
          Text(
            '¡Continúa tu aventura vocacional!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : StudentUiColors.darkText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Completa todos los minijuegos para obtener tus '
                'resultados y carreras recomendadas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey[600],
              fontSize: 13.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF6D28D9) : StudentUiColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              onPressed: onContinue,
              child: Text(
                'Ir a los minijuegos',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
