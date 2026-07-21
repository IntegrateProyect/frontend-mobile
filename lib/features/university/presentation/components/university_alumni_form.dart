import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/university_alumni_entity.dart';
import '../providers/university_alumni_provider.dart';
import '../providers/university_careers_provider.dart';

class UniversityAlumniForm extends StatefulWidget {
  final UniversityAlumniEntity? alumni;
  final VoidCallback onSuccess;

  const UniversityAlumniForm({
    super.key,
    this.alumni,
    required this.onSuccess,
  });

  @override
  State<UniversityAlumniForm> createState() => _UniversityAlumniFormState();
}

class _UniversityAlumniFormState extends State<UniversityAlumniForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final alumniProvider = context.watch<UniversityAlumniProvider>();
    final careersProvider = context.watch<UniversityCareersProvider>();
    final isEditing = widget.alumni != null;

    const primaryColor = Color(0xFF311B92);
    const accentColor = Color(0xFF1D1B4B);

    return Container(
      padding: EdgeInsets.all(32.r),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                isEditing ? 'Editar Egresado' : 'Registrar Nuevo Egresado',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              SizedBox(height: 24.h),
              
              _buildLabel('NOMBRE COMPLETO'),
              TextFormField(
                controller: alumniProvider.nameController,
                decoration: _inputStyle('Ej. Juan Pérez'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),

              _buildLabel('CORREO ELECTRÓNICO'),
              TextFormField(
                controller: alumniProvider.emailController,
                decoration: _inputStyle('ejemplo@correo.com'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!v.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              if (!isEditing) ...[
                _buildLabel('CONTRASEÑA TEMPORAL'),
                TextFormField(
                  controller: alumniProvider.passwordController,
                  decoration: _inputStyle('Mínimo 6 caracteres'),
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                SizedBox(height: 16.h),
              ],

              _buildLabel('CARRERA'),
              DropdownButtonFormField<String>(
                value: alumniProvider.selectedCareerId,
                decoration: _inputStyle('Seleccionar carrera'),
                items: careersProvider.careers.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (val) => alumniProvider.setCareerId(val),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('AÑO GRADUACIÓN'),
                        TextFormField(
                          controller: alumniProvider.graduationYearController,
                          decoration: _inputStyle('Ej. 2023'),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('EMPRESA'),
                        TextFormField(
                          controller: alumniProvider.companyController,
                          decoration: _inputStyle('Ej. Google'),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('PUESTO ACTUAL'),
              TextFormField(
                controller: alumniProvider.jobController,
                decoration: _inputStyle('Ej. Software Engineer'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),

              _buildLabel('LINKEDIN (OPCIONAL)'),
              TextFormField(
                controller: alumniProvider.linkedinController,
                decoration: _inputStyle('https://linkedin.com/in/...'),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    elevation: 0,
                  ),
                  onPressed: alumniProvider.isSubmitting ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      await alumniProvider.submitForm(id: widget.alumni?.id);
                      if (mounted) {
                        if (alumniProvider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(alumniProvider.errorMessage!),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          widget.onSuccess();
                        }
                      }
                    }
                  },
                  child: alumniProvider.isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditing ? 'Guardar Cambios' : 'Registrar Egresado',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: Colors.grey[500],
            letterSpacing: 1.0,
          ),
        ),
      );

  InputDecoration _inputStyle(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FE),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      );
}
