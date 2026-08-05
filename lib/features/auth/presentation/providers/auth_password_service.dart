import '../../../../core/api/IApi.dart';
import 'auth_validators.dart';

class AuthPasswordService {
  final IApi _api;

  AuthPasswordService({
    required IApi api,
  }) : _api = api;

  Future<bool> recoverPassword(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final emailError = AuthValidators.validateEmail(normalizedEmail);

    if (emailError != null) {
      throw Exception(emailError);
    }

    await _api.recoverPassword(normalizedEmail);
    return true;
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('El token es obligatorio');
    }

    final passwordError = AuthValidators.validatePassword(newPassword);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    await _api.resetPassword(cleanToken, newPassword);
    return true;
  }
}
