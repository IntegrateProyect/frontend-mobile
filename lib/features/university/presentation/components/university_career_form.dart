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
  int _modeIndex = 0; // 0 = Vincular del Catálogo, 1 = Crear Carrera Personalizada

  // Form Fields - Common & Link
  UniversityCareerEntity? _selectedCareer;
  final _locationController = TextEditingController(text: 'Tuxtla Gutiérrez, Chiapas');
  final _costController = TextEditingController();
  final _datesController = TextEditingController(text: 'Mayo - Junio 2026');
  String _modality = 'Presencial';
  bool _scholarshipAvailable = true;

  // Form Fields - Custom Career
  final _customNameController = TextEditingController();
  final _customDescController = TextEditingController();
  String _selectedCategoryId = '31cc2380-6bc8-4df0-88cb-cfff09a74e43'; // Default CÁLCULO E INGENIERÍA

  static const Map<String, String> _categories = {
    '31cc2380-6bc8-4df0-88cb-cfff09a74e43': 'CÁLCULO E INGENIERÍA',
    'd3d22f38-75b9-410f-a0a3-7f6d19382ec1': 'CIENTÍFICO BIOLÓGICO',
    'b4a20401-381c-499d-a5f1-8040f2fe0707': 'CIENTÍFICO FÍSICO',
    'e1622e0c-7af4-43c4-9ffe-fa5d4777fac1': 'ARTÍSTICO Y DISEÑO',
    '0ab8c1f4-dd62-42fd-8b4d-bd63b593ff4a': 'LITERARIO Y HUMANIDADES',
    'afbef1b0-b9c9-4823-b46c-fd4d54e1a07d': 'MECÁNICO Y TECNOLÓGICO',
    '02c894cc-f06d-43f8-9f93-a5fa696a39a3': 'MUSICAL',
    'c2a310f3-1921-479c-8a29-79783fd28b72': 'PERSUASIVO Y NEGOCIOS',
    '76349fca-ae7e-4d33-8362-d371393a50d1': 'SERVICIO SOCIAL Y SALUD',
  };

  @override
  void dispose() {
    _locationController.dispose();
    _costController.dispose();
    _datesController.dispose();
    _customNameController.dispose();
    _customDescController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final double cost = double.tryParse(_costController.text.trim()) ?? 0.0;

    try {
      if (_modeIndex == 0) {
        // Modo 1: Vincular carrera existente
        if (_selectedCareer == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, selecciona una carrera del catálogo.')),
          );
          return;
        }

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

        await widget.provider.addCareer(careerToSave);
      } else {
        // Modo 2: Crear carrera personalizada exclusiva
        await widget.provider.createCustomCareer(
          name: _customNameController.text.trim(),
          categoryId: _selectedCategoryId,
          description: _customDescController.text.trim(),
          location: _locationController.text.trim(),
          modality: _modality,
          costApprox: cost,
          scholarshipAvailable: _scholarshipAvailable,
          admissionDates: _datesController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_modeIndex == 0 ? 'Carrera asociada exitosamente.' : 'Carrera propia registrada y vinculada.'),
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
                'Gestión de Oferta Académica',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: accentColor),
              ),
              SizedBox(height: 16.h),

              // Selector de Modo (Vincular vs Crear)
              Container(
                decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _modeIndex = 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: _modeIndex == 0 ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Catálogo Existente',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: _modeIndex == 0 ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _modeIndex = 1),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: _modeIndex == 1 ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Nueva Carrera Propia',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: _modeIndex == 1 ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              if (_modeIndex == 0) ...[
                // MODO 1: Catálogo
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
              ] else ...[
                // MODO 2: Crear Personalizada
                _buildLabel('NOMBRE DE LA CARRERA'),
                TextFormField(
                  controller: _customNameController,
                  decoration: _inputStyle('Ej. Licenciatura en Ciberseguridad'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                SizedBox(height: 16.h),
                _buildLabel('ÁREA DE CONOCIMIENTO'),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: _inputStyle('Seleccionar área...'),
                  items: _categories.entries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(e.value, style: TextStyle(fontSize: 13.sp)),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedCategoryId = v!),
                ),
                SizedBox(height: 16.h),
                _buildLabel('DESCRIPCIÓN DE LA CARRERA'),
                TextFormField(
                  controller: _customDescController,
                  maxLines: 2,
                  decoration: _inputStyle('Ej. Programa orientado a protección de infraestructuras...'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
              ],

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
                  child: Text(
                    _modeIndex == 0 ? 'Vincular Carrera' : 'Crear y Vincular Carrera',
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
    child: Text(text, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: Colors.grey[500])),
  );

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint, filled: true, fillColor: const Color(0xFFF8F9FE),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
  );
}
