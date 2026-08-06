import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/student_ui_colors.dart';
import 'riasec_styles.dart';

class RiasecScoreRow extends StatelessWidget {
  final String letter;
  final double score;

  const RiasecScoreRow({
    super.key,
    required this.letter,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final color = RiasecStyles.riasecColors[letter] ?? StudentUiColors.primary;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 37.w,
            height: 37.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        RiasecStyles.riasecNames[letter] ?? letter,
                        style: TextStyle(
                          color: isDark ? Colors.white : StudentUiColors.darkText,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${(score * 100).round()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 7.h,
                    backgroundColor: color.withOpacity(0.09),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
