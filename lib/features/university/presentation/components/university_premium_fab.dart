import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversityPremiumFab extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const UniversityPremiumFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4527A0), Color(0xFF311B92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF311B92).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 22.sp),
                  SizedBox(width: 10.w),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
