import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversityEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final String imagePath;
  final IconData fallbackIcon;

  const UniversityEmptyState({
    super.key,
    required this.title,
    this.description,
    required this.imagePath,
    this.fallbackIcon = Icons.school_rounded,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen vectorizada Line-Art ampliada
            SizedBox(
              height: 170.h,
              width: 170.w,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    fallbackIcon,
                    size: 64.sp,
                    color: primaryColor.withOpacity(0.8),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),

            // Texto gris simple y directo
            Text(
              description ?? title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
