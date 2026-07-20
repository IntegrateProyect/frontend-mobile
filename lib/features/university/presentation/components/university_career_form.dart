import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/university_career_entity.dart';
import '../providers/university_careers_provider.dart';

class UniversityCareerForm extends StatefulWidget {
  final UniversityCareersProvider provider;

  const UniversityCareerForm({super.key, required this.provider});

  @override
  State<UniversityCareerForm> createState() => _UniversityCareerFormState();
}

class _UniversityCareerFormState extends State<UniversityCareerForm> {
  final _formKey = GlobalKey<FormState>();
  UniversityCareerEntity? _selectedCareer;
  final _locationController = TextEditingController(text: 'Tuxtla Gutiérrez, Chiapas');
  final _costController = TextEditingController();
  final _datesController = TextEditingController(text: 'Mayo - Junio 2026');
  String _modality = 'Presencial';
  bool _scholarshipAvailable = true;

  @override
  void dispose() {
    _locationController.dispose();
    _costController.dispose();
    _datesController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCareer == null) {
      if (_selectedCareer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona una carrera del catálogo.')),
        );
      }
      return;
    }

    final double cost = double.tryParse(_costController.text.trim()) ?? 0.0;

    final careerToSave = UniversityCareerEntity(
      id: _selectedCareer!.id,
      name: _selectedCareer!.name,
      description: _selectedCareer!.description,
      cost: cost,
      location: _locationController.text.trim(),
      modality: _modality,
      scholarshipAvailable: _scholarshipAvailable,
      admissionDates: _datesController.text.trim(),
    );

    try {
      await widget.provider.addCareer(careerToSave);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carrera asociada exitosamente.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  width: 40.w, height: 4.h,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r)),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Asociar Nueva Carrera',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: accentColor),
              ),
              SizedBox(height: 24.h),
              _buildLabel('SELECCIONA UNA CARRERA DEL CATÁLOGO'),
              DropdownButtonFormField<UniversityCareerEntity>(
                decoration: _inputStyle('Seleccionar...'),
                items: widget.provider.catalogCareers.map((c) {
                  return DropdownMenuItem<UniversityCareerEntity>(
                    value: c,
                    child: Text(c.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCareer = val),
                validator: (val) => val == null ? 'Selección requerida' : null,
              ),
              SizedBox(height: 16.h),
              _buildLabel('UBICACIÓN / SEDE'),
              TextFormField(
                controller: _locationController,
                decoration: _inputStyle('Ej. Tuxtla Gutiérrez'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('MODALIDAD'),
                        DropdownButtonFormField<String>(
                          value: _modality,
                          decoration: _inputStyle(''),
                          items: const [
                            DropdownMenuItem(value: 'Presencial', child: Text('Presencial')),
                            DropdownMenuItem(value: 'Online', child: Text('Online')),
                            DropdownMenuItem(value: 'Mixta', child: Text('Mixta')),
                          ],
                          onChanged: (v) => setState(() => _modality = v!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('COSTO SEMESTRE'),
                        TextFormField(
                          controller: _costController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputStyle(r'$'),
                          validator: (v) => double.tryParse(v!) == null ? 'Inválido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildLabel('FECHAS DE ADMISIÓN'),
              TextFormField(
                controller: _datesController,
                decoration: _inputStyle('Ej. Mayo - Junio'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 24.h),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('¿Ofrece becas?', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                value: _scholarshipAvailable,
                activeThumbColor: primaryColor,
                onChanged: (v) => setState(() => _scholarshipAvailable = v),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    elevation: 0,
                  ),
                  onPressed: _submit,
                  child: const Text('Vincular Carrera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    child: Text(text, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: Colors.grey[500])),
  );

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint, filled: true, fillColor: const Color(0xFFF8F9FE),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
  );
}
