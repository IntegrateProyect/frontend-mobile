import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/university_announcement_entity.dart';
import '../providers/university_announcements_provider.dart';

class UniversityAnnouncementForm extends StatelessWidget {
  final UniversityAnnouncementEntity? announcement;
  final VoidCallback onSuccess;

  const UniversityAnnouncementForm({
    super.key,
    this.announcement,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityAnnouncementsProvider>();
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    final formKey = GlobalKey<FormState>();
    final List<String> categories = ['General', 'Becas', 'Inscripción', 'Convocatoria', 'Otro'];

    return Container(
      padding: EdgeInsets.all(32.r),
      child: Form(
        key: formKey,
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
                announcement == null
                    ? 'Nueva Convocatoria'
                    : 'Editar Convocatoria',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              SizedBox(height: 24.h),
              _buildFieldLabel('TÍTULO'),
              TextFormField(
                controller: provider.titleController,
                decoration: _inputDecoration('Ej. Beca de Excelencia 2024'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa un título' : null,
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel('CONTENIDO'),
              TextFormField(
                controller: provider.descController,
                maxLines: 4,
                decoration: _inputDecoration('Escribe los detalles aquí...'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el contenido' : null,
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel('CATEGORÍA'),
              DropdownButtonFormField<String>(
                value: provider.selectedCategory,
                decoration: _inputDecoration(''),
                items: categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c,
                    child: Text(c),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) provider.setCategory(val);
                },
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel('BANNER DEL ANUNCIO'),
              _buildImagePicker(provider),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: provider.isSubmitting ? null : () async {
                    if (formKey.currentState!.validate()) {
                      await provider.submitForm(
                        id: announcement?.id,
                        existingImageUrl: announcement?.imageUrl,
                      );
                      onSuccess();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: provider.isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          announcement == null
                              ? 'Publicar Anuncio'
                              : 'Guardar Cambios',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: Colors.grey[500],
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14.sp),
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      contentPadding: EdgeInsets.all(16.r),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildImagePicker(UniversityAnnouncementsProvider provider) => InkWell(
    onTap: () async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) provider.setAnnouncementImage(image);
    },
    borderRadius: BorderRadius.circular(16.r),
    child: Container(
      height: 120.h, width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(16.r), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: provider.imageFile != null 
        ? ClipRRect(borderRadius: BorderRadius.circular(16.r), child: Image.file(File(provider.imageFile!.path), fit: BoxFit.cover))
        : (announcement?.imageUrl != null && announcement!.imageUrl!.isNotEmpty)
          ? ClipRRect(borderRadius: BorderRadius.circular(16.r), child: Image.network(announcement!.imageUrl!, fit: BoxFit.cover))
          : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400], size: 32.sp), SizedBox(height: 8.h), Text('Subir Imagen', style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]))])),
    ),
  );
}
