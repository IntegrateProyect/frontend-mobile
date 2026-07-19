import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../core/utils/media_service.dart';
import '../providers/auth_provider.dart';

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
  static const Color _fieldColor = Color(0xFFF8F9FC);

  int _currentStep = 0;

  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Uint8List? _profileImage;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final TextEditingController _ageController =
  TextEditingController();

  final TextEditingController _schoolController =
  TextEditingController();

  final TextEditingController _specialtyController =
  TextEditingController();

  final TextEditingController _groupNameController =
  TextEditingController();

  final TextEditingController _groupCodeController =
  TextEditingController();

  String get _normalizedRole {
    final role = widget.role.trim().toLowerCase();

    if (role == 'student') {
      return 'estudiante';
    }

    if (role == 'counselor') {
      return 'orientador';
    }

    if (role == 'university') {
      return 'universidad';
    }

    return role;
  }

  bool get _isStudent {
    return _normalizedRole == 'estudiante';
  }

  bool get _isSingleStepRole {
    return _normalizedRole == 'estudiante' ||
        _normalizedRole == 'universidad' ||
        _normalizedRole == 'alumni' ||
        _normalizedRole == 'egresado';
  }

  String get _roleTitle {
    if (_normalizedRole == 'estudiante') return 'Registro Estudiante';
    if (_normalizedRole == 'orientador') return 'Registro Orientador';
    if (_normalizedRole == 'universidad') return 'Registro Universidad';
    if (_normalizedRole == 'alumni') return 'Registro Egresado';
    return 'Registro';
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

    _groupNameController.dispose();
    _groupCodeController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showMessage(
      String message, {
        bool isError = true,
      }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.redAccent : _primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final mediaService = sl<MediaService>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: _primaryColor,
                  ),
                  title: const Text(
                    'Elegir desde galería',
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    final bytes = await mediaService
                        .pickImageFromGallery();

                    if (bytes != null && mounted) {
                      setState(() {
                        _profileImage = bytes;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: _primaryColor,
                  ),
                  title: const Text(
                    'Tomar una fotografía',
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    final bytes =
                    await mediaService.takePhoto();

                    if (bytes != null && mounted) {
                      setState(() {
                        _profileImage = bytes;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validateAccountStep() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword =
        _confirmPasswordController.text;

    if (name.isEmpty) {
      _showMessage(
        'Escribe tu nombre completo',
      );
      return false;
    }

    if (name.length < 3) {
      _showMessage(
        'El nombre debe tener mínimo 3 letras',
      );
      return false;
    }

    final nameRegex = RegExp(
      r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\-\']+$",
    );

    if (!nameRegex.hasMatch(name)) {
      _showMessage(
        'El nombre contiene caracteres no permitidos',
      );
      return false;
    }

    if (email.isEmpty) {
      _showMessage(
        'Escribe tu correo electrónico',
      );
      return false;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      _showMessage(
        'Ingresa un correo electrónico válido',
      );
      return false;
    }

    if (password.isEmpty) {
      _showMessage(
        'Escribe una contraseña',
      );
      return false;
    }

    if (password.length < 8) {
      _showMessage(
        'La contraseña debe tener mínimo 8 caracteres',
      );
      return false;
    }

    if (confirmPassword.isEmpty) {
      _showMessage(
        'Confirma tu contraseña',
      );
      return false;
    }

    if (password != confirmPassword) {
      _showMessage(
        'Las contraseñas no coinciden',
      );
      return false;
    }

    if (!_acceptTerms) {
      _showMessage(
        'Debes aceptar el aviso de privacidad',
      );
      return false;
    }

    return true;
  }

  bool _validateCounselorProfile() {
    if (_schoolController.text.trim().isEmpty) {
      _showMessage(
        'Escribe la institución del orientador',
      );
      return false;
    }

    if (_specialtyController.text.trim().isEmpty) {
      _showMessage(
        'Escribe la especialidad o cargo',
      );
      return false;
    }

    return true;
  }

  Map<String, dynamic> _buildCounselorData() {
    final groupName = _groupNameController.text.trim();
    final groupCode = _groupCodeController.text.trim();

    return {
      'age': int.tryParse(
        _ageController.text.trim(),
      ) ??
          0,
      'institution': _schoolController.text.trim(),
      'specialty': _specialtyController.text.trim(),
      'group': {
        'name': groupName.isEmpty
            ? 'Mi Grupo'
            : groupName,
        'accessCode': groupCode,
      },
    };
  }

  Future<void> _registerStudentAccount() async {
    FocusScope.of(context).unfocus();

    if (!_validateAccountStep()) {
      return;
    }

    final authProvider =
    context.read<AuthProvider>();

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _normalizedRole,
      privacyAccepted: _acceptTerms,
      profileImage: _profileImage,
      studentProfile: null,
      accessCode: null,
      additionalData: null,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      _showMessage(
        authProvider.errorMessage ??
            'No fue posible crear la cuenta',
      );
      return;
    }

    await _showStudentRegistrationSuccess();

    await authProvider.logout();

    if (mounted) {
      context.go(
        AppRoutes.login.path,
      );
    }
  }

  Future<void> _registerCounselor() async {
    FocusScope.of(context).unfocus();

    final authProvider =
    context.read<AuthProvider>();

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: 'orientador',
      privacyAccepted: _acceptTerms,
      profileImage: _profileImage,
      studentProfile: null,
      accessCode: null,
      additionalData: _buildCounselorData(),
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      _showMessage(
        authProvider.errorMessage ??
            'No fue posible registrar al orientador',
      );
      return;
    }

    await _showCounselorSuccess();

    await authProvider.logout();

    if (mounted) {
      context.go(
        AppRoutes.login.path,
      );
    }
  }

  Future<void> _nextStep() async {
    FocusScope.of(context).unfocus();

    if (_isSingleStepRole) {
      await _registerStudentAccount();
      return;
    }

    if (_currentStep == 0) {
      if (!_validateAccountStep()) {
        return;
      }

      setState(() {
        _currentStep = 1;
      });

      _scrollToTop();
      return;
    }

    if (_currentStep == 1) {
      if (!_validateCounselorProfile()) {
        return;
      }

      setState(() {
        _currentStep = 2;
      });

      _scrollToTop();
      return;
    }

    await _registerCounselor();
  }

  void _previousStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _scrollToTop();
      return;
    }

    context.pop();
  }

  Future<void>
  _showStudentRegistrationSuccess() async {
    BuildContext? dialogBuildContext;

    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        dialogBuildContext = dialogContext;

        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: 48.w,
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                26.w,
                34.h,
                26.w,
                36.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  28.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.14,
                    ),
                    blurRadius: 28.r,
                    offset: Offset(0, 12.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCelebrationIcon(),
                  SizedBox(height: 20.h),
                  Text(
                    '¡Registro exitoso!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w900,
                      color: _darkTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 1900),
    );

    if (dialogBuildContext != null &&
        dialogBuildContext!.mounted) {
      Navigator.of(
        dialogBuildContext!,
        rootNavigator: true,
      ).pop();
    }

    await dialogFuture;
  }

  Widget _buildCelebrationIcon() {
    return SizedBox(
      width: 155.w,
      height: 135.h,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 110.w,
            height: 110.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF1EEFF),
              shape: BoxShape.circle,
            ),
          ),
          Transform.rotate(
            angle: -0.18,
            child: Icon(
              Icons.celebration_rounded,
              color: _primaryColor,
              size: 78.sp,
            ),
          ),
          Positioned(
            top: 4.h,
            left: 24.w,
            child: _buildColorSpark(
              color: const Color(0xFFFFC107),
              size: 13,
            ),
          ),
          Positioned(
            top: 7.h,
            right: 25.w,
            child: _buildColorSpark(
              color: const Color(0xFFFF5252),
              size: 11,
            ),
          ),
          Positioned(
            top: 43.h,
            right: 3.w,
            child: _buildColorSpark(
              color: const Color(0xFF00BFA5),
              size: 10,
            ),
          ),
          Positioned(
            bottom: 17.h,
            right: 20.w,
            child: _buildColorSpark(
              color: const Color(0xFF2196F3),
              size: 12,
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 26.w,
            child: _buildColorSpark(
              color: const Color(0xFFFF7043),
              size: 9,
            ),
          ),
          Positioned(
            top: 50.h,
            left: 3.w,
            child: _buildColorSpark(
              color: const Color(0xFFAB47BC),
              size: 11,
            ),
          ),
          Positioned(
            top: 2.h,
            right: 57.w,
            child: _buildConfettiStrip(
              color: const Color(0xFF42A5F5),
              angle: 0.6,
            ),
          ),
          Positioned(
            bottom: 6.h,
            right: 57.w,
            child: _buildConfettiStrip(
              color: const Color(0xFFFFC107),
              angle: -0.5,
            ),
          ),
          Positioned(
            top: 32.h,
            left: 27.w,
            child: _buildConfettiStrip(
              color: const Color(0xFFFF5252),
              angle: -0.8,
              width: 6,
              height: 14,
            ),
          ),
          Positioned(
            top: 21.h,
            right: 22.w,
            child: _buildConfettiStrip(
              color: const Color(0xFF66BB6A),
              angle: 0.8,
              width: 6,
              height: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSpark({
    required Color color,
    required double size,
  }) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.32),
            blurRadius: 6.r,
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiStrip({
    required Color color,
    required double angle,
    double width = 7,
    double height = 17,
  }) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            3.r,
          ),
        ),
      ),
    );
  }

  Future<void> _showCounselorSuccess() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              22.r,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: _primaryColor,
                size: 70.sp,
              ),
              SizedBox(height: 18.h),
              Text(
                '¡Registro exitoso!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: _darkTextColor,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
    context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: authProvider.isLoading
              ? null
              : _previousStep,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 27.sp,
          ),
        ),
        title: Text(
          _roleTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /*
           * El indicador superior solamente se muestra
           * para el orientador.
           *
           * En el estudiante no aparece ningún icono
           * encima de la fotografía.
           */
          if (!_isSingleStepRole)
            _buildCounselorProgressHeader(),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              padding: EdgeInsets.fromLTRB(
                24.w,
                _isSingleStepRole ? 30.h : 10.h,
                24.w,
                30.h,
              ),
              child: _buildCurrentContent(),
            ),
          ),
          _buildBottomAction(
            authProvider.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorProgressHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        48.w,
        22.h,
        48.w,
        28.h,
      ),
      child: Row(
        children: [
          _buildStepCircle(
            icon: Icons.person_rounded,
            step: 0,
          ),
          _buildStepLine(
            completed: _currentStep > 0,
          ),
          _buildStepCircle(
            icon: Icons.work_outline_rounded,
            step: 1,
          ),
          _buildStepLine(
            completed: _currentStep > 1,
          ),
          _buildStepCircle(
            icon: Icons.group_add_rounded,
            step: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentContent() {
    if (_isSingleStepRole || _currentStep == 0) {
      return _buildAccountStep();
    }

    if (_currentStep == 1) {
      return _buildCounselorProfileStep();
    }

    return _buildCounselorGroupStep();
  }

  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 53.r,
                backgroundColor:
                const Color(0xFFF1F2F6),
                backgroundImage: _profileImage != null
                    ? MemoryImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? Icon(
                  Icons.person_rounded,
                  size: 54.sp,
                  color: Colors.grey[400],
                )
                    : null,
              ),
              Positioned(
                bottom: -2.h,
                right: -4.w,
                child: Material(
                  color: _primaryColor,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: _pickImage,
                    customBorder:
                    const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(11.w),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 21.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 44.h),
        Text(
          'Información personal',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: _darkTextColor,
          ),
        ),
        SizedBox(height: 28.h),
        _buildInputField(
          label: 'Nombre completo *',
          hint: 'Ej. Juan Pérez',
          icon: Icons.person_outline_rounded,
          controller: _nameController,
          textCapitalization:
          TextCapitalization.words,
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Correo electrónico *',
          hint: 'juan@gmail.com',
          icon: Icons.email_outlined,
          controller: _emailController,
          keyboardType:
          TextInputType.emailAddress,
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Contraseña *',
          hint: 'Mínimo 8 caracteres',
          icon: Icons.lock_outline_rounded,
          controller: _passwordController,
          isPassword: true,
          obscureText: _obscurePassword,
          onTogglePassword: () {
            setState(() {
              _obscurePassword =
              !_obscurePassword;
            });
          },
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Confirmar contraseña *',
          hint: 'Repite tu contraseña',
          icon: Icons.lock_reset_rounded,
          controller:
          _confirmPasswordController,
          isPassword: true,
          obscureText:
          _obscureConfirmPassword,
          onTogglePassword: () {
            setState(() {
              _obscureConfirmPassword =
              !_obscureConfirmPassword;
            });
          },
        ),
        SizedBox(height: 22.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFC),
            borderRadius: BorderRadius.circular(
              14.r,
            ),
            border: Border.all(
              color: const Color(0xFFE7E7EC),
            ),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptTerms,
                activeColor: _primaryColor,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms =
                        value ?? false;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 11.h,
                    right: 4.w,
                  ),
                  child: Text(
                    'Acepto el aviso de privacidad y el uso de mis datos dentro de Oriéntate+.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounselorProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perfil profesional',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: _darkTextColor,
          ),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Edad',
          hint: 'Ej. 35',
          icon: Icons.calendar_today_outlined,
          controller: _ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Institución *',
          hint: 'Ej. Preparatoria Sur',
          icon: Icons.business_outlined,
          controller: _schoolController,
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Especialidad o cargo *',
          hint: 'Ej. Psicólogo educativo',
          icon: Icons.badge_outlined,
          controller: _specialtyController,
        ),
      ],
    );
  }

  Widget _buildCounselorGroupStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crear mi primer grupo',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: _darkTextColor,
          ),
        ),
        SizedBox(height: 32.h),
        _buildInputField(
          label: 'Nombre del grupo',
          hint: 'Ej. Sexto semestre A',
          icon: Icons.groups_outlined,
          controller: _groupNameController,
        ),
        SizedBox(height: 20.h),
        _buildInputField(
          label: 'Código de acceso inicial',
          hint: 'Ej. GRUPO-2026',
          icon: Icons.vpn_key_outlined,
          controller: _groupCodeController,
          textCapitalization:
          TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z0-9\-_]'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 9.h),
        TextFormField(
          controller: controller,
          obscureText:
          isPassword && obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization:
          textCapitalization,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Colors.grey[700],
              size: 22.sp,
            ),
            suffixIcon: isPassword
                ? IconButton(
              onPressed:
              onTogglePassword,
              icon: Icon(
                obscureText
                    ? Icons.visibility_rounded
                    : Icons
                    .visibility_off_rounded,
              ),
            )
                : null,
            filled: true,
            fillColor: _fieldColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 19.h,
            ),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E3E8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E3E8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: _primaryColor,
                width: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(bool isLoading) {
    final buttonText = _isSingleStepRole
        ? 'Crear cuenta'
        : _currentStep == 2
        ? 'Finalizar registro'
        : 'Siguiente';

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          24.w,
          14.h,
          24.w,
          18.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.05),
              blurRadius: 14.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
            isLoading ? null : _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size.fromHeight(57.h),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(17.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
              width: 24.w,
              height: 24.w,
              child:
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              buttonText,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle({
    required IconData icon,
    required int step,
  }) {
    final done = _currentStep > step;
    final active = _currentStep == step;

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color:
        done ? _primaryColor : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: active || done
              ? _primaryColor
              : const Color(0xFFDDDEE3),
          width: 2.2,
        ),
      ),
      child: Icon(
        done ? Icons.check_rounded : icon,
        size: 22.sp,
        color: done
            ? Colors.white
            : active
            ? _primaryColor
            : Colors.grey[350],
      ),
    );
  }

  Widget _buildStepLine({
    required bool completed,
  }) {
    return Expanded(
      child: Container(
        height: 2.5.h,
        color: completed
            ? _primaryColor
            : const Color(0xFFE7E7EB),
      ),
    );
  }
}