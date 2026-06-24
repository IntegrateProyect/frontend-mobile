import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _blinkController;

  late Animation<double> _circleAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.55, curve: Curves.elasticOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut),
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeInOut),
      ),
    );

    _mainController.forward();

    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF39195B);
    const Color softPurple = Color(0xFF5B2EFF);
    const Color coral = Color(0xFFFF6B6B);
    const Color cream = Color(0xFFFFF7ED);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cream,
              Color(0xFFF6EDFF),
              Color(0xFFFFEEF0),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_mainController, _blinkController]),
            builder: (context, child) {
              return Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo animado
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Brillo de fondo
                        Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: softPurple.withOpacity(0.08),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryPurple.withOpacity(0.18),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Círculo que se dibuja
                        CustomPaint(
                          size: const Size(145, 145),
                          painter: _LogoCirclePainter(
                            progress: _circleAnimation.value,
                            color: primaryPurple,
                          ),
                        ),

                        // Ícono brújula
                        Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoScaleAnimation.value.clamp(0.0, 1.0),
                            child: Transform.rotate(
                              angle: -0.35,
                              child: const Icon(
                                Icons.navigation_rounded,
                                size: 68,
                                color: primaryPurple,
                              ),
                            ),
                          ),
                        ),

                        // Punto central
                        Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Signo +
                        Positioned(
                          top: 23,
                          right: 28,
                          child: Opacity(
                            opacity: 0.35 + (_blinkController.value * 0.65),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: coral,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: coral.withOpacity(0.45),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Nombre de la app
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textOpacityAnimation,
                      child: Column(
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Oriéntate',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    color: primaryPurple,
                                    letterSpacing: -1,
                                  ),
                                ),
                                TextSpan(
                                  text: '+',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    color: coral,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Descubre tu camino vocacional',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Barra de carga
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: LinearProgressIndicator(
                            value: _loadingAnimation.value,
                            minHeight: 8,
                            backgroundColor: primaryPurple.withOpacity(0.12),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        FadeTransition(
                          opacity: _textOpacityAnimation,
                          child: const Text(
                            'CARGANDO EXPERIENCIA',
                            style: TextStyle(
                              color: primaryPurple,
                              fontSize: 12,
                              letterSpacing: 2.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  FadeTransition(
                    opacity: _textOpacityAnimation,
                    child: Text(
                      'Versión 1.0.0',
                      style: TextStyle(
                        color: primaryPurple.withOpacity(0.45),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LogoCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _LogoCirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(
      10,
      10,
      size.width - 20,
      size.height - 20,
    );

    canvas.drawArc(
      rect,
      -math.pi / 1.1,
      math.pi * 1.75 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LogoCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}