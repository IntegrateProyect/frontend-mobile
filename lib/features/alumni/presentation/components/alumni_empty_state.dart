import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlumniEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AlumniEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);
    const Color primaryColor = Color(0xFF311B92);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Composición Visual: Natural, Orgánica y Premium
            SizedBox(
              height: 220.r,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Halo atmosférico de fondo
                  Container(
                    width: 200.r,
                    height: 200.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.08),
                          const Color(0xFFF8F9FE).withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  // Blobs decorativos
                  Positioned(
                    right: 40.w,
                    top: 15.h,
                    child: Container(
                      width: 70.r,
                      height: 70.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEDE9FE).withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45.w,
                    bottom: 25.h,
                    child: Container(
                      width: 55.r,
                      height: 55.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  // Contenedor de la ilustración (Tarjeta Redondeada)
                  Container(
                    width: 180.r,
                    height: 180.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(42.r),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagePath,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          // Overlay sutil
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  primaryColor.withOpacity(0.05),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Insignia Premium
                  Positioned(
                    top: 25.h,
                    left: 50.w,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.amber[400],
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: Colors.grey[500],
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 28.h),
              _buildPremiumButton(actionLabel!, onAction!, primaryColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumButton(String label, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 15.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
