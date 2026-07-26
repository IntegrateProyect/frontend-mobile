import 'dart:async';
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
  static const Color _primaryColor =
  Color(0xFF311B92);

  static const Color _darkTextColor =
  Color(0xFF1D1B4B);

  int _currentStep = 0;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;
  Uint8List? _profileImage;

  final ScrollController _scrollController =
  ScrollController();

  // =========================================================
  // INFORMACIÓN PERSONAL
  // =========================================================

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController
  _confirmPasswordController =
  TextEditingController();

  // =========================================================
  // DATOS DEL ORIENTADOR
  // =========================================================

  final TextEditingController
  _counselorAgeController =
  TextEditingController();

  final TextEditingController
  _counselorInstController =
  TextEditingController();

  final TextEditingController
  _counselorSpecController =
  TextEditingController();

  final TextEditingController
  _counselorGroupNameController =
  TextEditingController();

  final TextEditingController
  _counselorGroupCodeController =
  TextEditingController();

  bool get _isStudent =>
      _selectedRole == 'estudiante';

  bool get _isCounselor =>
      _selectedRole == 'orientador';

  bool get _isUniversity =>
      _selectedRole == 'universidad';

  bool get _isAlumni =>
      _selectedRole == 'egresado' ||
          _selectedRole == 'alumni';

  int get _totalSteps {
    /*
     * El estudiante solamente tendrá un paso:
     * crear sus datos de acceso.
     *
     * El perfil vocacional se llenará después
     * de iniciar sesión.
     */
    if (_isStudent) {
      return 1;
    }

    if (_isCounselor) {
      return 3;
    }

    return 1;
  }

  bool get _isLastStep {
    return _currentStep == _totalSteps - 1;
  }

  String get _appBarTitle {
    if (_isStudent) {
      return 'Registro Estudiante';
    }

    if (_isCounselor) {
      return 'Registro Orientador';
    }

    if (_isUniversity) {
      return 'Registro Universidad';
    }

    if (_isAlumni) {
      return 'Registro Egresado';
    }

    return 'Crea tu cuenta';
  }

  @override
  void initState() {
    super.initState();

    _selectedRole =
        widget.role.trim().toLowerCase();
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

  // =========================================================
  // MENSAJES
  // =========================================================

  void _showMessage(
      String message, {
        bool isError = true,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Colors.redAccent
            : _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            14.r,
          ),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  // =========================================================
  // SELECCIONAR FOTO
  // =========================================================

  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();

    final mediaService = sl<MediaService>();

    final bytes =
    await mediaService.pickImageFromGallery();

    if (!mounted || bytes == null) {
      return;
    }

    setState(() {
      _profileImage = bytes;
    });
  }

  // =========================================================
  // VALIDACIONES
  // =========================================================

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      final name =
      _nameController.text.trim();

      final email =
      _emailController.text.trim();

      final password =
          _passwordController.text;

      final confirmPassword =
          _confirmPasswordController.text;

      if (name.isEmpty) {
        _showMessage(
          'Ingresa tu nombre completo',
        );
        return false;
      }

      if (name.replaceAll(' ', '').length < 3) {
        _showMessage(
          'El nombre debe tener mínimo 3 letras',
        );
        return false;
      }

      final nameRegex = RegExp(
        r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$',
      );

      if (!nameRegex.hasMatch(name)) {
        _showMessage(
          'El nombre solamente puede contener letras y espacios',
        );
        return false;
      }

      if (email.isEmpty) {
        _showMessage(
          'Ingresa tu correo electrónico',
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
          'Ingresa una contraseña',
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
    }

    if (_isCounselor &&
        _currentStep == 1) {
      if (_counselorAgeController.text
          .trim()
          .isEmpty) {
        _showMessage(
          'Ingresa tu edad',
        );
        return false;
      }

      if (_counselorInstController.text
          .trim()
          .isEmpty) {
        _showMessage(
          'Ingresa tu institución',
        );
        return false;
      }

      if (_counselorSpecController.text
          .trim()
          .isEmpty) {
        _showMessage(
          'Ingresa tu especialidad',
        );
        return false;
      }
    }

    if (_isCounselor &&
        _currentStep == 2) {
      if (_counselorGroupNameController.text
          .trim()
          .isEmpty) {
        _showMessage(
          'Ingresa el nombre del grupo',
        );
        return false;
      }

      if (_counselorGroupCodeController.text
          .trim()
          .isEmpty) {
        _showMessage(
          'Ingresa el código de acceso',
        );
        return false;
      }
    }

    return true;
  }

  // =========================================================
  // REGISTRAR CUENTA
  // =========================================================

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      return;
    }

    final authProvider =
    context.read<AuthProvider>();

    Map<String, dynamic>? counselorData;

    if (_isCounselor) {
      counselorData = {
        'age': int.tryParse(
          _counselorAgeController.text.trim(),
        ) ??
            0,
        'institution':
        _counselorInstController.text.trim(),
        'specialty':
        _counselorSpecController.text.trim(),
        'group': {
          'name':
          _counselorGroupNameController.text
              .trim(),
          'accessCode':
          _counselorGroupCodeController.text
              .trim(),
        },
      };
    }

    final success =
    await authProvider.register(
      email: _emailController.text
          .trim()
          .toLowerCase(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole ?? 'estudiante',

      /*
       * El usuario aceptó los términos desde
       * la pantalla de selección de rol.
       */
      privacyAccepted: true,

      profileImage: _profileImage,

      /*
       * Ya no se crea el perfil vocacional
       * durante el registro del estudiante.
       */
      studentProfile: null,
      accessCode: null,

      additionalData:
      _isCounselor ? counselorData : null,
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

    /*
     * Muestra la felicitación y espera a que
     * termine su animación.
     */
    await _showAccountCreatedDialog();

    if (!mounted) {
      return;
    }

    /*
     * El registro interno hace un login automático
     * para obtener el token. Como quieres que el
     * usuario escriba sus datos en el Login, aquí
     * cerramos esa sesión automática.
     */
    await authProvider.logout();

    if (!mounted) {
      return;
    }

    /*
     * Redirección automática al Login.
     */
    context.go(
      AppRoutes.login.path,
    );
  }

  // =========================================================
  // ALERTA DE CUENTA CREADA
  // =========================================================

  Future<void> _showAccountCreatedDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Cuenta creada',
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration:
      const Duration(milliseconds: 350),
      pageBuilder: (
          dialogContext,
          animation,
          secondaryAnimation,
          ) {
        return _AccountCreatedDialog(
          onFinished: () {
            if (Navigator.of(dialogContext)
                .canPop()) {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
      transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        final curvedAnimation =
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.75,
              end: 1,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final authProvider =
    context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: authProvider.isLoading
              ? null
              : () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });

              _scrollToTop();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          _appBarTitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_totalSteps > 1)
              _buildStepper(),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  18.h,
                  24.w,
                  20.h,
                ),
                child: _buildStepContent(),
              ),
            ),

            _buildFooter(
              authProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController.animateTo(
      0,
      duration:
      const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  // =========================================================
  // INDICADOR DE PASOS
  // =========================================================

  Widget _buildStepper() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 18.h,
        horizontal: 42.w,
      ),
      child: Row(
        children: List.generate(
          _totalSteps,
              (index) {
            final completed =
                _currentStep > index;

            final active =
                _currentStep == index;

            return Expanded(
              child: Row(
                children: [
                  _stepCircle(
                    icon: index == 0
                        ? Icons.person
                        : Icons.business,
                    completed: completed,
                    active: active,
                  ),
                  if (index <
                      _totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2.h,
                        color: completed
                            ? _primaryColor
                            : Colors.grey[200],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _stepCircle({
    required IconData icon,
    required bool completed,
    required bool active,
  }) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: completed
            ? _primaryColor
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: active || completed
              ? _primaryColor
              : Colors.grey[200]!,
          width: 2,
        ),
      ),
      child: Icon(
        completed ? Icons.check : icon,
        size: 17.sp,
        color: completed
            ? Colors.white
            : active
            ? _primaryColor
            : Colors.grey[300],
      ),
    );
  }

  // =========================================================
  // CONTENIDO DE CADA PASO
  // =========================================================

  Widget _buildStepContent() {
    if (_currentStep == 0) {
      return _buildPersonalStep();
    }

    if (_isCounselor &&
        _currentStep == 1) {
      return _buildCounselorProfileStep();
    }

    if (_isCounselor &&
        _currentStep == 2) {
      return _buildCounselorGroupStep();
    }

    return _buildPersonalStep();
  }

  // =========================================================
  // PASO PERSONAL
  // =========================================================

  Widget _buildPersonalStep() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(
                    0xFFF3F4F6,
                  ),
                  image: _profileImage != null
                      ? DecorationImage(
                    image: MemoryImage(
                      _profileImage!,
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _profileImage == null
                    ? Icon(
                  Icons.person,
                  size: 58.sp,
                  color: Colors.grey[400],
                )
                    : null,
              ),
              Positioned(
                right: -2.w,
                bottom: 4.h,
                child: Material(
                  color: _primaryColor,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: _pickImage,
                    customBorder:
                    const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(
                        10.w,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 34.h),

        Text(
          'Información personal',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: _darkTextColor,
          ),
        ),

        SizedBox(height: 26.h),

        _buildInput(
          label: 'Nombre completo *',
          hint: 'Ej. Juan Pérez',
          controller: _nameController,
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction:
          TextInputAction.next,
          capitalization:
          TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(
                r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]',
              ),
            ),
          ],
        ),

        _buildInput(
          label: 'Correo electrónico *',
          hint: 'juan@gmail.com',
          controller: _emailController,
          icon: Icons.email_outlined,
          keyboardType:
          TextInputType.emailAddress,
          textInputAction:
          TextInputAction.next,
          inputFormatters: [
            const _LowerCaseTextFormatter(),
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-z0-9@._%+\-]'),
            ),
          ],
        ),

        _buildInput(
          label: 'Contraseña *',
          hint: 'Mínimo 8 caracteres',
          controller: _passwordController,
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction:
          TextInputAction.next,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword =
              !_obscurePassword;
            });
          },
        ),

        _buildInput(
          label: 'Confirmar contraseña *',
          hint: 'Repite tu contraseña',
          controller:
          _confirmPasswordController,
          icon: Icons.lock_reset,
          obscureText:
          _obscureConfirmPassword,
          textInputAction:
          TextInputAction.done,
          onSubmitted: (_) {
            if (_isLastStep) {
              _handleRegister();
            }
          },
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword =
              !_obscureConfirmPassword;
            });
          },
        ),

        Text(
          'Al crear tu cuenta, aceptas nuestros Términos de Servicio y el Aviso de Privacidad.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11.sp,
            height: 1.4,
          ),
        ),

        SizedBox(height: 8.h),
      ],
    );
  }

  // =========================================================
  // DATOS DEL ORIENTADOR
  // =========================================================

  Widget _buildCounselorProfileStep() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Datos profesionales',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: _darkTextColor,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          'Completa la información relacionada con tu trabajo como orientador.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),

        SizedBox(height: 26.h),

        _buildInput(
          label: 'Edad *',
          hint: 'Ej. 35',
          controller:
          _counselorAgeController,
          icon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
          textInputAction:
          TextInputAction.next,
        ),

        _buildInput(
          label: 'Institución *',
          hint: 'Ej. Preparatoria del Sur',
          controller:
          _counselorInstController,
          icon: Icons.business_outlined,
          textInputAction:
          TextInputAction.next,
          capitalization:
          TextCapitalization.words,
        ),

        _buildInput(
          label: 'Especialidad *',
          hint: 'Ej. Orientación vocacional',
          controller:
          _counselorSpecController,
          icon: Icons.badge_outlined,
          textInputAction:
          TextInputAction.done,
          capitalization:
          TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildCounselorGroupStep() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Crea tu primer grupo',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: _darkTextColor,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          'Podrás invitar estudiantes utilizando el código de acceso.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),

        SizedBox(height: 26.h),

        _buildInput(
          label: 'Nombre del grupo *',
          hint: 'Ej. 6.º A',
          controller:
          _counselorGroupNameController,
          icon: Icons.groups_outlined,
          textInputAction:
          TextInputAction.next,
          capitalization:
          TextCapitalization.words,
        ),

        _buildInput(
          label: 'Código de acceso *',
          hint: 'Ej. GRUPO-123',
          controller:
          _counselorGroupCodeController,
          icon: Icons.vpn_key_outlined,
          textInputAction:
          TextInputAction.done,
          capitalization:
          TextCapitalization.characters,
        ),
      ],
    );
  }

  // =========================================================
  // CAMPO DE TEXTO
  // =========================================================

  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization capitalization =
        TextCapitalization.none,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8.h),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction:
            textInputAction,
            textCapitalization:
            capitalization,
            obscureText: obscureText,
            autocorrect: false,
            enableSuggestions:
            !obscureText,
            onFieldSubmitted:
            onSubmitted,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
                size: 21.sp,
              ),
              suffixIcon:
              onToggleVisibility == null
                  ? null
                  : IconButton(
                onPressed:
                onToggleVisibility,
                icon: Icon(
                  obscureText
                      ? Icons
                      .visibility_rounded
                      : Icons
                      .visibility_off_rounded,
                  color:
                  Colors.grey[700],
                ),
              ),
              filled: true,
              fillColor:
              const Color(0xFFF9FAFB),
              contentPadding:
              EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16.r,
                ),
                borderSide:
                const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16.r,
                ),
                borderSide:
                const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  16.r,
                ),
                borderSide:
                const BorderSide(
                  color: _primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTÓN INFERIOR
  // =========================================================

  Widget _buildFooter(bool loading) {
    final buttonText = _isLastStep
        ? 'Crear cuenta'
        : 'Siguiente';

    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        14.h,
        24.w,
        20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () {
            if (_isLastStep) {
              _handleRegister();
              return;
            }

            if (_validateCurrentStep()) {
              setState(() {
                _currentStep++;
              });

              _scrollToTop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
            _primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
            _primaryColor.withOpacity(0.55),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                16.r,
              ),
            ),
          ),
          child: loading
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
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// ALERTA ANIMADA: CUENTA CREADA
// ===========================================================

class _AccountCreatedDialog
    extends StatefulWidget {
  final VoidCallback onFinished;

  const _AccountCreatedDialog({
    required this.onFinished,
  });

  @override
  State<_AccountCreatedDialog> createState() {
    return _AccountCreatedDialogState();
  }
}

class _AccountCreatedDialogState
    extends State<_AccountCreatedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _animationController;

  late final Animation<double>
  _trumpetScale;

  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(milliseconds: 900),
        );

    _trumpetScale = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.4,
            end: 1.15,
          ).chain(
            CurveTween(
              curve: Curves.easeOutBack,
            ),
          ),
          weight: 70,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.15,
            end: 1,
          ),
          weight: 30,
        ),
      ],
    ).animate(_animationController);

    _animationController.forward();

    /*
     * Se cierra automáticamente y después
     * RegisterScreen manda al Login.
     */
    _closeTimer = Timer(
      const Duration(milliseconds: 900),
      widget.onFinished,
    );
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 0.84.sw,
          padding: EdgeInsets.fromLTRB(
            24.w,
            28.h,
            24.w,
            25.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.16),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150.w,
                height: 105.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 5.w,
                      top: 12.h,
                      child: _sparkle(
                        color:
                        const Color(0xFFFFC107),
                        size: 25.sp,
                      ),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 7.h,
                      child: _sparkle(
                        color:
                        const Color(0xFFFF8A65),
                        size: 22.sp,
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      bottom: 4.h,
                      child: _sparkle(
                        color:
                        const Color(0xFF7C4DFF),
                        size: 17.sp,
                      ),
                    ),
                    Positioned(
                      right: 20.w,
                      bottom: 8.h,
                      child: _sparkle(
                        color:
                        const Color(0xFF26C6DA),
                        size: 18.sp,
                      ),
                    ),
                    ScaleTransition(
                      scale: _trumpetScale,
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration:
                        const BoxDecoration(
                          color:
                          Color(0xFFF2EFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.campaign_rounded,
                          color: const Color(
                            0xFF311B92,
                          ),
                          size: 46.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                '¡Felicidades!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                  const Color(0xFF1D1B4B),
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'Tu cuenta fue creada correctamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                'Ahora inicia sesión para completar tu perfil vocacional.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 18.h),

              SizedBox(
                width: 25.w,
                height: 25.w,
                child:
                const CircularProgressIndicator(
                  color: Color(0xFF311B92),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sparkle({
    required Color color,
    required double size,
  }) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: size,
    );
  }
}

class _LowerCaseTextFormatter extends TextInputFormatter {
  const _LowerCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final lowerCaseText = newValue.text.toLowerCase();

    return newValue.copyWith(
      text: lowerCaseText,
      selection: TextSelection.collapsed(
        offset: lowerCaseText.length,
      ),
      composing: TextRange.empty,
    );
  }
}