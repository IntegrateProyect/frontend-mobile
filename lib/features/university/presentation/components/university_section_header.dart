import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../responsive.dart';

class UniversitySectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const UniversitySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                // Ajuste de tamaños legibles para escala 1.0
                fontSize: context.responsiveValue(mobile: 14.5.sp, tablet: 15.5.sp, desktop: 16.5.sp),
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: -0.2,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(width: 8.w),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: primaryColor,
                backgroundColor: primaryColor.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: context.responsiveValue(mobile: 10.sp, tablet: 11.sp, desktop: 12.sp),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
