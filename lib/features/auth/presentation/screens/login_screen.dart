import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
import '../providers/auth_provider.dart';
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
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkTextColor = Color(0xFF1D1B4B);
  static const Color _fieldColor = Color(0xFFF8F9FE);

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

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
      _showError(
        'Ingresa tu correo electrónico',
      );
      return;
    }

    if (password.isEmpty) {
      _showError(
        'Ingresa tu contraseña',
      );
      return;
    }

    final success = await authProvider.login(
      email,
      password,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      _showError(
        authProvider.errorMessage ??
            'No fue posible iniciar sesión',
      );
      return;
    }

    final role = authProvider.user?.role
        ?.trim()
        .toLowerCase() ??
        '';

    await _redirectByRole(
      role: role,
      authProvider: authProvider,
    );
  }

  Future<void> _redirectByRole({
    required String role,
    required AuthProvider authProvider,
  }) async {
    /*
     * ORIENTADOR
     */
    if (_isCounselorRole(role)) {
      if (mounted) {
        context.go(
          AppRoutes.counselorHome.path,
        );
      }

      return;
    }

    /*
     * ESTUDIANTE
     *
     * Antes de entrar al Home se comprueba si ya tiene
     * creado su perfil vocacional.
     */
    if (_isStudentRole(role)) {
      final profileExists =
      await authProvider.studentProfileExists();

      if (!mounted) {
        return;
      }

      /*
       * El backend respondió que el perfil no existe.
       *
       * Esto es normal para una cuenta recién creada.
       * No se muestra como error.
       */
      if (profileExists == false) {
        context.go(
          AppRoutes.studentProfileSetup.path,
        );

        return;
      }

      /*
       * El estudiante ya tiene perfil vocacional.
       */
      if (profileExists == true) {
        context.go(
          AppRoutes.home.path,
        );

        return;
      }

      /*
       * null representa un error real:
       * conexión, token, servidor u otro problema.
       */
      _showError(
        authProvider.errorMessage ??
            'No fue posible comprobar tu perfil vocacional',
      );

      return;
    }

    /*
     * UNIVERSIDAD
     */
    if (_isUniversityRole(role)) {
      if (mounted) {
        final verificationStatus = authProvider.user?.verificationStatus;
        if (verificationStatus == 'VERIFIED') {
          context.go(
            AppRoutes.universityHome.path,
          );
        } else {
          context.go(
            AppRoutes.universityVerification.path,
          );
        }
      }

      return;
    }

    /*
     * ALUMNI O EGRESADO
     */
    if (_isAlumniRole(role)) {
      if (mounted) {
        context.go(
          AppRoutes.alumniHome.path,
        );
      }

      return;
    }

    /*
     * ADMINISTRADOR
     */
    if (_isAdminRole(role)) {
      if (mounted) {
        context.go(
          AppRoutes.adminHome.path,
        );
      }

      return;
    }

    _showError(
      'El rol de esta cuenta no es válido',
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
        role == 'egresada' ||
        role.contains('alumni') ||
        role.contains('egresado') ||
        role.contains('egresada');
  }

  bool _isAdminRole(String role) {
    return role == 'admin' ||
        role == 'administrador' ||
        role.contains('admin');
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.r,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return PlatformScaffold(
      backgroundColor: Colors.white,
      material: (_, __) {
        return MaterialScaffoldData(
          resizeToAvoidBottomInset: true,
        );
      },
      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 70.h),

                      _buildHeader(),

                      SizedBox(height: 55.h),

                      _buildLabel(
                        'Correo electrónico',
                      ),

                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: _emailController,
                        enabled: !authProvider.isLoading,
                        inputFormatters: [
                          const _LowerCaseTextFormatter(),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-z0-9@._%+\-]'),
                          ),
                        ],
                        keyboardType:
                        TextInputType.emailAddress,
                        textInputAction:
                        TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        decoration: _inputDecoration(
                          hint: 'ejemplo@correo.com',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      _buildLabel(
                        'Contraseña',
                      ),

                      SizedBox(height: 10.h),

                      TextFormField(
                        controller: _passwordController,
                        enabled: !authProvider.isLoading,
                        obscureText: _obscurePassword,
                        textInputAction:
                        TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        onFieldSubmitted: (_) {
                          if (!authProvider.isLoading) {
                            _handleLogin();
                          }
                        },
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        decoration: _inputDecoration(
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            onPressed:
                            authProvider.isLoading
                                ? null
                                : () {
                              setState(() {
                                _obscurePassword =
                                !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons
                                  .visibility_outlined
                                  : Icons
                                  .visibility_off_outlined,
                              size: 22.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 36.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            _primaryColor,
                            foregroundColor:
                            Colors.white,
                            disabledBackgroundColor:
                            _primaryColor.withOpacity(
                              0.55,
                            ),
                            padding:
                            EdgeInsets.symmetric(
                              vertical: 18.h,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                16.r,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: authProvider.isLoading
                              ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child:
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Wrap(
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
                            onTap: authProvider.isLoading
                                ? null
                                : () {
                              context.push(
                                AppRoutes
                                    .roleSelection
                                    .path,
                              );
                            },
                            child: Text(
                              'Regístrate aquí',
                              style: TextStyle(
                                color: _primaryColor,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(
              0.05,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: _primaryColor,
              width: 1.5.w,
            ),
          ),
          child: Icon(
            Icons.explore,
            size: 50.sp,
            color: _primaryColor,
          ),
        ),

        SizedBox(height: 28.h),

        Text(
          'Oriéntate+',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w900,
            color: _darkTextColor,
            letterSpacing: -1,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          'Tu futuro profesional comienza aquí.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: _darkTextColor,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 15.sp,
      ),
      prefixIcon: Icon(
        icon,
        color: _primaryColor,
        size: 24.sp,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: _fieldColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: 18.h,
        horizontal: 20.w,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: _primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}

class _LowerCaseTextFormatter extends TextInputFormatter {
  const _LowerCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final lowerCaseText = newValue.text.toLowerCase();

    return newValue.copyWith(
      text: lowerCaseText,
      selection: TextSelection.collapsed(
        offset: lowerCaseText.length,
      ),
      composing: TextRange.empty,
    );
  }
}