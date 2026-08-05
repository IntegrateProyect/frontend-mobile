import 'package:flutter/foundation.dart';
import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../data/datasources/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthSessionService {
  final IApi _api;
  final UserService _userService;
  final LogoutUseCase _logoutUseCase;

  AuthSessionService({
    required IApi api,
    required UserService userService,
    required LogoutUseCase logoutUseCase,
  })  : _api = api,
        _userService = userService,
        _logoutUseCase = logoutUseCase;

  Future<UserEntity?> restoreSession() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) {
        return null;
      }

      final response = await _api.getMe(token);
      final restoredUser = UserModel.fromJson(response);

      if (restoredUser.id.trim().isEmpty || restoredUser.email.trim().isEmpty) {
        throw Exception('Los datos de la sesión almacenada no son válidos');
      }

      await _userService.saveSession(token, restoredUser);
      return restoredUser;
    } catch (error) {
      debugPrint('No fue posible restaurar la sesión: $error');
      await _userService.logout();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase();
    } catch (error) {
      debugPrint('Error notificando logout al backend: $error');
      rethrow;
    } finally {
      await _userService.logout();
    }
  }
}
