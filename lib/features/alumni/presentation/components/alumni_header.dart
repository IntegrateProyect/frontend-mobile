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

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 40.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(48.r)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profle Picture Composition
          Stack(
            alignment: Alignment.center,
            children: [
              // Decorative halo
              Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              // Main Avatar
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded, 
                    size: 50.sp, 
                    color: _primaryColor.withOpacity(0.8)
                  ),
                ),
              ),
              // Verified Badge
              if (isVerified)
                Positioned(
                  bottom: 2.h,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981), // Emerald/Green
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                      ],
                    ),
                    child: Icon(Icons.verified_rounded, color: Colors.white, size: 14.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
