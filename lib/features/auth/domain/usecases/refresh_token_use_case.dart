import 'package:sentinel_ai/src/features/auth/domain/repositories/i_auth_repository.dart';

class RefreshTokenUseCase {
  final IAuthRepository repository;

  RefreshTokenUseCase(this.repository);

  /// Returns the new access token, or null if refresh failed.
  Future<String?> call() async {
    return await repository.refreshToken();
  }
}
