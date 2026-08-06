import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class StudentRecommendationsCard extends StatelessWidget {
  final VoidCallback onUniversitiesTap;

  const StudentRecommendationsCard({
    super.key,
    required this.onUniversitiesTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D251D) : const Color(0xFFFFF4D8),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFFFFB000),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomendaciones para ti',
                      style: TextStyle(
                        color: isDark ? Colors.white : StudentUiColors.darkText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Encuentra instituciones relacionadas con tu perfil.',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          InkWell(
            onTap: onUniversitiesTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF15162D) : StudentUiColors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF2E305C) : StudentUiColors.blue.withOpacity(0.16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2E2452) : StudentUiColors.blue.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.account_balance_outlined,
                      color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.blue,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Universidades compatibles',
                          style: TextStyle(
                            color: isDark ? Colors.white : StudentUiColors.darkText,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Encuentra instituciones con carreras relacionadas.',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                            fontSize: 10.5.sp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.blue,
                    size: 25.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}