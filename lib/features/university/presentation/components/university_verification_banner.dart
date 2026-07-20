import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/AppRoutes.dart';

class UniversityVerificationBanner extends StatelessWidget {
  const UniversityVerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 16),
              SizedBox(width: 6.w),
              Text(
                'Impulsa tu presencia',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Solicita tu verificación RENOES para destacar ante los aspirantes.',
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11.sp,
                height: 1.2),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            height: 34.h,
            child: ElevatedButton(
              onPressed: () =>
                  context.push(AppRoutes.universityVerification.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.zero,
              ),
              child: Text('Solicitar Verificación',
                  style:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 11.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
