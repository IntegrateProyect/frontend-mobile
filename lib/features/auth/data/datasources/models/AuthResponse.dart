import 'user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Buscamos el token en la raíz o dentro de 'data' de forma segura
    String? extractedToken = json['token']?.toString();
    if (extractedToken == null && json['data'] != null) {
      extractedToken = json['data']['token']?.toString();
    }

    // Extraemos los datos del usuario de forma segura
    Map<String, dynamic>? userData = json['user'];
    if (userData == null && json['data'] != null) {
      userData = json['data']['user'];
    }

    return AuthResponse(
      token: extractedToken ?? '', // Si no hay token, enviamos string vacío en lugar de null
      user: UserModel.fromJson(userData ?? {}), // Si no hay usuario, enviamos mapa vacío
    );
  }
}
