import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import 'auth_validators.dart';
import 'auth_error_helper.dart';
import 'auth_role_helper.dart';
import 'auth_session_service.dart';
import 'student_account_service.dart';
import 'auth_avatar_service.dart';
import 'auth_password_service.dart';
import 'auth_payment_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final IApi _api;
  final UserService _userService;

  final AuthSessionService _sessionService;
  final StudentAccountService _studentService;
  final AuthAvatarService _avatarService;
  final AuthPasswordService _passwordService;
  final AuthPaymentService _paymentService;

  UserEntity? _user;
  bool _isLoading = false;
  bool _sessionChecked = false;
  String? _errorMessage;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required IApi api,
    required UserService userService,
    required AuthSessionService sessionService,
    required StudentAccountService studentService,
    required AuthAvatarService avatarService,
    required AuthPasswordService passwordService,
    required AuthPaymentService paymentService,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _api = api,
        _userService = userService,
        _sessionService = sessionService,
        _studentService = studentService,
        _avatarService = avatarService,
        _passwordService = passwordService,
        _paymentService = paymentService;

  // =========================================================
  // GETTERS
  // =========================================================

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  bool get sessionChecked => _sessionChecked;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  // =========================================================
  // RESTAURAR SESIÓN
  // =========================================================

  Future<bool> restoreSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final restoredUser = await _sessionService.restoreSession();
      _user = restoredUser;
      return restoredUser != null;
    } catch (error) {
      _user = null;
      _errorMessage = null;
      return false;
    } finally {
      _sessionChecked = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ONBOARDING
  // =========================================================

  Future<bool> hasCompletedOnboarding() {
    return _userService.hasCompletedOnboarding();
  }

  Future<void> completeOnboarding() {
    return _userService.completeOnboarding();
  }

  // =========================================================
  // UTILIDADES
  // =========================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // =========================================================
  // INICIAR SESIÓN
  // =========================================================

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final emailError = AuthValidators.validateEmail(normalizedEmail);

      if (emailError != null) {
        throw Exception(emailError);
      }

      if (password.isEmpty) {
        throw Exception('La contraseña es obligatoria');
      }

      _user = await _loginUseCase(normalizedEmail, password);

      if (_user == null) {
        throw Exception('No fue posible obtener los datos del usuario');
      }

      return true;
    } catch (error) {
      _user = null;
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // REGISTRO
  // =========================================================

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
      final normalizedName = name.trim();
      final normalizedRole = AuthRoleHelper.normalizeRole(role);

      final nameError = AuthValidators.validateName(normalizedName);
      if (nameError != null) throw Exception(nameError);

      final emailError = AuthValidators.validateEmail(normalizedEmail);
      if (emailError != null) throw Exception(emailError);

      final passwordError = AuthValidators.validatePassword(password);
      if (passwordError != null) throw Exception(passwordError);

      final roleError = AuthValidators.validateRole(normalizedRole);
      if (roleError != null) throw Exception(roleError);

      if (!privacyAccepted) {
        throw Exception('Debes aceptar el aviso de privacidad para poder registrarte.');
      }

      _user = await _registerUseCase(
        email: normalizedEmail,
        password: password,
        name: normalizedName,
        role: normalizedRole,
        privacyAccepted: privacyAccepted,
        profileImage: profileImage,
        additionalData: additionalData,
      );

      final token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No se encontró el token después del registro');
      }

      if (normalizedRole == 'orientador') {
        if (additionalData == null) throw Exception('Faltan datos del orientador');
        final group = additionalData['group'];
        if (group is Map) {
          await _api.createGroup(token, Map<String, dynamic>.from(group));
        }
      }

      return true;
    } catch (error) {
      debugPrint('Error durante el registro: $error');
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // COMPROBAR PERFIL VOCACIONAL
  // =========================================================

  Future<bool?> studentProfileExists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final exists = await _studentService.studentProfileExists();
      return exists;
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // CREAR PERFIL VOCACIONAL
  // =========================================================

  Future<bool> createStudentVocationalProfile(Map<String, dynamic> profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _studentService.createStudentVocationalProfile(profile);
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // UNIRSE A GRUPO
  // =========================================================

  Future<bool> joinStudentGroup(String accessCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _studentService.joinStudentGroup(accessCode);
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ACTUALIZAR AVATAR
  // =========================================================

  Future<bool> updateAvatar(Uint8List imageBytes) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _avatarService.updateAvatar(imageBytes);
      return true;
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatarFromGallery() async {
    final bytes = await _avatarService.pickImageFromGallery();
    if (bytes == null) return false;
    return updateAvatar(bytes);
  }

  Future<bool> updateAvatarFromCamera() async {
    final bytes = await _avatarService.takePhoto();
    if (bytes == null) return false;
    return updateAvatar(bytes);
  }

  // =========================================================
  // CERRAR SESIÓN
  // =========================================================

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionService.logout();
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
    } finally {
      _user = null;
      _sessionChecked = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // RECUPERAR CONTRASEÑA
  // =========================================================

  Future<bool> recoverPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _passwordService.recoverPassword(email);
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // RESTABLECER CONTRASEÑA
  // =========================================================

  Future<bool> resetPassword(String token, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _passwordService.resetPassword(token, newPassword);
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // CREAR PREFERENCIA DE PAGO
  // =========================================================

  Future<String?> createPaymentPreference(
    double amount, {
    String paymentMethod = 'card',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _paymentService.createPaymentPreference(amount, paymentMethod: paymentMethod);
    } catch (error) {
      _errorMessage = AuthErrorHelper.cleanError(error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ACTUALIZAR PREMIUM LOCALMENTE
  // =========================================================

  void setPremium(bool value) {
    final currentUser = _user;
    if (currentUser == null) return;

    _user = UserEntity(
      id: currentUser.id,
      email: currentUser.email,
      name: currentUser.name,
      photoUrl: currentUser.photoUrl,
      avatarUrl: currentUser.avatarUrl,
      role: currentUser.role,
      verificationStatus: currentUser.verificationStatus,
      universityName: currentUser.universityName,
      isPremium: value,
    );

    notifyListeners();
  }
}
