import 'dart:convert';

import 'StorageService.dart';
import '../../features/auth/data/datasources/models/user_model.dart';

class UserService {
  final StorageService _storage;

  static const String _userKey = 'user_data';

  UserService(this._storage);

  // =========================
  // SAVE SESSION
  // =========================

  Future<void> saveSession(
      String token,
      UserModel user,
      ) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('Token inválido');
    }

    await _storage.saveToken(cleanToken);

    final userJson = jsonEncode(
      user.toJson(),
    );

    await _storage.write(
      _userKey,
      userJson,
    );
  }

  // =========================
  // GET USER
  // =========================

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(
      _userKey,
    );

    if (userJson == null || userJson.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);

      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }

      if (decoded is Map) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }

      return null;
    } catch (_) {
      await logout();
      return null;
    }
  }

  // =========================
  // GET TOKEN
  // =========================

  Future<String?> getToken() async {
    final token = await _storage.getToken();

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    return token.trim();
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _storage.delete(_userKey);
    await _storage.deleteToken();
  }

  // =========================
  // CHECK LOGIN
  // =========================

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    return true;
  }
}