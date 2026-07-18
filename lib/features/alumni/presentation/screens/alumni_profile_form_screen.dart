import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_text_field.dart';
import '../providers/alumni_profile_form_provider.dart';

class AlumniProfileFormScreen extends StatelessWidget {
  const AlumniProfileFormScreen({super.key});

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniProfileFormProvider>();
    final profile = provider.profile;

    // Cargar perfil si es necesario
    if (profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadProfile());
    }

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Perfil de Egresado',
          style: TextStyle(
            color: const Color(0xFF1D1B4B),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildHeader(),
                    SizedBox(height: 32.h),
                    AlumniTextField(
                      label: 'Nombre Completo',
                      hint: 'Ej. Juan Pérez',
                      icon: Icons.person_outline,
                      controller: provider.nameController,
                    ),
                    SizedBox(height: 20.h),
                    AlumniTextField(
                      label: 'Correo de Contacto',
                      hint: 'juan.p@ejemplo.com',
                      icon: Icons.email_outlined,
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: AlumniTextField(
                            label: 'Año Graduación',
                            hint: '2024',
                            icon: Icons.calendar_today_outlined,
                            controller: provider.yearController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AlumniTextField(
                            label: 'Carrera',
                            hint: 'Ingeniería...',
                            icon: Icons.school_outlined,
                            controller: provider.majorController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    AlumniTextField(
                      label: 'Empresa Actual',
                      hint: 'Google, Amazon, etc.',
                      icon: Icons.work_outline,
                      controller: provider.companyController,
                    ),
                    SizedBox(height: 48.h),
                    _buildSaveButton(context, provider, formKey),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola Egresado! 👋',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Tus datos nos ayudan a conectar mejor tus historias con los estudiantes.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, AlumniProfileFormProvider provider, GlobalKey<FormState> formKey) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () async {
          if (formKey.currentState!.validate()) {
            final success = await provider.submitProfile();
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado correctamente'), backgroundColor: Colors.green),
              );
              context.push(AppRoutes.writeStory.path);
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.errorMessage ?? 'Error al actualizar'), backgroundColor: Colors.redAccent),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: provider.isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text('Guardar Perfil', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
