import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounselorSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color darkColor;

  const CounselorSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.darkColor = const Color(0xFF17164A),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: darkColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
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
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.button,
    this.onTap,
    this.darkColor = const Color(0xFF17164A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: color.withOpacity(.13)),
      ),
      child: Row(
        children: [
          Container(
            width: 49.w,
            height: 49.w,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          if (button != null)
            TextButton(
              onPressed: onTap,
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
    super.key,
    required this.icon,
    required this.text,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0FA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: primaryColor),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryColor,
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
