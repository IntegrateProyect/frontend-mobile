import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
import '../providers/auth_provider.dart';

class StudentProfileSetupScreen extends StatefulWidget {
  const StudentProfileSetupScreen({
    super.key,
  });

  @override
  State<StudentProfileSetupScreen> createState() {
    return _StudentProfileSetupScreenState();
  }
}

class _StudentProfileSetupScreenState
    extends State<StudentProfileSetupScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkTextColor = Color(0xFF1D1B4B);
  static const Color _fieldColor = Color(0xFFF8F9FC);

  final Set<String> _likedSubjects = {};
  final Set<String> _dislikedSubjects = {};
  final Set<String> _interests = {};
  final Set<String> _skills = {};

  final TextEditingController _groupCodeController =
  TextEditingController();

  bool _needsScholarship = false;
  bool _studyAbroad = false;
  bool _wantsToJoinGroup = false;

  double _vocationalClarity = 5;

  final List<String> _subjects = [
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

  final List<String> _interestOptions = [
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

  final List<String> _skillOptions = [
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

  @override
  void dispose() {
    _groupCodeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  bool _validateProfile() {
    if (_likedSubjects.isEmpty) {
      _showMessage(
        'Selecciona al menos una materia que te gusta',
      );
      return false;
    }

    if (_dislikedSubjects.isEmpty) {
      _showMessage(
        'Selecciona al menos una materia que no te gusta',
      );
      return false;
    }

    if (_interests.isEmpty) {
      _showMessage(
        'Selecciona al menos un área que te interesa',
      );
      return false;
    }

    if (_skills.isEmpty) {
      _showMessage(
        'Selecciona al menos una habilidad',
      );
      return false;
    }

    if (_wantsToJoinGroup) {
      final code = _groupCodeController.text.trim();

      if (code.isEmpty) {
        _showMessage(
          'Escribe el código del grupo o desactiva la opción',
        );
        return false;
      }

      if (code.length < 4) {
        _showMessage(
          'El código debe tener mínimo 4 caracteres',
        );
        return false;
      }

      final validCode = RegExp(
        r'^[a-zA-Z0-9\-_]+$',
      ).hasMatch(code);

      if (!validCode) {
        _showMessage(
          'El código contiene caracteres no permitidos',
        );
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic> _buildProfileData() {
    return {
      'subjectsLiked': _likedSubjects.toList(),
      'subjectsDisliked': _dislikedSubjects.toList(),
      'interests': _interests.toList(),
      'skills': _skills.toList(),
      'needsScholarship': _needsScholarship,
      'studyAbroad': _studyAbroad,
      'vocationalClarity': _vocationalClarity.round(),
    };
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_validateProfile()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    /*
     * Primero se crea el perfil vocacional.
     */
    final profileCreated =
    await authProvider.createStudentVocationalProfile(
      _buildProfileData(),
    );

    if (!mounted) {
      return;
    }

    /*
     * Si falla la creación del perfil, no se permite
     * entrar al Home porque el perfil es obligatorio.
     */
    if (!profileCreated) {
      _showMessage(
        authProvider.errorMessage ??
            'No fue posible guardar el perfil vocacional',
      );
      return;
    }

    /*
     * Unirse al grupo es opcional.
     *
     * Si el código falla, no se bloquea el acceso porque
     * el perfil vocacional ya se guardó correctamente.
     * El estudiante podrá intentarlo después desde el Home.
     */
    if (_wantsToJoinGroup) {
      await authProvider.joinStudentGroup(
        _groupCodeController.text.trim(),
      );

      if (!mounted) {
        return;
      }
    }

    /*
     * No se muestra ninguna alerta de éxito.
     * Se envía directamente al Home del estudiante.
     */
    context.go(
      AppRoutes.home.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          title: Text(
            'Perfil vocacional',
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
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  24.h,
                  24.w,
                  32.h,
                ),
                child: _buildProfileContent(),
              ),
            ),
            _buildBottomButton(
              authProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuéntanos sobre ti',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            color: _darkTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Esta información nos ayudará a personalizar tus actividades y recomendaciones.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        SizedBox(height: 32.h),

        _buildMultiSelect(
          title: 'Materias que te gustan *',
          options: _subjects,
          selectedOptions: _likedSubjects,
          oppositeSelection: _dislikedSubjects,
        ),

        _buildMultiSelect(
          title: 'Materias que no te gustan *',
          options: _subjects,
          selectedOptions: _dislikedSubjects,
          oppositeSelection: _likedSubjects,
        ),

        _buildMultiSelect(
          title: 'Áreas que te interesan *',
          options: _interestOptions,
          selectedOptions: _interests,
        ),

        _buildMultiSelect(
          title: '¿Cuáles son tus habilidades? *',
          options: _skillOptions,
          selectedOptions: _skills,
        ),

        _buildYesNoOption(
          title: '¿Necesitas apoyo mediante una beca?',
          currentValue: _needsScholarship,
          onChanged: (value) {
            setState(() {
              _needsScholarship = value;
            });
          },
        ),

        SizedBox(height: 18.h),

        _buildYesNoOption(
          title: '¿Te gustaría estudiar en el extranjero?',
          currentValue: _studyAbroad,
          onChanged: (value) {
            setState(() {
              _studyAbroad = value;
            });
          },
        ),

        SizedBox(height: 28.h),

        _buildVocationalClarity(),

        SizedBox(height: 32.h),

        _buildOptionalGroupCard(),
      ],
    );
  }

  Widget _buildMultiSelect({
    required String title,
    required List<String> options,
    required Set<String> selectedOptions,
    Set<String>? oppositeSelection,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 11.h,
            children: options.map((option) {
              final selected =
              selectedOptions.contains(option);

              return FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: selected
                        ? _primaryColor
                        : Colors.grey[800],
                  ),
                ),
                selected: selected,
                showCheckmark: true,
                checkmarkColor: _primaryColor,
                selectedColor: const Color(0xFFE9E3FF),
                backgroundColor: const Color(0xFFFAFAFC),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 7.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                side: BorderSide(
                  color: selected
                      ? _primaryColor
                      : const Color(0xFFDEDFE5),
                  width: selected ? 1.3 : 1,
                ),
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      selectedOptions.add(option);

                      /*
                       * Evita que la misma materia esté
                       * seleccionada en gustos y disgustos.
                       */
                      oppositeSelection?.remove(option);
                    } else {
                      selectedOptions.remove(option);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoOption({
    required String title,
    required bool currentValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: currentValue,
                activeColor: _primaryColor,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              const Text('Sí'),
              SizedBox(width: 24.w),
              Radio<bool>(
                value: false,
                groupValue: currentValue,
                activeColor: _primaryColor,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
              const Text('No'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVocationalClarity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué tan claro tienes qué carrera estudiar? *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: _fieldColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            children: [
              Slider(
                value: _vocationalClarity,
                min: 1,
                max: 10,
                divisions: 9,
                label: _vocationalClarity
                    .round()
                    .toString(),
                activeColor: _primaryColor,
                inactiveColor:
                const Color(0xFFDAD6F2),
                onChanged: (value) {
                  setState(() {
                    _vocationalClarity = value;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nada claro',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 13.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius:
                        BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${_vocationalClarity.round()}/10',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Muy claro',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionalGroupCard() {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: _wantsToJoinGroup
            ? const Color(0xFFF3F0FF)
            : _fieldColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _wantsToJoinGroup
              ? _primaryColor
              : const Color(0xFFE2E3E8),
          width: _wantsToJoinGroup ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.group_add_rounded,
                  color: Colors.white,
                  size: 29.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unirme a un grupo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: _darkTextColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Opcional',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _wantsToJoinGroup,
                activeColor: _primaryColor,
                onChanged: (value) {
                  setState(() {
                    _wantsToJoinGroup = value;

                    if (!value) {
                      _groupCodeController.clear();
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _wantsToJoinGroup
                  ? 'Escribe el código que te proporcionó tu orientador.'
                  : 'Si todavía no tienes el código, podrás unirte más adelante desde la pantalla de inicio.',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
          if (_wantsToJoinGroup) ...[
            SizedBox(height: 18.h),
            TextFormField(
              controller: _groupCodeController,
              textCapitalization:
              TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9\-_]'),
                ),
              ],
              decoration: InputDecoration(
                hintText: 'Ej. GRUPO-2026',
                prefixIcon: const Icon(
                  Icons.vpn_key_outlined,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E8),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: _primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButton(bool isLoading) {
    final buttonText = _wantsToJoinGroup
        ? 'Guardar perfil y unirme'
        : 'Guardar perfil y entrar';

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
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
              _primaryColor.withOpacity(0.55),
              minimumSize: Size.fromHeight(58.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              buttonText,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}