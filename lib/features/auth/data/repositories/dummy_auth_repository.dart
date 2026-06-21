// lib/src/features/auth/data/repositories/dummy_auth_repository.dart

import 'package:sentinel_ai/src/features/auth/domain/entities/user_credential.dart';
import 'package:sentinel_ai/src/features/auth/domain/repositories/i_auth_repository.dart';

class DummyAuthRepository implements IAuthRepository {
  @override
  Future<UserCredential?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@test.com' && password == '1234') {
      return UserCredential(token: 'dummy-token-123', email: '', password: '');
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<String?> refreshToken() async => null;

  @override
  Future<UserCredential?> register(String email, String password) async => null;
}