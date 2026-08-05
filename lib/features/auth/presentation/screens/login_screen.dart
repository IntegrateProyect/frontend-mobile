import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
import '../providers/auth_provider.dart';
import '../components/login/lower_case_text_formatter.dart';
import '../components/login/login_styles.dart';
import '../components/login/login_header.dart';
import '../components/login/login_input_decorations.dart';
import '../components/login/login_label.dart';
import '../components/login/forgot_password_link.dart';
import '../components/login/login_button.dart';
import '../components/login/register_link.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showError('Ingresa tu correo electrónico');
      return;
    }

    if (password.isEmpty) {
      _showError('Ingresa tu contraseña');
      return;
    }

    final success = await authProvider.login(email, password);

    if (!mounted) return;

    if (!success) {
      _showError(
        authProvider.errorMessage ?? 'No fue posible iniciar sesión',
      );
      return;
    }

    final role = authProvider.user?.role?.trim().toLowerCase() ?? '';
    await _redirectByRole(role: role, authProvider: authProvider);
  }

  Future<void> _redirectByRole({
    required String role,
    required AuthProvider authProvider,
  }) async {
    if (_isCounselorRole(role)) {
      if (mounted) context.go(AppRoutes.counselorHome.path);
      return;
    }

    if (_isStudentRole(role)) {
      final profileExists = await authProvider.studentProfileExists();
      if (!mounted) return;

      if (profileExists == false) {
        context.go(AppRoutes.studentProfileSetup.path);
        return;
      }

      if (profileExists == true) {
        context.go(AppRoutes.home.path);
        return;
      }

      _showError(
        authProvider.errorMessage ?? 'No fue posible comprobar tu perfil vocacional',
      );
      return;
    }

    if (_isUniversityRole(role)) {
      if (mounted) {
        final verificationStatus = authProvider.user?.verificationStatus;
        if (verificationStatus == 'VERIFIED') {
          context.go(AppRoutes.universityHome.path);
        } else {
          context.go(AppRoutes.universityVerification.path);
        }
      }
      return;
    }

    if (_isAlumniRole(role)) {
      if (mounted) context.go(AppRoutes.alumniHome.path);
      return;
    }

    if (_isAdminRole(role)) {
      if (mounted) context.go(AppRoutes.adminHome.path);
      return;
    }

    _showError('El rol de esta cuenta no es válido');
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
        role == 'egresada' ||
        role.contains('alumni') ||
        role.contains('egresado') ||
        role.contains('egresada');
  }

  bool _isAdminRole(String role) {
    return role == 'admin' || role == 'administrador' || role.contains('admin');
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return PlatformScaffold(
      backgroundColor: Colors.white,
      material: (_, __) => MaterialScaffoldData(resizeToAvoidBottomInset: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 70.h),
                      const LoginHeader(),
                      SizedBox(height: 55.h),
                      const LoginLabel(text: 'Correo electrónico'),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: _emailController,
                        enabled: !authProvider.isLoading,
                        inputFormatters: [
                          const LowerCaseTextFormatter(),
                          FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9@._%+\-]')),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.email],
                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                        decoration: LoginInputDecorations.getFieldDecoration(
                          hint: 'ejemplo@correo.com',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      const LoginLabel(text: 'Contraseña'),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !authProvider.isLoading,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) {
                          if (!authProvider.isLoading) _handleLogin();
                        },
                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                        decoration: LoginInputDecorations.getFieldDecoration(
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () => setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 22.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ForgotPasswordLink(
                        onTap: authProvider.isLoading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                      ),
                      SizedBox(height: 36.h),
                      LoginButton(
                        isLoading: authProvider.isLoading,
                        onPressed: _handleLogin,
                      ),
                      SizedBox(height: 32.h),
                      RegisterLink(
                        onTap: authProvider.isLoading
                            ? null
                            : () => context.push(AppRoutes.roleSelection.path),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
