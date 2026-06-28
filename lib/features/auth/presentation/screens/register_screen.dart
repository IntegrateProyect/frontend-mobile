import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({
    super.key,
    this.role = 'student',
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

  final ScrollController _scrollController = ScrollController();
  late ConfettiController _confettiController;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _ageController = TextEditingController();
  final _schoolController = TextEditingController();
  final _specialtyController = TextEditingController();

  final _groupCodeController = TextEditingController();
  final _groupNameController = TextEditingController();

  final Set<String> _likes = {};
  final Set<String> _dislikes = {};
  final Set<String> _interests = {};
  final Set<String> _skills = {};

  bool _needsScholarship = false;
  bool _studyAbroad = false;
  double _careerCertainty = 5.0;

  final List<String> _subjectsList = [
    'Matemáticas',
    'Física',
    'Química',
    'Biología',
    'Programación',
    'Español',
    'Historia',
    'Inglés',
    'Arte',
    'Educación Física',
    'Otra',
  ];

  final List<String> _areasList = [
    'Tecnología',
    'Robótica',
    'Medicina',
    'Educación',
    'Negocios',
    'Arte',
    'Música',
    'Deportes',
    'Derecho',
    'Psicología',
    'Comunicación',
    'Medio ambiente',
    'Investigación',
    'Otra',
  ];

  final List<String> _skillsList = [
    'Liderazgo',
    'Comunicación',
    'Creatividad',
    'Pensamiento lógico',
    'Resolución de problemas',
    'Trabajo en equipo',
    'Organización',
    'Programación',
    'Diseño',
    'Investigación',
    'Empatía',
    'Otra',
  ];

  bool get _isStudent =>
      _selectedRole == 'student' || _selectedRole == 'estudiante';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _schoolController.dispose();
    _specialtyController.dispose();
    _groupCodeController.dispose();
    _groupNameController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF311B92),
      ),
    );
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (name.isEmpty) {
        _showMessage('El nombre completo es obligatorio');
        return false;
      }

      if (name.length < 3) {
        _showMessage('El nombre debe tener mínimo 3 letras');
        return false;
      }

      if (!nameRegex.hasMatch(name)) {
        _showMessage(
          'El nombre solo debe contener letras, no números ni caracteres especiales',
        );
        return false;
      }

      if (email.isEmpty) {
        _showMessage('El correo electrónico es obligatorio');
        return false;
      }

      if (!emailRegex.hasMatch(email)) {
        _showMessage('Ingresa un correo válido. Ejemplo: usuario@correo.com');
        return false;
      }

      if (password.isEmpty) {
        _showMessage('La contraseña es obligatoria');
        return false;
      }

      if (password.length < 8) {
        _showMessage('La contraseña debe tener mínimo 8 caracteres');
        return false;
      }

      if (confirmPassword.isEmpty) {
        _showMessage('Confirma tu contraseña');
        return false;
      }

      if (password != confirmPassword) {
        _showMessage('Las contraseñas no coinciden');
        return false;
      }

      if (!_acceptTerms) {
        _showMessage('Debes aceptar los términos y condiciones');
        return false;
      }
    }

    if (_isStudent && _currentStep == 1) {
      if (_likes.isEmpty) {
        _showMessage('Selecciona al menos una materia que te gusta');
        return false;
      }

      if (_dislikes.isEmpty) {
        _showMessage('Selecciona al menos una materia que no te gusta');
        return false;
      }

      if (_interests.isEmpty) {
        _showMessage('Selecciona al menos un área de interés');
        return false;
      }

      if (_skills.isEmpty) {
        _showMessage('Selecciona al menos una habilidad');
        return false;
      }
    }

    if (_isStudent && _currentStep == 2) {
      final code = _groupCodeController.text.trim();

      if (code.isEmpty) {
        _showMessage('Ingresa el código del grupo');
        return false;
      }

      if (code.length < 4) {
        _showMessage('El código del grupo debe tener mínimo 4 caracteres');
        return false;
      }

      if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(code)) {
        _showMessage(
          'El código solo puede tener letras, números, guion o guion bajo',
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateCurrentStep()) return;

    final authProvider = context.read<AuthProvider>();
    final router = GoRouter.of(context);

    final String mappedRole = _isStudent ? 'estudiante' : 'orientador';

    final Map<String, dynamic> studentProfile = {
      'subjectsLiked': _likes.map((e) => e.toString()).toList(),
      'subjectsDisliked': _dislikes.map((e) => e.toString()).toList(),
      'interests': _interests.map((e) => e.toString()).toList(),
      'skills': _skills.map((e) => e.toString()).toList(),
      'needsScholarship': _needsScholarship,
      'studyAbroad': _studyAbroad,
      'vocationalClarity': _careerCertainty.round().clamp(1, 10),
    };

    final Map<String, dynamic> counselorData = {
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'institution': _schoolController.text.trim(),
      'specialty': _specialtyController.text.trim(),
      'group': {
        'name': _groupNameController.text.trim().isEmpty
            ? 'Mi Grupo'
            : _groupNameController.text.trim(),
        'accessCode': _groupCodeController.text.trim(),
      },
    };

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      role: mappedRole,
      studentProfile: _isStudent ? studentProfile : null,
      accessCode: _isStudent ? _groupCodeController.text.trim() : null,
      additionalData: _isStudent ? null : counselorData,
    );

    if (success && mounted) {
      _confettiController.play();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280.w,
                padding: EdgeInsets.symmetric(
                  vertical: 40.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.celebration,
                      color: const Color(0xFFFFD700),
                      size: 100.sp,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Cuenta creada',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24.sp,
                        color: const Color(0xFF1D1B4B),
                      ),
                    ),
                  ],
                ),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.amber,
                  Colors.orange,
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                ],
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        router.go('/login');
      }
    } else if (mounted) {
      _showMessage(authProvider.errorMessage ?? 'Error al registrar');
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _scrollToTop();
    } else {
      _handleRegister();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _scrollToTop();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _previousStep,
        ),
        title: Text(
          _isStudent ? 'Registro Estudiante' : 'Registro Orientador',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
            child: Row(
              children: [
                _buildStepCircle(icon: Icons.person, step: 0),
                _buildStepLine(step: 0),
                _buildStepCircle(
                  icon: _isStudent ? Icons.psychology : Icons.work,
                  step: 1,
                ),
                _buildStepLine(step: 1),
                _buildStepCircle(
                  icon: _isStudent ? Icons.groups : Icons.group_add,
                  step: 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildCurrentStepContent(),
            ),
          ),
          _buildBottomAction(authProvider.isLoading),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 0) return _buildStepAccount();

    if (_isStudent) {
      return _currentStep == 1
          ? _buildStepVocationalProfile()
          : _buildStepJoinGroup();
    }

    return _currentStep == 1
        ? _buildStepCounselorProfile()
        : _buildStepInitialGroup();
  }

  Widget _buildStepAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 8.h),
        const Text(
          'Información personal',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Nombre completo *',
          hint: 'Ej. Juan Pérez',
          icon: Icons.person_outline,
          controller: _nameController,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]"),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Correo electrónico *',
          hint: 'juan@gmail.com',
          icon: Icons.email_outlined,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Contraseña *',
          hint: 'Mínimo 8 caracteres',
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
          isObs: _obscurePassword,
          onToggleObs: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Confirmar contraseña *',
          hint: 'Repite tu contraseña',
          icon: Icons.lock_reset,
          isPassword: true,
          controller: _confirmPasswordController,
          isObs: _obscureConfirmPassword,
          onToggleObs: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (v) {
                setState(() => _acceptTerms = v ?? false);
              },
              activeColor: const Color(0xFF311B92),
            ),
            const Expanded(
              child: Text('Acepto los términos y condiciones'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepVocationalProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cuéntanos sobre ti',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 24.h),
        _buildMultiSelect('Materias que te gustan *', _subjectsList, _likes),
        _buildMultiSelect(
          'Materias que no te gustan *',
          _subjectsList,
          _dislikes,
        ),
        _buildMultiSelect(
          '¿Qué áreas te interesan? *',
          _areasList,
          _interests,
        ),
        _buildMultiSelect(
          '¿Cuáles consideras que son tus habilidades? *',
          _skillsList,
          _skills,
        ),
        SizedBox(height: 16.h),
        _buildRadioOption(
          '¿Necesitas apoyo mediante una beca? *',
          _needsScholarship,
              (v) => setState(() => _needsScholarship = v),
        ),
        SizedBox(height: 16.h),
        _buildRadioOption(
          '¿Te gustaría estudiar en el extranjero? *',
          _studyAbroad,
              (v) => setState(() => _studyAbroad = v),
        ),
        SizedBox(height: 24.h),
        Text(
          '¿Qué tan claro tienes qué carrera estudiar? *',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        Slider(
          value: _careerCertainty,
          min: 1,
          max: 10,
          divisions: 9,
          label: _careerCertainty.round().toString(),
          activeColor: const Color(0xFF311B92),
          onChanged: (v) {
            setState(() => _careerCertainty = v);
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nada claro', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Muy claro', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildStepJoinGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unirse a un grupo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 8.h),
        const Text(
          'Ingresa el código que te dio tu orientador.',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Código del grupo *',
          hint: 'Ej. INV-69941',
          icon: Icons.qr_code,
          controller: _groupCodeController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_]')),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCounselorProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perfil profesional',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Edad',
          hint: 'Ej. 35',
          icon: Icons.calendar_today,
          controller: _ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Institución',
          hint: 'Ej. Prepa Sur',
          icon: Icons.business,
          controller: _schoolController,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Especialidad / Cargo',
          hint: 'Ej. Psicólogo Educativo',
          icon: Icons.badge,
          controller: _specialtyController,
        ),
      ],
    );
  }

  Widget _buildStepInitialGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear mi primer grupo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B4B),
          ),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Nombre del grupo',
          hint: 'Ej. 6to Semestre A',
          icon: Icons.groups,
          controller: _groupNameController,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          label: 'Código de acceso inicial',
          hint: 'Ej. GRUPO-2024',
          icon: Icons.vpn_key,
          controller: _groupCodeController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_]')),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObs = false,
    VoidCallback? onToggleObs,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword && isObs,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(isObs ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggleObs,
            )
                : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF311B92), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelect(
      String title,
      List<String> options,
      Set<String> selection,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((opt) {
            return FilterChip(
              label: Text(opt, style: TextStyle(fontSize: 11.sp)),
              selected: selection.contains(opt),
              onSelected: (v) {
                setState(() {
                  if (v) {
                    selection.add(opt);
                  } else {
                    selection.remove(opt);
                  }
                });
              },
              selectedColor: const Color(0xFF311B92).withOpacity(0.2),
              checkmarkColor: const Color(0xFF311B92),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildRadioOption(
      String title,
      bool current,
      Function(bool) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: current,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: const Color(0xFF311B92),
            ),
            const Text('Sí'),
            const SizedBox(width: 20),
            Radio<bool>(
              value: false,
              groupValue: current,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: const Color(0xFF311B92),
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomAction(bool isLoading) {
    String buttonText = 'Siguiente';

    if (_currentStep == 2) {
      buttonText = _isStudent ? 'Crear cuenta y unirme' : 'Finalizar registro';
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF311B92),
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(buttonText),
      ),
    );
  }

  Widget _buildStepCircle({
    required IconData icon,
    required int step,
  }) {
    final bool done = _currentStep > step;
    final bool active = _currentStep == step;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: done ? const Color(0xFF311B92) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: active || done ? const Color(0xFF311B92) : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Icon(
        done ? Icons.check : icon,
        size: 18,
        color: done
            ? Colors.white
            : active
            ? const Color(0xFF311B92)
            : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepLine({required int step}) {
    return Expanded(
      child: Container(
        height: 2,
        color: _currentStep > step
            ? const Color(0xFF311B92)
            : Colors.grey[200],
      ),
    );
  }
}