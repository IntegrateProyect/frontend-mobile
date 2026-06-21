import 'package:sentinel_ai/src/features/auth/domain/entities/user_credential.dart';
import 'package:sentinel_ai/src/features/auth/domain/repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserCredential?> call(String email, String password) async {
    return await repository.login(email, password);
  }
}