import 'package:sentinel_ai/src/features/auth/domain/repositories/i_auth_repository.dart';

class IsAuthenticatedUseCase {
  final IAuthRepository repository;

  IsAuthenticatedUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}
