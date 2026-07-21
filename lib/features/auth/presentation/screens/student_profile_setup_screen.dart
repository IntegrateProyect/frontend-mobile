import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
import '../providers/auth_provider.dart';

class StudentProfileSetupScreen extends StatefulWidget {
  const StudentProfileSetupScreen({super.key});

  @override
  State<StudentProfileSetupScreen> createState() => _StudentProfileSetupScreenState();
}

class _StudentProfileSetupScreenState extends State<StudentProfileSetupScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkTextColor = Color(0xFF1D1B4B);
  static const Color _fieldBgColor = Color(0xFFF8F9FC);

  final Set<String> _likedSubjects = {};
  final Set<String> _dislikedSubjects = {};
  final Set<String> _interests = {};
  final Set<String> _skills = {};

  final TextEditingController _otherLikedController = TextEditingController();
  final TextEditingController _otherDislikedController = TextEditingController();
  final TextEditingController _otherInterestController = TextEditingController();
  final TextEditingController _otherSkillController = TextEditingController();
  final TextEditingController _groupCodeController = TextEditingController();

  double _vocationalClarity = 5;
  bool _needsScholarship = false;
  bool _studyAbroad = false;
  bool _wantsToJoinGroup = false;

  final List<String> _subjects = [
    'Matemáticas', 'Física', 'Química', 'Biología', 'Programación',
    'Español', 'Historia', 'Inglés', 'Arte', 'Edu. Física', 'Otra',
  ];

  final List<String> _interestOptions = [
    'Tecnología', 'Robótica', 'Medicina', 'Educación', 'Negocios',
    'Arte', 'Música', 'Deportes', 'Derecho', 'Psicología', 'Otra',
  ];

  final List<String> _skillOptions = [
    'Liderazgo', 'Comunicación', 'Creatividad', 'Lógica', 'Diseño', 'Otra',
  ];

  @override
  void dispose() {
    _otherLikedController.dispose();
    _otherDislikedController.dispose();
    _otherInterestController.dispose();
    _otherSkillController.dispose();
    _groupCodeController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  Map<String, dynamic> _buildProfileData() {
    List<String> processList(Set<String> set, TextEditingController ctrl) {
      final list = set.toList();
      if (set.contains('Otra')) {
        list.remove('Otra');
        final text = ctrl.text.trim();
        if (text.isNotEmpty) list.add(text);
      }
      return list;
    }
    return {
      'subjectsLiked': processList(_likedSubjects, _otherLikedController),
      'subjectsDisliked': processList(_dislikedSubjects, _otherDislikedController),
      'interests': processList(_interests, _otherInterestController),
      'skills': processList(_skills, _otherSkillController),
      'needsScholarship': _needsScholarship,
      'studyAbroad': _studyAbroad,
      'vocationalClarity': _vocationalClarity.round(),
    };
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();
    if (_likedSubjects.isEmpty || _dislikedSubjects.isEmpty || _interests.isEmpty || _skills.isEmpty) {
      _showSnack('Por favor completa todos los campos con *');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.createStudentVocationalProfile(_buildProfileData());

    if (!mounted) return;
    if (success) {
      if (_wantsToJoinGroup && _groupCodeController.text.isNotEmpty) {
        await authProvider.joinStudentGroup(_groupCodeController.text.trim());
      }
      context.go(AppRoutes.home.path);
    } else {
      _showSnack(authProvider.errorMessage ?? 'Error al guardar el perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Perfil vocacional', 
          style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: _buildBody(),
            ),
          ),
          _buildFooter(isLoading),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cuéntanos sobre ti', 
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: _darkTextColor, letterSpacing: -0.5)),
        SizedBox(height: 2.h),
        Text('Personalizaremos tu experiencia según lo que elijas.', 
          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
        SizedBox(height: 20.h),

        _buildSection(
          title: 'Materias que te gustan *',
          options: _subjects,
          selectedSet: _likedSubjects,
          disabledSet: _dislikedSubjects,
          onToggle: (opt, val) {
            setState(() {
              if (val) _likedSubjects.add(opt);
              else {
                _likedSubjects.remove(opt);
                if (opt == 'Otra') _otherLikedController.clear();
              }
            });
          },
          otherController: _otherLikedController,
          otherHint: '¿Qué otra materia te gusta?',
        ),

        _buildSection(
          title: 'Materias que no te gustan *',
          options: _subjects,
          selectedSet: _dislikedSubjects,
          disabledSet: _likedSubjects,
          onToggle: (opt, val) {
            setState(() {
              if (val) _dislikedSubjects.add(opt);
              else {
                _dislikedSubjects.remove(opt);
                if (opt == 'Otra') _otherDislikedController.clear();
              }
            });
          },
          otherController: _otherDislikedController,
          otherHint: '¿Qué otra materia no te gusta?',
        ),

        _buildSection(
          title: 'Áreas que te interesan *',
          options: _interestOptions,
          selectedSet: _interests,
          onToggle: (opt, val) {
            setState(() {
              if (val) _interests.add(opt);
              else {
                _interests.remove(opt);
                if (opt == 'Otra') _otherInterestController.clear();
              }
            });
          },
          otherController: _otherInterestController,
          otherHint: 'Especifica qué otra área...',
        ),

        _buildSection(
          title: 'Tus habilidades *',
          options: _skillOptions,
          selectedSet: _skills,
          onToggle: (opt, val) {
            setState(() {
              if (val) _skills.add(opt);
              else {
                _skills.remove(opt);
                if (opt == 'Otra') _otherSkillController.clear();
              }
            });
          },
          otherController: _otherSkillController,
          otherHint: 'Especifica qué otra habilidad...',
        ),

        Row(
          children: [
            Expanded(child: _buildCompactBinary(title: '¿Necesitas beca?', value: _needsScholarship, onChanged: (v) => setState(() => _needsScholarship = v))),
            SizedBox(width: 10.w),
            Expanded(child: _buildCompactBinary(title: '¿Ir al extranjero?', value: _studyAbroad, onChanged: (v) => setState(() => _studyAbroad = v))),
          ],
        ),

        SizedBox(height: 20.h),
        _buildSliderSection(),
        SizedBox(height: 20.h),
        _buildGroupInput(),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> options,
    required Set<String> selectedSet,
    Set<String>? disabledSet,
    required void Function(String, bool) onToggle,
    required TextEditingController otherController,
    required String otherHint,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: _darkTextColor)),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: options.map((opt) {
              final isSel = selectedSet.contains(opt);
              final isDisabled = opt != 'Otra' && (disabledSet?.contains(opt) ?? false);

              return FilterChip(
                label: Text(opt),
                selected: isSel,
                onSelected: isDisabled ? null : (v) => onToggle(opt, v),
                selectedColor: const Color(0xFFE9E3FF),
                checkmarkColor: _primaryColor,
                labelStyle: TextStyle(
                  fontSize: 11.sp,
                  color: isDisabled 
                      ? Colors.grey.shade400 
                      : (isSel ? _primaryColor : Colors.black87),
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                side: BorderSide(
                  color: isDisabled 
                      ? Colors.grey.shade200 
                      : (isSel ? _primaryColor : const Color(0xFFDEDFE5)),
                ),
                backgroundColor: isDisabled ? Colors.grey.shade100 : const Color(0xFFFAFAFC),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          if (selectedSet.contains('Otra')) ...[
            SizedBox(height: 10.h),
            TextFormField(
              controller: otherController,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: otherHint,
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                filled: true,
                fillColor: _fieldBgColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: _primaryColor, width: 1.2)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactBinary({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: _darkTextColor)),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BinaryButton(label: 'Sí', isSelected: value, onTap: () => onChanged(true)),
              _BinaryButton(label: 'No', isSelected: !value, onTap: () => onChanged(false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué tan clara tienes tu carrera? *', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
        Slider(
          value: _vocationalClarity,
          min: 1, max: 10, divisions: 9,
          activeColor: _primaryColor,
          onChanged: (v) => setState(() => _vocationalClarity = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nada', style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
            Text('${_vocationalClarity.round()}/10', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor, fontSize: 12.sp)),
            Text('Muy claro', style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupInput() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.group_add_outlined, color: _primaryColor, size: 20),
              SizedBox(width: 8.w),
              const Expanded(child: Text('¿Tienes código de grupo?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
              Switch.adaptive(value: _wantsToJoinGroup, onChanged: (v) => setState(() => _wantsToJoinGroup = v)),
            ],
          ),
          if (_wantsToJoinGroup) ...[
            SizedBox(height: 8.h),
            TextFormField(
              controller: _groupCodeController,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(hintText: 'Ej: GRUPO-2024', contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Color(0xFFE2E3E8)))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(bool isLoading) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))]),
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(48.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          elevation: 0,
        ),
        child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Guardar perfil y entrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
      ),
    );
  }
}

class _BinaryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BinaryButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF311B92) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? const Color(0xFF311B92) : const Color(0xFFDEDFE5)),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
