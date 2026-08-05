import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../register_input_field.dart';
import '../lower_case_text_formatter.dart';

class PersonalStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Uint8List? profileImage;
  final VoidCallback onPickImage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final ValueChanged<String>? onSubmitted;
  final Color primaryColor;
  final Color darkTextColor;

  const PersonalStep({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.profileImage,
    required this.onPickImage,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    this.onSubmitted,
    required this.primaryColor,
    required this.darkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF3F4F6),
                  image: profileImage != null
                      ? DecorationImage(
                          image: MemoryImage(profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImage == null
                    ? Icon(
                        Icons.person,
                        size: 58.sp,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              Positioned(
                right: -2.w,
                bottom: 4.h,
                child: Material(
                  color: primaryColor,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onPickImage,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 34.h),
        Text(
          'Información personal',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: darkTextColor,
          ),
        ),
        SizedBox(height: 26.h),
        RegisterInputField(
          label: 'Nombre completo *',
          hint: 'Ej. Juan Pérez',
          controller: nameController,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          capitalization: TextCapitalization.words,
          primaryColor: primaryColor,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]'),
            ),
          ],
        ),
        RegisterInputField(
          label: 'Correo electrónico *',
          hint: 'juan@gmail.com',
          controller: emailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          primaryColor: primaryColor,
          inputFormatters: [
            const LowerCaseTextFormatter(),
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-z0-9@._%+\-]'),
            ),
          ],
        ),
        RegisterInputField(
          label: 'Contraseña *',
          hint: 'Mínimo 8 caracteres',
          controller: passwordController,
          icon: Icons.lock_outline,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.next,
          onToggleVisibility: onTogglePassword,
          primaryColor: primaryColor,
        ),
        RegisterInputField(
          label: 'Confirmar contraseña *',
          hint: 'Repite tu contraseña',
          controller: confirmPasswordController,
          icon: Icons.lock_reset,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          onSubmitted: onSubmitted,
          onToggleVisibility: onToggleConfirmPassword,
          primaryColor: primaryColor,
        ),
        Text(
          'Al crear tu cuenta, aceptas nuestros Términos de Servicio y el Aviso de Privacidad.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11.sp,
            height: 1.4,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
