import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../responsive.dart';

class UniversityVerificationBanner extends StatelessWidget {
  const UniversityVerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    final screenSize = context.screenSize;

    return Container(
      padding: EdgeInsets.all(screenSize == AppScreenSize.mobile ? 16.r : 20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF311B92).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Impulsa tu presencia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Solicita tu verificación RENOES para destacar ante los aspirantes y obtener acceso a herramientas premium.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
              height: 1.3,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: screenSize == AppScreenSize.mobile ? double.infinity : 200.w,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.universityVerification.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text(
                'Solicitar Verificación',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
