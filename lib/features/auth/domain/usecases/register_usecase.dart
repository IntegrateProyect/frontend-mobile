import 'dart:typed_data';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  }) {
    return repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
      privacyAccepted: privacyAccepted,
      profileImage: profileImage,
      additionalData: additionalData,
    );
  }
}
