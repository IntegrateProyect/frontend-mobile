import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: LoginStyles.primaryColor.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: LoginStyles.primaryColor,
              width: 1.5.w,
            ),
          ),
          child: Icon(
            Icons.explore,
            size: 50.sp,
            color: LoginStyles.primaryColor,
          ),
        ),
        SizedBox(height: 28.h),
        Text(
          'Oriéntate+',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w900,
            color: LoginStyles.darkTextColor,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Tu futuro profesional comienza aquí.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
