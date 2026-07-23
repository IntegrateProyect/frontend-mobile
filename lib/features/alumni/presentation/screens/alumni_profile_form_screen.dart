import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_text_field.dart';
import '../providers/alumni_profile_form_provider.dart';

class AlumniProfileFormScreen extends StatelessWidget {
  const AlumniProfileFormScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniProfileFormProvider>();
    final profile = provider.profile;

    if (profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadProfile());
    }

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: _accentColor, size: 22.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Perfil Profesional',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    _buildHeader(),
                    SizedBox(height: 28.h),
                    _buildSectionLabel('DATOS DE IDENTIDAD'),
                    AlumniTextField(
                      label: 'Nombre Completo',
                      hint: 'Ej. Juan Pérez',
                      icon: Icons.person_outline_rounded,
                      controller: provider.nameController,
                    ),
                    SizedBox(height: 16.h),
                    AlumniTextField(
                      label: 'Correo de Contacto',
                      hint: 'ejemplo@correo.com',
                      icon: Icons.alternate_email_rounded,
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('FORMACIÓN ACADÉMICA'),
                    Row(
                      children: [
                        Expanded(
                          child: AlumniTextField(
                            label: 'Año Graduación',
                            hint: '2024',
                            icon: Icons.calendar_today_rounded,
                            controller: provider.yearController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AlumniTextField(
                            label: 'Carrera',
                            hint: 'Ej. Ing. Software',
                            icon: Icons.school_outlined,
                            controller: provider.majorController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('SITUACIÓN LABORAL'),
                    AlumniTextField(
                      label: 'Empresa Actual',
                      hint: 'Donde laboras actualmente',
                      icon: Icons.business_rounded,
                      controller: provider.companyController,
                    ),
                    SizedBox(height: 40.h),
                    _buildSaveButton(context, provider, formKey),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: Colors.grey[400],
          letterSpacing: 1.2,
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
            color: _accentColor,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Completa tu perfil para que tus historias inspiren a los futuros profesionales.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[500],
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, AlumniProfileFormProvider provider, GlobalKey<FormState> formKey) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () async {
          if (formKey.currentState!.validate()) {
            final success = await provider.submitProfile();
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado con éxito'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
              );
              context.push(AppRoutes.writeStory.path);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(56.h),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: provider.isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text('Guardar y Continuar', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
      ),
    );
  }
}
