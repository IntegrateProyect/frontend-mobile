import 'package:flutter/foundation.dart';
import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import 'auth_error_helper.dart';
import 'auth_validators.dart';

class StudentAccountService {
  final IApi _api;
  final UserService _userService;

  StudentAccountService({
    required IApi api,
    required UserService userService,
  })  : _api = api,
        _userService = userService;

  Future<bool?> studentProfileExists() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró una sesión activa');
      }

      await _api.getStudentProfile(token);
      return true;
    } catch (error) {
      final cleanError = AuthErrorHelper.cleanError(error);
      final normalizedError = AuthErrorHelper.normalizeError(cleanError);

      debugPrint('Comprobación de perfil vocacional: $cleanError');

      if (AuthErrorHelper.isProfileNotFoundError(normalizedError)) {
        return false;
      }

      rethrow;
    }
  }

  Future<bool> createStudentVocationalProfile(Map<String, dynamic> profile) async {
    final validationError = AuthValidators.validateStudentProfile(profile);
    if (validationError != null) {
      throw Exception(validationError);
    }

    final token = await _userService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('La sesión expiró. Inicia sesión nuevamente.');
    }

    await _api.createStudentProfile(token, profile);
    return true;
  }

  Future<bool> joinStudentGroup(String accessCode) async {
    final normalizedCode = accessCode.trim();
    final codeError = AuthValidators.validateGroupCode(normalizedCode);
    if (codeError != null) {
      throw Exception(codeError);
    }

    final token = await _userService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('La sesión expiró. Inicia sesión nuevamente.');
    }

    await _api.joinGroup(token, normalizedCode);
    return true;
  }
}
