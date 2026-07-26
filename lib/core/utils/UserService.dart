import 'dart:convert';

import 'StorageService.dart';
import '../../features/auth/data/datasources/models/user_model.dart';

class UserService {
  final StorageService _storage;

  static const String _userKey = UserServiceKeys.userData;

  UserService(this._storage);

  Future<void> saveSession(
      String token,
      UserModel user,
      ) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('Token inválido');
    }

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
  }
}