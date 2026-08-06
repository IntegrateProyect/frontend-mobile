import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class QuickAccessGrid extends StatelessWidget {
  final VoidCallback onMessagesTap;
  final VoidCallback onCareersTap;
  final VoidCallback onUniversitiesTap;
  final VoidCallback onEventsTap;

  const QuickAccessGrid({
    super.key,
    required this.onMessagesTap,
    required this.onCareersTap,
    required this.onUniversitiesTap,
    required this.onEventsTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accesos rápidos',
          style: TextStyle(
            color: isDark ? Colors.white : StudentUiColors.darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),

        SizedBox(height: 12.h),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.85,
          children: [
            _QuickAccessCard(
              icon: Icons.chat_bubble_outline,
              title: 'Mensajes',
              description: 'Habla con tu orientador',
              color: StudentUiColors.teal,
              onTap: onMessagesTap,
            ),

            _QuickAccessCard(
              icon: Icons.event_outlined,
              title: 'Eventos',
              description: 'Ferias y actividades',
              color: StudentUiColors.teal,
              onTap: onEventsTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F38) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.20 : 0.13),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                icon,
                color: isDark ? const Color(0xFF4EE27D) : color,
                size: 25.sp,
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : StudentUiColors.darkText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                      fontSize: 10.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white30 : Colors.grey[400],
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}