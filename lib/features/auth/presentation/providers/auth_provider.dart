import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../../core/utils/media_service.dart';

import '../../data/datasources/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_avatar_usecase.dart';

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
  bool _sessionChecked = false;
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
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) {
        _user = null;
        return false;
      }

      /*
       * Comprueba en el backend que el token guardado
       * todavía sea válido.
       */
      final response = await _api.getMe(token);

      final restoredUser = UserModel.fromJson(
        response,
      );

      if (restoredUser.id.trim().isEmpty ||
          restoredUser.email.trim().isEmpty) {
        throw Exception(
          'Los datos de la sesión almacenada no son válidos',
        );
      }

      _user = restoredUser;

      /*
       * Conserva el token y actualiza los datos locales
       * del usuario.
       */
      await _userService.saveSession(
        token,
        restoredUser,
      );

      return true;
    } catch (error) {
      debugPrint(
        'No fue posible restaurar la sesión: $error',
      );

      /*
       * Si el token venció o fue revocado,
       * elimina solamente la sesión.
       *
       * No elimina la marca del onboarding.
       */
      await _userService.logout();

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

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }

  String _normalizeError(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // =========================================================
  // VALIDACIONES
  // =========================================================

  String? _validateName(String name) {
    final value = name.trim();

    if (value.isEmpty) {
      return 'El nombre completo es obligatorio';
    }

    final lettersCount = value.replaceAll(' ', '').length;

    if (lettersCount < 3) {
      return 'El nombre debe tener mínimo 3 letras';
    }

    final nameRegex = RegExp(
      r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$',
    );

    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solamente puede contener letras y espacios';
    }

    return null;
  }

  String? _validateEmail(String email) {
    final value = email.trim();

    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido. Ejemplo: usuario@correo.com';
    }

    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }

    return null;
  }

  String _normalizeRole(String role) {
    final value = role.trim().toLowerCase();

    /*
     * En la interfaz se utiliza "egresado",
     * pero el backend utiliza "alumni".
     */
    if (value == 'egresado') {
      return 'alumni';
    }

    if (value == 'student') {
      return 'estudiante';
    }

    if (value == 'counselor') {
      return 'orientador';
    }

    if (value == 'university') {
      return 'universidad';
    }

    return value;
  }

  String? _validateRole(String role) {
    final value = _normalizeRole(role);

    const validRoles = [
      'estudiante',
      'orientador',
      'universidad',
      'alumni',
      'admin',
    ];

    if (value.isEmpty) {
      return 'Debes seleccionar un rol';
    }

    if (!validRoles.contains(value)) {
      return 'El rol seleccionado no es válido';
    }

    return null;
  }

  String? _validateStudentProfile(
      Map<String, dynamic>? profile,
      ) {
    if (profile == null) {
      return 'Faltan los datos del perfil vocacional';
    }

    final subjectsLiked =
    profile['subjectsLiked'];

    final subjectsDisliked =
    profile['subjectsDisliked'];

    final interests =
    profile['interests'];

    final skills =
    profile['skills'];

    final vocationalClarity =
    profile['vocationalClarity'];

    if (subjectsLiked is! List ||
        subjectsLiked.isEmpty) {
      return 'Selecciona al menos una materia que te gusta';
    }

    if (subjectsDisliked is! List ||
        subjectsDisliked.isEmpty) {
      return 'Selecciona al menos una materia que no te gusta';
    }

    if (interests is! List ||
        interests.isEmpty) {
      return 'Selecciona al menos un área de interés';
    }

    if (skills is! List ||
        skills.isEmpty) {
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

    if (value.isEmpty) {
      return 'Ingresa el código del grupo';
    }

    if (value.length < 4) {
      return 'El código del grupo debe tener mínimo 4 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z0-9\-_]+$')
        .hasMatch(value)) {
      return 'El código solo puede tener letras, números, guion o guion bajo';
    }

    return null;
  }

  // =========================================================
  // INICIAR SESIÓN
  // =========================================================

  Future<bool> login(
      String email,
      String password,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail =
      email.trim().toLowerCase();

      final emailError = _validateEmail(
        normalizedEmail,
      );

      if (emailError != null) {
        throw Exception(emailError);
      }

      if (password.isEmpty) {
        throw Exception(
          'La contraseña es obligatoria',
        );
      }

      /*
       * El AuthRemoteDataSource guarda automáticamente
       * el token y los datos del usuario.
       */
      _user = await _loginUseCase(
        normalizedEmail,
        password,
      );

      if (_user == null) {
        throw Exception(
          'No fue posible obtener los datos del usuario',
        );
      }

      return true;
    } catch (error) {
      _user = null;
      _errorMessage = _cleanError(error);

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
      final normalizedEmail =
      email.trim().toLowerCase();

      final normalizedName =
      name.trim();

      final normalizedRole =
      _normalizeRole(role);

      final nameError = _validateName(
        normalizedName,
      );

      if (nameError != null) {
        throw Exception(nameError);
      }

      final emailError = _validateEmail(
        normalizedEmail,
      );

      if (emailError != null) {
        throw Exception(emailError);
      }

      final passwordError = _validatePassword(
        password,
      );

      if (passwordError != null) {
        throw Exception(passwordError);
      }

      final roleError = _validateRole(
        normalizedRole,
      );

      if (roleError != null) {
        throw Exception(roleError);
      }

      if (!privacyAccepted) {
        throw Exception(
          'Debes aceptar el aviso de privacidad para poder registrarte.',
        );
      }

      /*
       * El registro hace login automático.
       * Por eso también guarda el token.
       */
      _user = await _registerUseCase(
        email: normalizedEmail,
        password: password,
        name: normalizedName,
        role: normalizedRole,
        privacyAccepted: privacyAccepted,
        profileImage: profileImage,
        additionalData: additionalData,
      );

      final token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'No se encontró el token después del registro',
        );
      }

      /*
       * Si es orientador y proporcionó los datos
       * de un grupo, se crea después del registro.
       */
      if (normalizedRole == 'orientador') {
        if (additionalData == null) {
          throw Exception(
            'Faltan datos del orientador',
          );
        }

        final group =
        additionalData['group'];

        if (group is Map) {
          await _api.createGroup(
            token,
            Map<String, dynamic>.from(group),
          );
        }
      }

      return true;
    } catch (error) {
      debugPrint(
        'Error durante el registro: $error',
      );

      _errorMessage = _cleanError(error);

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
      final token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'No se encontró una sesión activa',
        );
      }

      await _api.getStudentProfile(token);

      return true;
    } catch (error) {
      final cleanError =
      _cleanError(error);

      final normalizedError =
      _normalizeError(cleanError);

      debugPrint(
        'Comprobación de perfil vocacional: $cleanError',
      );

      final profileNotFound =
          normalizedError.contains('404') ||
              normalizedError.contains(
                'perfil vocacional no encontrado',
              ) ||
              normalizedError.contains(
                'no se encontro el perfil vocacional',
              ) ||
              normalizedError.contains(
                'no existe el perfil vocacional',
              ) ||
              normalizedError.contains(
                'student profile not found',
              ) ||
              normalizedError.contains(
                'vocational profile not found',
              ) ||
              (normalizedError.contains('perfil') &&
                  normalizedError.contains(
                    'no se encontro',
                  )) ||
              (normalizedError.contains('perfil') &&
                  normalizedError.contains(
                    'no encontrado',
                  ));

      if (profileNotFound) {
        /*
         * No es un error real.
         * El estudiante debe completar el perfil.
         */
        _errorMessage = null;
        return false;
      }

      _errorMessage = cleanError;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // CREAR PERFIL VOCACIONAL
  // =========================================================

  Future<bool> createStudentVocationalProfile(
      Map<String, dynamic> profile,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final validationError =
      _validateStudentProfile(profile);

      if (validationError != null) {
        throw Exception(validationError);
      }

      final token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'La sesión expiró. Inicia sesión nuevamente.',
        );
      }

      await _api.createStudentProfile(
        token,
        profile,
      );

      return true;
    } catch (error) {
      debugPrint(
        'Error creando perfil vocacional: $error',
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // UNIRSE A GRUPO
  // =========================================================

  Future<bool> joinStudentGroup(
      String accessCode,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedCode =
      accessCode.trim();

      final codeError =
      _validateGroupCode(normalizedCode);

      if (codeError != null) {
        throw Exception(codeError);
      }

      final token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'La sesión expiró. Inicia sesión nuevamente.',
        );
      }

      await _api.joinGroup(
        token,
        normalizedCode,
      );

      return true;
    } catch (error) {
      debugPrint(
        'Error al unirse al grupo: $error',
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ACTUALIZAR AVATAR
  // =========================================================

  Future<bool> updateAvatar(
      Uint8List imageBytes,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _updateAvatarUseCase(
        imageBytes,
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatarFromGallery() async {
    final bytes =
    await _mediaService.pickImageFromGallery();

    if (bytes == null) {
      return false;
    }

    return updateAvatar(bytes);
  }

  Future<bool> updateAvatarFromCamera() async {
    final bytes =
    await _mediaService.takePhoto();

    if (bytes == null) {
      return false;
    }

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
      await _logoutUseCase();
    } catch (error) {
      /*
       * Aunque falle la petición al backend,
       * la sesión local debe eliminarse.
       */
      debugPrint(
        'Error notificando logout al backend: $error',
      );

      _errorMessage = _cleanError(error);
    } finally {
      /*
       * Se vuelve a limpiar localmente por seguridad.
       * UserService.logout no elimina onboarding_completed.
       */
      await _userService.logout();

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
      final normalizedEmail =
      email.trim().toLowerCase();

      final emailError =
      _validateEmail(normalizedEmail);

      if (emailError != null) {
        throw Exception(emailError);
      }

      await _api.recoverPassword(
        normalizedEmail,
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // RESTABLECER CONTRASEÑA
  // =========================================================

  Future<bool> resetPassword(
      String token,
      String newPassword,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanToken = token.trim();

      if (cleanToken.isEmpty) {
        throw Exception(
          'El token es obligatorio',
        );
      }

      final passwordError =
      _validatePassword(newPassword);

      if (passwordError != null) {
        throw Exception(passwordError);
      }

      await _api.resetPassword(
        cleanToken,
        newPassword,
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
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
      if (amount <= 0) {
        throw Exception(
          'El monto del pago debe ser mayor a cero',
        );
      }

      final token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Usuario no autenticado.',
        );
      }

      final response =
      await _api.createPaymentPreference(
        token,
        {
          'title':
          'Suscripción Universitaria Premium - Oriéntate+',
          'price': amount,
          'paymentMethod': paymentMethod,
        },
      );

      final status =
      response['status']?.toString();

      final data = response['data'];

      if (status == 'success' &&
          data is Map) {
        return data['initPoint']?.toString();
      }

      throw Exception(
        response['message'] ??
            'Error al generar la preferencia de pago',
      );
    } catch (error) {
      _errorMessage = _cleanError(error);
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

    if (currentUser == null) {
      return;
    }

    _user = UserEntity(
      id: currentUser.id,
      email: currentUser.email,
      name: currentUser.name,
      photoUrl: currentUser.photoUrl,
      avatarUrl: currentUser.avatarUrl,
      role: currentUser.role,
      verificationStatus:
      currentUser.verificationStatus,
      universityName:
      currentUser.universityName,
      isPremium: value,
    );

    notifyListeners();
  }
}