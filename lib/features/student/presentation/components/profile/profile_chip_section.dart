import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class ProfileChipSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final Color backgroundColor;
  final Color textColor;
  final String emptyText;

  const ProfileChipSection({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: StudentUiColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: StudentUiColors.darkText,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (items.isEmpty)
          Text(
            emptyText,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13.sp,
            ),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: items.map((item) {
              return Chip(
                label: Text(
                  item,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: backgroundColor,
                side: BorderSide.none,
              );
            }).toList(),
          ),
      ],
    );
  }
}