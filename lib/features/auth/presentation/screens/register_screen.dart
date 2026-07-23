import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../../core/utils/media_service.dart';
import '../../../../core/di/injection_container.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({
    super.key,
    this.role = 'estudiante',
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;
  Uint8List? _profileImage;

  final ScrollController _scrollController = ScrollController();

  // Paso 1: Información personal
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Paso 2: Perfil Vocacional (Solo Estudiante)
  final Set<String> _likes = {};
  final Set<String> _dislikes = {};
  final _groupCodeController = TextEditingController();

  // Paso 2 y 3: Orientador (Se mantiene intacto)
  final _counselorAgeController = TextEditingController();
  final _counselorInstController = TextEditingController();
  final _counselorSpecController = TextEditingController();
  final _counselorGroupNameController = TextEditingController();
  final _counselorGroupCodeController = TextEditingController();

  final List<String> _subjectsList = [
    'Matemáticas', 'Física', 'Química', 'Biología', 'Programación',
    'Español', 'Historia', 'Inglés', 'Arte', 'Educación Física', 'Otra',
  ];

  bool get _isStudent => _selectedRole == 'estudiante';
  bool get _isCounselor => _selectedRole == 'orientador';
  bool get _isUniversity => _selectedRole == 'universidad';
  bool get _isAlumni => _selectedRole == 'egresado';

  int get _totalSteps {
    if (_isStudent) return 2;
    if (_isCounselor) return 3;
    return 1;
  }

  bool get _isLastStep => _currentStep == _totalSteps - 1;

  String get _appBarTitle {
    switch (_selectedRole) {
      case 'estudiante':
        return 'Registro Estudiante';
      case 'orientador':
        return 'Registro Orientador';
      case 'universidad':
        return 'Registro Universidad';
      case 'egresado':
        return 'Registro Egresado';
      default:
        return 'Crea tu cuenta';
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _groupCodeController.dispose();
    _counselorAgeController.dispose();
    _counselorInstController.dispose();
    _counselorSpecController.dispose();
    _counselorGroupNameController.dispose();
    _counselorGroupCodeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF311B92),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage() async {
    final mediaService = sl<MediaService>();
    final bytes = await mediaService.pickImageFromGallery();
    if (bytes != null) setState(() => _profileImage = bytes);
  }

  bool _validateStep() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
        _showMessage('Completa los campos obligatorios');
        return false;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showMessage('Las contraseñas no coinciden');
        return false;
      }
      if (!_acceptTerms) {
        _showMessage('Debes aceptar los términos');
        return false;
      }
    } else if (_currentStep == 1 && _isStudent) {
      if (_likes.isEmpty || _dislikes.isEmpty) {
        _showMessage('Por favor selecciona tus materias');
        return false;
      }
    }
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateStep()) return;

    final authProvider = context.read<AuthProvider>();
    
    Map<String, dynamic>? studentProfile;
    if (_isStudent) {
      studentProfile = {
        'subjectsLiked': _likes.toList(),
        'subjectsDisliked': _dislikes.toList(),
        'interests': [],
        'skills': [],
        'needsScholarship': false,
        'studyAbroad': false,
        'vocationalClarity': 5,
      };
    }

    Map<String, dynamic>? counselorData;
    if (_isCounselor) {
      counselorData = {
        'age': int.tryParse(_counselorAgeController.text) ?? 0,
        'institution': _counselorInstController.text,
        'specialty': _counselorSpecController.text,
        'group': {
          'name': _counselorGroupNameController.text,
          'accessCode': _counselorGroupCodeController.text,
        }
      };
    }

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      role: _selectedRole!,
      privacyAccepted: _acceptTerms,
      profileImage: _profileImage,
      studentProfile: studentProfile,
      accessCode: _isStudent && _groupCodeController.text.isNotEmpty ? _groupCodeController.text.trim() : null,
      additionalData: _isCounselor ? counselorData : null,
    );

    if (success && mounted) {
      context.go('/login');
      _showMessage('Cuenta creada con éxito.', isError: false);
    } else if (mounted) {
      _showMessage(authProvider.errorMessage ?? 'Error al registrar');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _currentStep > 0 ? setState(() => _currentStep--) : Navigator.pop(context),
        ),
        title: Text(
          _appBarTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildStepContent(),
            ),
          ),
          _buildFooter(isLoading),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    int total = _totalSteps;
    if (total <= 1) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
      child: Row(
        children: List.generate(total, (i) {
          bool done = _currentStep > i;
          bool active = _currentStep == i;
          return Expanded(
            child: Row(
              children: [
                _stepCircle(i, i == 0 ? Icons.person : (i == 1 && _isStudent ? Icons.lightbulb_outline : Icons.business)),
                if (i < total - 1) Expanded(child: Container(height: 2, color: done ? const Color(0xFF311B92) : Colors.grey[200])),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _stepCircle(int step, IconData icon) {
    bool done = _currentStep > step;
    bool active = _currentStep == step;
    return Container(
      width: 32.w, height: 32.w,
      decoration: BoxDecoration(
        color: done ? const Color(0xFF311B92) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: active || done ? const Color(0xFF311B92) : Colors.grey[200]!, width: 2),
      ),
      child: Icon(done ? Icons.check : icon, size: 16.sp, color: done ? Colors.white : (active ? const Color(0xFF311B92) : Colors.grey[200])),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 0) return _buildPersonalStep();
    if (_isStudent) return _buildVocationalStep();
    if (_currentStep == 1) return _buildCounselorProfileStep();
    return _buildCounselorGroupStep();
  }

  // PASO 1: Información personal (Imagen 1)
  Widget _buildPersonalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 55.r,
                backgroundColor: const Color(0xFFF3F4F6),
                backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
                child: _profileImage == null ? Icon(Icons.person, size: 55.sp, color: Colors.grey[400]) : null,
              ),
              Positioned(
                bottom: 0, right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(color: Color(0xFF311B92), shape: BoxShape.circle),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        const Text('Información personal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 24.h),
        _input('Nombre completo *', 'Ej. Juan Pérez', _nameController, Icons.person_outline),
        _input('Correo electrónico *', 'juan@gmail.com', _emailController, Icons.email_outlined),
        _input('Contraseña *', 'Mínimo 8 caracteres', _passwordController, Icons.lock_outline, isPass: true, isObs: _obscurePassword, onToggle: () => setState(() => _obscurePassword = !_obscurePassword)),
        _input('Confirmar contraseña *', 'Repite tu contraseña', _confirmPasswordController, Icons.lock_reset, isPass: true, isObs: _obscureConfirmPassword, onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
        Row(
          children: [
            Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false), activeColor: const Color(0xFF311B92)),
            const Expanded(child: Text('Acepto los términos y condiciones')),
          ],
        ),
      ],
    );
  }

  // PASO 2: Perfil Vocacional (Imagen 2)
  Widget _buildVocationalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cuéntanos sobre ti', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 24.h),
        _chips('Materias que te gustan *', _subjectsList, _likes),
        _chips('Materias que no te gustan *', _subjectsList, _dislikes),
        
        const Divider(height: 40),
        
        // Sección Unirse a un grupo (Opcional) con icono "chido"
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFDDD6FE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.group_add_rounded, color: const Color(0xFF311B92), size: 24.sp),
                  SizedBox(width: 12.w),
                  Text('Unirse a un grupo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: const Color(0xFF1D1B4B))),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                    child: Text('Opcional', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text('Si tu orientador te dio un código, ingresalo aquí para vincularte.', style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
              SizedBox(height: 16.h),
              _input('Código del grupo', 'Ej. INV-69941', _groupCodeController, Icons.qr_code),
            ],
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildCounselorProfileStep() {
    return Column(children: [ _input('Edad', 'Ej. 35', _counselorAgeController, Icons.calendar_today), _input('Institución', 'Ej. Prepa Sur', _counselorInstController, Icons.business), _input('Especialidad', 'Ej. Orientación', _counselorSpecController, Icons.badge)]);
  }

  Widget _buildCounselorGroupStep() {
    return Column(children: [_input('Nombre del grupo', 'Ej. 6to A', _counselorGroupNameController, Icons.groups), _input('Código de acceso', 'Ej. GRUPO-123', _counselorGroupCodeController, Icons.vpn_key)]);
  }

  Widget _input(String l, String h, TextEditingController c, IconData i, {bool isPass = false, bool isObs = false, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: c, obscureText: isPass && isObs,
          decoration: InputDecoration(
            hintText: h, prefixIcon: Icon(i, size: 18),
            suffixIcon: isPass ? IconButton(icon: Icon(isObs ? Icons.visibility : Icons.visibility_off), onPressed: onToggle) : null,
            filled: true, fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _chips(String title, List<String> opts, Set<String> selection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w, runSpacing: 8.h,
          children: opts.map((o) {
            bool s = selection.contains(o);
            return FilterChip(
              label: Text(o, style: TextStyle(fontSize: 11.sp, color: s ? Colors.white : Colors.black87)),
              selected: s, onSelected: (v) => setState(() => v ? selection.add(o) : selection.remove(o)),
              selectedColor: const Color(0xFF311B92), checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              side: BorderSide(color: s ? const Color(0xFF311B92) : Colors.grey[300]!),
            );
          }).toList(),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildFooter(bool loading) {
    bool isLast = _isLastStep;
    return Container(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: loading ? null : () {
          if (isLast) _handleRegister();
          else if (_validateStep()) setState(() => _currentStep++);
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF311B92), foregroundColor: Colors.white, minimumSize: Size.fromHeight(56.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
        child: loading ? const CircularProgressIndicator(color: Colors.white) : Text(isLast ? 'Finalizar' : 'Siguiente'),
      ),
    );
  }
}
