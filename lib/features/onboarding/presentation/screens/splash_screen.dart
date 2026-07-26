import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialRoute();
    });
  }

  Future<void> _checkInitialRoute() async {
    final authProvider = context.read<AuthProvider>();

    /*
     * Ejecutamos la comprobación mientras se muestra
     * la animación del Splash.
     */
    final results = await Future.wait<dynamic>([
      authProvider.hasCompletedOnboarding(),
      authProvider.restoreSession(),
      Future<void>.delayed(
        const Duration(milliseconds: 3000),
      ),
    ]);

    if (!mounted) return;

    final bool onboardingCompleted =
    results[0] as bool;

    final bool sessionRestored =
    results[1] as bool;

    /*
     * Si existe una sesión válida, entra directamente
     * sin mostrar onboarding ni login.
     */
    if (sessionRestored &&
        authProvider.user != null) {
      await _redirectByRole(authProvider);
      return;
    }

    /*
     * El onboarding solamente aparece cuando:
     *
     * 1. No existe una sesión válida.
     * 2. Nunca se ha mostrado en esta instalación.
     */
    if (!onboardingCompleted) {
      context.go(AppRoutes.onboarding.path);
      return;
    }

    /*
     * Ya vio el onboarding, pero no tiene sesión.
     */
    context.go(AppRoutes.login.path);
  }

  Future<void> _redirectByRole(
      AuthProvider authProvider,
      ) async {
    final String role =
        authProvider.user?.role
            ?.trim()
            .toLowerCase() ??
            '';

    /*
     * ESTUDIANTE
     */
    if (_isStudentRole(role)) {
      final profileExists =
      await authProvider.studentProfileExists();

      if (!mounted) return;

      /*
       * Cuenta nueva sin perfil vocacional.
       */
      if (profileExists == false) {
        context.go(
          AppRoutes.studentProfileSetup.path,
        );
        return;
      }

      /*
       * Estudiante con perfil completo.
       */
      if (profileExists == true) {
        context.go(
          AppRoutes.home.path,
        );
        return;
      }

      /*
       * Si ocurrió un error al consultar el perfil,
       * se envía al login para evitar una pantalla trabada.
       */
      await authProvider.logout();

      if (!mounted) return;

      context.go(
        AppRoutes.login.path,
      );
      return;
    }

    /*
     * ORIENTADOR
     */
    if (_isCounselorRole(role)) {
      context.go(
        AppRoutes.counselorHome.path,
      );
      return;
    }

    /*
     * UNIVERSIDAD
     */
    if (_isUniversityRole(role)) {
      final String verificationStatus =
          authProvider.user?.verificationStatus
              ?.trim()
              .toUpperCase() ??
              '';

      if (verificationStatus == 'VERIFIED') {
        context.go(
          AppRoutes.universityHome.path,
        );
      } else {
        context.go(
          AppRoutes.universityVerification.path,
        );
      }

      return;
    }

    /*
     * EGRESADO / ALUMNI
     */
    if (_isAlumniRole(role)) {
      context.go(
        AppRoutes.alumniHome.path,
      );
      return;
    }

    /*
     * ADMINISTRADOR
     */
    if (_isAdminRole(role)) {
      context.go(
        AppRoutes.adminHome.path,
      );
      return;
    }

    /*
     * Si el backend devuelve un rol desconocido,
     * se elimina la sesión guardada.
     */
    await authProvider.logout();

    if (!mounted) return;

    context.go(
      AppRoutes.login.path,
    );
  }

  bool _isStudentRole(String role) {
    return role == 'estudiante' ||
        role == 'student' ||
        role.contains('estudiante') ||
        role.contains('student');
  }

  bool _isCounselorRole(String role) {
    return role == 'orientador' ||
        role == 'counselor' ||
        role.contains('orientador') ||
        role.contains('counselor');
  }

  bool _isUniversityRole(String role) {
    return role == 'universidad' ||
        role == 'university' ||
        role.contains('universidad') ||
        role.contains('university');
  }

  bool _isAlumniRole(String role) {
    return role == 'alumni' ||
        role == 'egresado' ||
        role.contains('alumni') ||
        role.contains('egresado');
  }

  bool _isAdminRole(String role) {
    return role == 'admin' ||
        role == 'administrador' ||
        role.contains('admin');
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
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF5F3FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 200.w,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(
                            0xFF311B92,
                          ).withOpacity(0.05),
                        ),
                        child: Icon(
                          Icons.explore_rounded,
                          size: 90.sp,
                          color: const Color(
                            0xFF311B92,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                'Oriéntate+',
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1D1B4B),
                  letterSpacing: -1.5,
                ),
              ),

              const Spacer(flex: 2),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.2.sw,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.r,
                  ),
                  child: const LinearProgressIndicator(
                    backgroundColor: Color(
                      0xFFE0E7FF,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF311B92),
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}