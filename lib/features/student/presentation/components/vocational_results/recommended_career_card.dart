import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/career_entity.dart';
import '../common/student_ui_colors.dart';

class RecommendedCareerCard extends StatelessWidget {
  final int position;
  final CareerEntity career;

  const RecommendedCareerCard({
    super.key,
    required this.position,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final university = career.universityName?.trim();
    final isFirst = position == 1;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isFirst
              ? StudentUiColors.primary.withOpacity(0.48)
              : (isDark ? const Color(0xFF2E305C) : const Color(0xFFE6E2F2)),
        ),
        boxShadow: [
          BoxShadow(
            color: StudentUiColors.primary.withOpacity(
              isFirst ? 0.10 : 0.045,
            ),
            blurRadius: isFirst ? 16 : 11,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5B21B6),
                  Color(0xFF4338CA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#$position',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isFirst)
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFD166),
                    size: 13.sp,
                  ),
              ],
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? (isDark ? const Color(0xFF2D251D) : const Color(0xFFFFF4D8))
                        : (isDark ? const Color(0xFF2E2452) : const Color(0xFFF1ECFF)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    isFirst
                        ? 'MEJOR COINCIDENCIA'
                        : 'OPCIÓN RECOMENDADA',
                    style: TextStyle(
                      color: isFirst
                          ? (isDark ? const Color(0xFFFFD166) : const Color(0xFFB76A00))
                          : (isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary),
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.35,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  career.name.trim().isEmpty
                      ? 'Carrera sin nombre'
                      : career.name.trim(),
                  style: TextStyle(
                    color: isDark ? Colors.white : StudentUiColors.darkText,
                    fontSize: 13.5.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (university != null &&
                    university.isNotEmpty) ...[
                  SizedBox(height: 9.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF15162D) : const Color(0xFFF8F7FC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 27.w,
                          height: 27.w,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2E2452)
                                : StudentUiColors.primary.withOpacity(0.10),
                            borderRadius:
                            BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.account_balance_rounded,
                            size: 15.sp,
                            color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            university,
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade300 : Colors.grey[700],
                              fontSize: 10.5.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
                      size: 15.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Seleccionada a partir de tus resultados',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                          fontSize: 9.8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
