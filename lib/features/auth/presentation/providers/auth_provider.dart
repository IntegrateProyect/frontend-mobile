import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_avatar_usecase.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../../core/utils/media_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final IApi _api;
  final UserService _userService;
  final MediaService _mediaService;

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateAvatarUseCase updateAvatarUseCase,
    required IApi api,
    required UserService userService,
    required MediaService mediaService,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _updateAvatarUseCase = updateAvatarUseCase,
        _api = api,
        _userService = userService,
        _mediaService = mediaService;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _validateName(String name) {
    final value = name.trim();

    if (value.isEmpty) return 'El nombre completo es obligatorio';

    if (value.length < 3) {
      return 'El nombre debe tener mínimo 3 letras';
    }

    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\-\']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre contiene caracteres no permitidos';
    }

    return null;
  }

  String? _validateEmail(String email) {
    final value = email.trim();

    if (value.isEmpty) return 'El correo electrónico es obligatorio';

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido. Ejemplo: usuario@correo.com';
    }

    return null;
  }

  String? _validatePassword(String password) {
    final value = password.trim();

    if (value.isEmpty) return 'La contraseña es obligatoria';

    if (value.length < 8) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }

    return null;
  }

  String? _validateRole(String role) {
    final value = role.trim().toLowerCase();

    const validRoles = [
      'estudiante',
      'orientador',
      'universidad',
      'alumni',
      'admin',
    ];

    if (value.isEmpty) return 'Debes seleccionar un rol';

    if (!validRoles.contains(value)) {
      return 'El rol seleccionado no es válido';
    }

    return null;
  }

  String? _validateStudentProfile(Map<String, dynamic>? profile) {
    if (profile == null) {
      return 'Faltan los datos del perfil vocacional';
    }

    final subjectsLiked = profile['subjectsLiked'];
    final subjectsDisliked = profile['subjectsDisliked'];
    final interests = profile['interests'];
    final skills = profile['skills'];
    final vocationalClarity = profile['vocationalClarity'];

    if (subjectsLiked is! List || subjectsLiked.isEmpty) {
      return 'Selecciona al menos una materia que te gusta';
    }

    if (subjectsDisliked is! List || subjectsDisliked.isEmpty) {
      return 'Selecciona al menos una materia que no te gusta';
    }

    if (interests is! List || interests.isEmpty) {
      return 'Selecciona al menos un área de interés';
    }

    if (skills is! List || skills.isEmpty) {
      return 'Selecciona al menos una habilidad';
    }

    if (vocationalClarity is! int ||
        vocationalClarity < 1 ||
        vocationalClarity > 10) {
      return 'La claridad vocacional debe estar entre 1 y 10';
    }

    return null;
  }

  String? _validateGroupCode(String? accessCode) {
    final value = accessCode?.trim() ?? '';

    if (value.isEmpty) return 'El código del grupo es obligatorio';

    if (value.length < 4) {
      return 'El código del grupo debe tener mínimo 4 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(value)) {
      return 'El código del grupo solo puede tener letras, números, guion o guion bajo';
    }

    return null;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();

      final emailError = _validateEmail(normalizedEmail);
      if (emailError != null) throw Exception(emailError);

      if (normalizedPassword.isEmpty) {
        throw Exception('La contraseña es obligatoria');
      }

      _user = await _loginUseCase(
        normalizedEmail,
        normalizedPassword,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? studentProfile,
    String? accessCode,
    Map<String, dynamic>? additionalData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();
      final normalizedName = name.trim();
      final normalizedRole = role.trim().toLowerCase();

      final nameError = _validateName(normalizedName);
      if (nameError != null) throw Exception(nameError);

      final emailError = _validateEmail(normalizedEmail);
      if (emailError != null) throw Exception(emailError);

      final passwordError = _validatePassword(normalizedPassword);
      if (passwordError != null) throw Exception(passwordError);

      final roleError = _validateRole(normalizedRole);
      if (roleError != null) throw Exception(roleError);

      if (!privacyAccepted) {
        throw Exception('Debe aceptar el aviso de privacidad para poder registrarse.');
      }

      if (normalizedRole == 'estudiante') {
        final profileError = _validateStudentProfile(studentProfile);
        if (profileError != null) throw Exception(profileError);

        final groupError = _validateGroupCode(accessCode);
        if (groupError != null) throw Exception(groupError);
      }

      _user = await _registerUseCase(
        email: normalizedEmail,
        password: normalizedPassword,
        name: normalizedName,
        role: normalizedRole,
        privacyAccepted: privacyAccepted,
        profileImage: profileImage,
        additionalData: additionalData,
      );

      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró token después del registro');
      }

      if (normalizedRole == 'estudiante') {
        await _api.createStudentProfile(token, studentProfile!);
        final code = accessCode!.trim();
        await _api.joinGroup(token, code);
        await _api.getStudentProfile(token);
      }

      if (normalizedRole == 'orientador') {
        if (additionalData == null) {
          throw Exception('Faltan datos del orientador');
        }

        if (additionalData['group'] != null) {
          await _api.createGroup(token, additionalData['group']);
        }
      }

      return true;
    } catch (e) {
      debugPrint('XXX Error register seguro: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatar(Uint8List imageBytes) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _updateAvatarUseCase(imageBytes);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatarFromGallery() async {
    final bytes = await _mediaService.pickImageFromGallery();
    if (bytes == null) return false;
    return await updateAvatar(bytes);
  }

  Future<bool> updateAvatarFromCamera() async {
    final bytes = await _mediaService.takePhoto();
    if (bytes == null) return false;
    return await updateAvatar(bytes);
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _logoutUseCase();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
