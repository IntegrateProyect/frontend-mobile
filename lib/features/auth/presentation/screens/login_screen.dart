import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Por favor, completa los campos');
      return;
    }

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      final role = authProvider.user?.role?.toLowerCase() ?? '';
      
      if (role == 'orientador') {
        context.go('/counselor-home');
      } else if (role == 'estudiante') {
        context.go('/home');
      } else if (role.contains('uni')) {
        context.go('/university-home');
      } else if (role.contains('alum') || role.contains('egresado')) {
        context.go('/alumni-home');
      } else {
        context.go('/home');
      }
    } else if (mounted) {
      _showError(authProvider.errorMessage ?? 'Error de autenticación');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return PlatformScaffold(
      backgroundColor: Colors.white,
      material: (_, __) => MaterialScaffoldData(
        resizeToAvoidBottomInset: true, // Ahora permitimos el ajuste para que el scroll funcione con teclado
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // ESTO CENTRA TODO VERTICALMENTE
                    children: [
                      SizedBox(height: 40.h),
                      
                      // LOGO Y TÍTULO
                      Column(
                        children: [
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF311B92).withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF311B92), width: 1.5.w),
                            ),
                            child: Icon(
                              Icons.explore,
                              size: 45.sp,
                              color: const Color(0xFF311B92),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Oriéntate+',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.sp, 
                              fontWeight: FontWeight.w900, 
                              color: const Color(0xFF1D1B4B),
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tu futuro profesional comienza aquí.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 45.h),

                      // FORMULARIO
                      _buildLabel('Correo Electrónico'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: _inputStyle(hint: 'ejemplo@correo.com', icon: Icons.email_outlined),
                      ),
                      
                      SizedBox(height: 20.h),

                      _buildLabel('Contraseña'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: _inputStyle(
                          hint: '••••••••', 
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                              size: 20.sp,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 45.h),

                      // BOTÓN DE ACCIÓN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF311B92),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            elevation: 0,
                          ),
                          child: authProvider.isLoading
                              ? SizedBox(
                                  height: 22.h, 
                                  width: 22.h, 
                                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text('Iniciar Sesión', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      const Spacer(), // Empuja el enlace de registro hacia abajo
                      
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text('¿No tienes una cuenta? ', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () => context.push('/role-selection'),
                              child: Text(
                                'Regístrate aquí', 
                                style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1D1B4B)),
      ),
    );
  }

  InputDecoration _inputStyle({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF311B92), size: 22.sp),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: const BorderSide(color: Color(0xFF311B92), width: 1.5),
      ),
    );
  }
}
