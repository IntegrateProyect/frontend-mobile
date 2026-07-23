import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkTextColor = Color(0xFF1D1B4B);

  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    FocusScope.of(context).unfocus();
    final authProvider = context.read<AuthProvider>();

    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (token.isEmpty) {
      _showError('Ingresa el código enviado a tu correo');
      return;
    }

    if (password.isEmpty) {
      _showError('Ingresa tu nueva contraseña');
      return;
    }

    if (password.length < 6) {
      _showError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (password != confirmPassword) {
      _showError('Las contraseñas no coinciden');
      return;
    }

    final success = await authProvider.resetPassword(token, password);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña restablecida con éxito. Ya puedes iniciar sesión.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(); // Regresa al Login
    } else {
      _showError(authProvider.errorMessage ?? 'Ocurrió un error al restablecer tu contraseña.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _darkTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Restablecer\nContraseña',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: _darkTextColor,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Ingresa el código de validación que te llegó por correo junto con tu nueva contraseña.',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 36.h),
              Text(
                'Código de Recuperación',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _darkTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _tokenController,
                enabled: !authProvider.isLoading,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Pega el token UUID aquí',
                  prefixIcon: const Icon(Icons.vpn_key_outlined, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Nueva Contraseña',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _darkTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _passwordController,
                enabled: !authProvider.isLoading,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Confirmar Contraseña',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _darkTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _confirmPasswordController,
                enabled: !authProvider.isLoading,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleResetPassword(),
                decoration: InputDecoration(
                  hintText: 'Repite tu nueva contraseña',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _primaryColor.withOpacity(0.55),
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: authProvider.isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Restablecer Contraseña',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
