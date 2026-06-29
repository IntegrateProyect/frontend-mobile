import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Map<String, dynamic>? additionalData,
  });
  Future<void> logout();
  Stream<UserEntity?> get authStateChanges;
}
