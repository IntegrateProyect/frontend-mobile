import 'dart:convert';

import 'StorageService.dart';
import '../../features/auth/data/datasources/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final StorageService _storage;

  static const String _userKey = UserServiceKeys.userData;

  UserService(this._storage);

  Future<void> _clearGameProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('game_')) {
          await prefs.remove(key);
        }
      }
    } catch (_) {}
  }

  Future<void> saveSession(
      String token,
      UserModel user,
      ) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('Token inválido');
    }

    await _clearGameProgress();
    await _storage.saveToken(cleanToken);

    await _storage.write(
      _userKey,
      jsonEncode(user.toJson()),
    );
  }

  Future<void> updateStoredUser(UserModel user) async {
    await _storage.write(
      _userKey,
      jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(_userKey);

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

  Future<String?> getToken() {
    return _storage.getToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> completeOnboarding() {
    return _storage.setOnboardingCompleted();
  }

  Future<bool> hasCompletedOnboarding() {
    return _storage.isOnboardingCompleted();
  }

  Future<void> logout() async {
    // Solamente elimina la sesión.
    // No elimina onboarding_completed.
    await _storage.delete(_userKey);
    await _storage.deleteToken();
    await _clearGameProgress();
  }
}