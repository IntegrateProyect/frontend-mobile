import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_styles.dart';

class RegisterLink extends StatelessWidget {
  final VoidCallback? onTap;

  const RegisterLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Regístrate aquí',
            style: TextStyle(
              color: LoginStyles.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
