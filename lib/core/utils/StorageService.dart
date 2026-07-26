import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_completed';

  Future<void> saveToken(String token) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('No se puede guardar un token vacío');
    }

    await _storage.write(
      key: _tokenKey,
      value: cleanToken,
    );
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    return token.trim();
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> setOnboardingCompleted() async {
    await _storage.write(
      key: _onboardingKey,
      value: 'true',
    );
  }

  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearSession() async {
    await deleteToken();
    await delete(UserServiceKeys.userData);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

class UserServiceKeys {
  static const String userData = 'user_data';
}