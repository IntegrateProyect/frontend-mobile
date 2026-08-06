import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounselorSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color darkColor;

  const CounselorSectionHeader({
    key,
    required this.title,
    required this.subtitle,
    this.darkColor = const Color(0xFF17164A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedDarkColor = isDark ? Colors.white : darkColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: resolvedDarkColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: 9.5.sp,
          ),
        ),
      ],
    );
  }
}

class CounselorEmptyFocusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? button;
  final VoidCallback? onTap;
  final Color darkColor;

  const CounselorEmptyFocusCard({
    key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.button,
    this.onTap,
    this.darkColor = const Color(0xFF17164A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedDarkColor = isDark ? Colors.white : darkColor;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: isDark ? const Color(0xFF2E305C) : color.withOpacity(.13)),
      ),
      child: Row(
        children: [
          Container(
            width: 49.w,
            height: 49.w,
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(.18) : color.withOpacity(.09),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(icon, color: isDark ? const Color(0xFFB59AFF) : color),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: resolvedDarkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          if (button != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: isDark ? const Color(0xFFB59AFF) : null,
              ),
              child: Text(button!),
            ),
        ],
      ),
    );
  }
}

class CounselorSmallTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color primaryColor;

  const CounselorSmallTag({
    key,
    required this.icon,
    required this.text,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF282443) : const Color(0xFFF2F0FA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: isDark ? const Color(0xFFB59AFF) : primaryColor),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? const Color(0xFFB59AFF) : primaryColor,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
