import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    // Navegación segura Navigation 2.0
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) context.go('/onboarding');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFF5F3FF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(flex: 3),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200.w),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF311B92).withOpacity(0.05)),
                          child: Icon(Icons.explore_rounded, size: 90.sp, color: const Color(0xFF311B92)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text('Oriéntate+', style: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B), letterSpacing: -1.5)),
                const Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: const LinearProgressIndicator(backgroundColor: Color(0xFFE0E7FF), valueColor: AlwaysStoppedAnimation(Color(0xFF311B92))),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            );
          },
        ),
      ),
    );
  }
}
