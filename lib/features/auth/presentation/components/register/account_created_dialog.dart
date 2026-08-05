import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountCreatedDialog extends StatefulWidget {
  final VoidCallback onFinished;

  const AccountCreatedDialog({
    super.key,
    required this.onFinished,
  });

  @override
  State<AccountCreatedDialog> createState() => _AccountCreatedDialogState();
}

class _AccountCreatedDialogState extends State<AccountCreatedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _trumpetScale;
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _trumpetScale = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.4, end: 1.15).chain(
            CurveTween(curve: Curves.easeOutBack),
          ),
          weight: 70,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.15, end: 1),
          weight: 30,
        ),
      ],
    ).animate(_animationController);

    _animationController.forward();

    _closeTimer = Timer(const Duration(milliseconds: 900), widget.onFinished);
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 0.84.sw,
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 25.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150.w,
                height: 105.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 5.w,
                      top: 12.h,
                      child: _sparkle(
                        color: const Color(0xFFFFC107),
                        size: 25.sp,
                      ),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 7.h,
                      child: _sparkle(
                        color: const Color(0xFFFF8A65),
                        size: 22.sp,
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      bottom: 4.h,
                      child: _sparkle(
                        color: const Color(0xFF7C4DFF),
                        size: 17.sp,
                      ),
                    ),
                    Positioned(
                      right: 20.w,
                      bottom: 8.h,
                      child: _sparkle(
                        color: const Color(0xFF26C6DA),
                        size: 18.sp,
                      ),
                    ),
                    ScaleTransition(
                      scale: _trumpetScale,
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2EFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.campaign_rounded,
                          color: const Color(0xFF311B92),
                          size: 46.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '¡Felicidades!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1D1B4B),
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tu cuenta fue creada correctamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Ahora inicia sesión para completar tu perfil vocacional.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: 25.w,
                height: 25.w,
                child: const CircularProgressIndicator(
                  color: Color(0xFF311B92),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sparkle({
    required Color color,
    required double size,
  }) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: size,
    );
  }
}
