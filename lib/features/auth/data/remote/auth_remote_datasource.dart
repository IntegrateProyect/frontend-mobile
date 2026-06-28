import 'dart:async';

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
        Map<String, dynamic>? additionalData,
      });

  Future<void> logout();

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
        Map<String, dynamic>? additionalData,
      }) async {
    await api.register({
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    });

    final loginResponse = await api.login(email, password);
    final authResponse = AuthResponse.fromJson(loginResponse);

    if (authResponse.token.isEmpty) {
      throw Exception('Cuenta creada, pero no se recibió token al iniciar sesión');
    }

    await userService.saveSession(authResponse.token, authResponse.user);
    _authStateController.add(authResponse.user);

    return authResponse.user;
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