import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../core/utils/media_service.dart';
import '../providers/auth_provider.dart';

import '../components/register/register_stepper.dart';
import '../components/register/register_footer.dart';
import '../components/register/account_created_dialog.dart';
import '../components/register/steps/personal_step.dart';
import '../components/register/steps/counselor_profile_step.dart';
import '../components/register/steps/counselor_group_step.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({
    super.key,
    this.role = 'estudiante',
  });

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkTextColor = Color(0xFF1D1B4B);

  int _currentStep = 0;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;
  Uint8List? _profileImage;

  final ScrollController _scrollController = ScrollController();

  // Controllers for personal information
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Controllers for counselor information
  final TextEditingController _counselorAgeController = TextEditingController();
  final TextEditingController _counselorInstController = TextEditingController();
  final TextEditingController _counselorSpecController = TextEditingController();
  final TextEditingController _counselorGroupNameController = TextEditingController();
  final TextEditingController _counselorGroupCodeController = TextEditingController();

  bool get _isStudent => _selectedRole == 'estudiante';
  bool get _isCounselor => _selectedRole == 'orientador';
  bool get _isUniversity => _selectedRole == 'universidad';
  bool get _isAlumni => _selectedRole == 'egresado' || _selectedRole == 'alumni';

  int get _totalSteps => _isCounselor ? 3 : 1;
  bool get _isLastStep => _currentStep == _totalSteps - 1;

  String get _appBarTitle {
    if (_isStudent) return 'Registro Estudiante';
    if (_isCounselor) return 'Registro Orientador';
    if (_isUniversity) return 'Registro Universidad';
    if (_isAlumni) return 'Registro Egresado';
    return 'Crea tu cuenta';
  }

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role.trim().toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _counselorAgeController.dispose();
    _counselorInstController.dispose();
    _counselorSpecController.dispose();
    _counselorGroupNameController.dispose();
    _counselorGroupCodeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();
    final mediaService = sl<MediaService>();
    final bytes = await mediaService.pickImageFromGallery();
    if (!mounted || bytes == null) return;
    setState(() => _profileImage = bytes);
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (name.isEmpty) {
        _showMessage('Ingresa tu nombre completo');
        return false;
      }
      if (name.replaceAll(' ', '').length < 3) {
        _showMessage('El nombre debe tener mínimo 3 letras');
        return false;
      }
      if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$').hasMatch(name)) {
        _showMessage('El nombre solamente puede contener letras y espacios');
        return false;
      }
      if (email.isEmpty) {
        _showMessage('Ingresa tu correo electrónico');
        return false;
      }
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        _showMessage('Ingresa un correo electrónico válido');
        return false;
      }
      if (password.isEmpty) {
        _showMessage('Ingresa una contraseña');
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
    }

    if (_isCounselor && _currentStep == 1) {
      if (_counselorAgeController.text.trim().isEmpty) {
        _showMessage('Ingresa tu edad');
        return false;
      }
      if (_counselorInstController.text.trim().isEmpty) {
        _showMessage('Ingresa tu institución');
        return false;
      }
      if (_counselorSpecController.text.trim().isEmpty) {
        _showMessage('Ingresa tu especialidad');
        return false;
      }
    }

    if (_isCounselor && _currentStep == 2) {
      if (_counselorGroupNameController.text.trim().isEmpty) {
        _showMessage('Ingresa el nombre del grupo');
        return false;
      }
      if (_counselorGroupCodeController.text.trim().isEmpty) {
        _showMessage('Ingresa el código de acceso');
        return false;
      }
    }
    return true;
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!_validateCurrentStep()) return;

    final authProvider = context.read<AuthProvider>();
    Map<String, dynamic>? counselorData;

    if (_isCounselor) {
      counselorData = {
        'age': int.tryParse(_counselorAgeController.text.trim()) ?? 0,
        'institution': _counselorInstController.text.trim(),
        'specialty': _counselorSpecController.text.trim(),
        'group': {
          'name': _counselorGroupNameController.text.trim(),
          'accessCode': _counselorGroupCodeController.text.trim(),
        },
      };
    }

    final success = await authProvider.register(
      email: _emailController.text.trim().toLowerCase(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole ?? 'estudiante',
      privacyAccepted: true,
      profileImage: _profileImage,
      studentProfile: null,
      accessCode: null,
      additionalData: _isCounselor ? counselorData : null,
    );

    if (!mounted) return;
    if (!success) {
      _showMessage(authProvider.errorMessage ?? 'No fue posible crear la cuenta');
      return;
    }

    await _showAccountCreatedDialog();
    if (!mounted) return;

    await authProvider.logout();
    if (!mounted) return;

    context.go(AppRoutes.login.path);
  }

  Future<void> _showAccountCreatedDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Cuenta creada',
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return AccountCreatedDialog(onFinished: () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: Tween<double>(begin: 0.75, end: 1).animate(curvedAnimation), child: child),
        );
      },
    );
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: authProvider.isLoading
              ? null
              : () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                    _scrollToTop();
                  } else {
                    context.pop();
                  }
                },
        ),
        title: Text(
          _appBarTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18.sp),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_totalSteps > 1) RegisterStepper(currentStep: _currentStep, totalSteps: _totalSteps, primaryColor: _primaryColor),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 20.h),
                child: _buildStepContent(),
              ),
            ),
            RegisterFooter(
              isLoading: authProvider.isLoading,
              isLastStep: _isLastStep,
              primaryColor: _primaryColor,
              onNext: () {
                if (_isLastStep) {
                  _handleRegister();
                } else if (_validateCurrentStep()) {
                  setState(() => _currentStep++);
                  _scrollToTop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 0) {
      return PersonalStep(
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        profileImage: _profileImage,
        onPickImage: _pickImage,
        obscurePassword: _obscurePassword,
        obscureConfirmPassword: _obscureConfirmPassword,
        onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
        onToggleConfirmPassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        onSubmitted: (_) {
          if (_isLastStep) _handleRegister();
        },
        primaryColor: _primaryColor,
        darkTextColor: _darkTextColor,
      );
    }
    if (_isCounselor && _currentStep == 1) {
      return CounselorProfileStep(
        ageController: _counselorAgeController,
        instController: _counselorInstController,
        specController: _counselorSpecController,
        primaryColor: _primaryColor,
        darkTextColor: _darkTextColor,
      );
    }
    if (_isCounselor && _currentStep == 2) {
      return CounselorGroupStep(
        groupNameController: _counselorGroupNameController,
        groupCodeController: _counselorGroupCodeController,
        primaryColor: _primaryColor,
        darkTextColor: _darkTextColor,
      );
    }
    return Container();
  }
}
