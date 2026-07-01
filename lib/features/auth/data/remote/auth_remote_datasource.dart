import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../datasources/models/user_model.dart';
import '../datasources/models/AuthResponse.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(
    String email,
    String password,
    String name,
    String role, {
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  });

  Future<void> logout();

  Future<UserModel> updateAvatar(Uint8List imageBytes);

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IApi api;
  final UserService userService;

  final _authStateController = StreamController<UserModel?>.broadcast();

  AuthRemoteDataSourceImpl({
    required this.api,
    required this.userService,
  }) {
    _init();
  }

  Future<void> _init() async {
    final user = await userService.getUser();
    _authStateController.add(user);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final responseMap = await api.login(email, password);
    final authResponse = AuthResponse.fromJson(responseMap);

    if (authResponse.token.isEmpty) {
      throw Exception('No se recibió un token válido');
    }

    await userService.saveSession(authResponse.token, authResponse.user);
    _authStateController.add(authResponse.user);

    return authResponse.user;
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String name,
    String role, {
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  }) async {
    // 1. Registro inicial
    final Map<String, dynamic> regData = {
      'email': email,
      'password': password,
      'name': name,
      'roleName': role,
      'privacyAccepted': privacyAccepted,
    };

    await api.register(regData);

    // 2. Login automático para obtener Token
    final loginResponse = await api.login(email, password);
    final authResponse = AuthResponse.fromJson(loginResponse);

    if (authResponse.token.isEmpty) {
      throw Exception('Error al iniciar sesión tras el registro');
    }

    UserModel currentUser = authResponse.user;
    final String token = authResponse.token;

    // 3. Si hay imagen, ejecutar el flujo de 3 pasos de S3
    if (profileImage != null) {
      try {
        debugPrint('--- INICIANDO CARGA DE AVATAR EN REGISTRO ---');
        // Paso A: Obtener URL firmada
        final uploadData = await api.getAvatarUploadUrl(token);
        final String uploadUrl = uploadData['data']['uploadUrl'];
        final String fileUrl = uploadData['data']['fileUrl'];

        // Paso B: Subir binario a S3
        await api.uploadImageToS3(uploadUrl, profileImage);

        // Paso C: Notificar al backend
        final updateResponse = await api.updateAvatarInBackend(token, fileUrl);
        currentUser = UserModel.fromJson(updateResponse);
        debugPrint('--- AVATAR REGISTRADO CON ÉXITO: ${currentUser.avatarUrl} ---');
      } catch (e) {
        debugPrint('XXX Error cargando avatar en registro: $e');
        // No lanzamos excepción aquí para permitir que el usuario entre aunque falle la foto
      }
    }

    // 4. Guardar sesión final
    await userService.saveSession(token, currentUser);
    _authStateController.add(currentUser);

    return currentUser;
  }

  @override
  Future<UserModel> updateAvatar(Uint8List imageBytes) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no encontrada');

    final uploadData = await api.getAvatarUploadUrl(token);
    final String uploadUrl = uploadData['data']['uploadUrl'];
    final String fileUrl = uploadData['data']['fileUrl'];

    await api.uploadImageToS3(uploadUrl, imageBytes);
    final updateResponse = await api.updateAvatarInBackend(token, fileUrl);

    final UserModel updatedUser = UserModel.fromJson(updateResponse);

    await userService.saveSession(token, updatedUser);
    _authStateController.add(updatedUser);

    return updatedUser;
  }

  @override
  Future<void> logout() async {
    try {
      final token = await userService.getToken();
      if (token != null && token.isNotEmpty) {
        await api.logout(token);
      }
    } finally {
      await userService.logout();
      _authStateController.add(null);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;
}
