import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_styles.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback? onTap;

  const ForgotPasswordLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: LoginStyles.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
