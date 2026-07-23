import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlumniInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AlumniInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          // Icon Container with soft background
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon, 
              color: primaryColor.withOpacity(0.8), 
              size: 20.sp
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[400],
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    height: 1.2,
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
