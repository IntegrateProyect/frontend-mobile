import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlumniHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isVerified;

  const AlumniHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.isVerified = false,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF6A4CFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 40.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.r)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50.sp, color: primaryColor),
                ),
              ),
              if (isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified, color: Colors.blue, size: 20.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
