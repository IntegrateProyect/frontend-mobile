import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_styles.dart';

class LoginLabel extends StatelessWidget {
  final String text;

  const LoginLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: LoginStyles.darkTextColor,
        ),
      ),
    );
  }
}
