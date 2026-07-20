import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/university_event_entity.dart';
import '../providers/university_events_provider.dart';

class UniversityEventForm extends StatelessWidget {
  final UniversityEventEntity? event;
  final VoidCallback onSuccess;

  const UniversityEventForm({
    super.key,
    this.event,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityEventsProvider>();
    final dateLabel = provider.selectedDate == null ? 'Seleccionar Día' : DateFormat('dd/MM/yyyy').format(provider.selectedDate!);
    final timeLabel = provider.selectedTime == null ? 'Seleccionar Hora' : provider.selectedTime!.format(context);
    
    const primaryColor = Color(0xFF311B92);
    const accentColor = Color(0xFF1D1B4B);

    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(32.r),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDragHandle(),
              SizedBox(height: 24.h),
              Text(
                event == null ? 'Nuevo Evento' : 'Editar Evento',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: accentColor),
              ),
              SizedBox(height: 24.h),
              _buildLabel('TÍTULO DEL EVENTO'),
              TextFormField(
                controller: provider.titleController,
                decoration: _inputStyle('Ej. Feria Vocacional 2024'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel('UBICACIÓN'),
              TextFormField(
                controller: provider.locationController,
                decoration: _inputStyle('Ej. Auditorio Principal'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(child: _buildPickerTile(context, Icons.calendar_today, dateLabel, () => _selectDate(context, provider))),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildPickerTile(context, Icons.access_time, timeLabel, () => _selectTime(context, provider))),
                ],
              ),
              SizedBox(height: 24.h),
              _buildLabel('BANNER DEL EVENTO'),
              _buildImagePicker(provider),
              SizedBox(height: 32.h),
              _buildSubmitButton(context, provider, formKey),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() => Center(
    child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r))),
  );

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(text, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1.0)),
  );

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint, filled: true, fillColor: const Color(0xFFF8F9FE),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
  );

  Widget _buildPickerTile(BuildContext context, IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(12.r)),
      child: Row(children: [Icon(icon, size: 18.sp, color: const Color(0xFF311B92)), SizedBox(width: 12.w), Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold))]),
    ),
  );

  Widget _buildImagePicker(UniversityEventsProvider provider) => InkWell(
    onTap: () async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) provider.setEventImage(image);
    },
    borderRadius: BorderRadius.circular(16.r),
    child: Container(
      height: 120.h, width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(16.r), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: provider.imageFile != null 
        ? ClipRRect(borderRadius: BorderRadius.circular(16.r), child: Image.file(File(provider.imageFile!.path), fit: BoxFit.cover))
        : (event?.imageUrl != null && event!.imageUrl!.isNotEmpty)
          ? ClipRRect(borderRadius: BorderRadius.circular(16.r), child: Image.network(event!.imageUrl!, fit: BoxFit.cover))
          : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400], size: 32.sp), SizedBox(height: 8.h), Text('Subir Imagen', style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]))])),
    ),
  );

  Widget _buildSubmitButton(BuildContext context, UniversityEventsProvider provider, GlobalKey<FormState> formKey) => SizedBox(
    width: double.infinity, height: 56.h,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF311B92), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)), elevation: 0),
      onPressed: provider.isSubmitting ? null : () async {
        if (formKey.currentState!.validate()) {
          await provider.submitForm(id: event?.id, existingImageUrl: event?.imageUrl);
          onSuccess();
        }
      },
      child: provider.isSubmitting 
        ? const CircularProgressIndicator(color: Colors.white) 
        : const Text('Publicar Evento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

  Future<void> _selectDate(BuildContext context, UniversityEventsProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) provider.setEventDate(picked);
  }

  Future<void> _selectTime(BuildContext context, UniversityEventsProvider provider) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) provider.setEventTime(picked);
  }
}
