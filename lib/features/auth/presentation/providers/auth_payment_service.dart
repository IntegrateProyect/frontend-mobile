import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

class AuthPaymentService {
  final IApi _api;
  final UserService _userService;

  AuthPaymentService({
    required IApi api,
    required UserService userService,
  })  : _api = api,
        _userService = userService;

  Future<String?> createPaymentPreference(
    double amount, {
    String paymentMethod = 'card',
  }) async {
    if (amount <= 0) {
      throw Exception('El monto del pago debe ser mayor a cero');
    }

    final token = await _userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Usuario no autenticado.');
    }

    final response = await _api.createPaymentPreference(
      token,
      {
        'title': 'Suscripción Universitaria Premium - Oriéntate+',
        'price': amount,
        'paymentMethod': paymentMethod,
      },
    );

    final status = response['status']?.toString();
    final data = response['data'];

    if (status == 'success' && data is Map) {
      return data['initPoint']?.toString();
    }

    throw Exception(
      response['message'] ?? 'Error al generar la preferencia de pago',
    );
  }
}
