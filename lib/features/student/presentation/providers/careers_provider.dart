import 'package:flutter/material.dart';

import '../../domain/entities/career_entity.dart';
import '../../domain/usecases/get_recommended_careers_usecase.dart';

class CareersProvider extends ChangeNotifier {
  final GetRecommendedCareersUseCase _getCareersUseCase;

  CareersProvider({
    required GetRecommendedCareersUseCase getRecommendedCareersUseCase,
  }) : _getCareersUseCase = getRecommendedCareersUseCase;

  List<CareerEntity> _careers = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;

  List<CareerEntity> get careers =>
      List<CareerEntity>.unmodifiable(_careers);

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  bool get hasCareers => _careers.isNotEmpty;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendedCareers({
    int topN = 5,
    bool force = false,
  }) async {
    if (_isLoading || (_hasLoaded && !force)) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _careers = await _getCareersUseCase(topN: topN);
      _hasLoaded = true;
    } catch (error, stackTrace) {
      debugPrint('Error al cargar carreras recomendadas: $error');
      debugPrintStack(stackTrace: stackTrace);
      _careers = [];
      _errorMessage = _friendlyError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() {
    return fetchRecommendedCareers(
      topN: 5,
      force: true,
    );
  }

  void clear() {
    _careers = [];
    _isLoading = false;
    _hasLoaded = false;
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    final String message = error.toString().toLowerCase();

    if (message.contains('401') ||
        message.contains('token inválido') ||
        message.contains('token expirado')) {
      return 'Tu sesión expiró. Inicia sesión nuevamente.';
    }

    if (message.contains('422')) {
      return 'Completa tu perfil y todos los minijuegos '
          'antes de generar recomendaciones.';
    }

    if (message.contains('429')) {
      return 'Has realizado demasiadas solicitudes. '
          'Espera un momento e inténtalo nuevamente.';
    }

    if (message.contains('503') ||
        message.contains('timeout') ||
        message.contains('socket') ||
        message.contains('connection')) {
      return 'El servicio de recomendaciones no está '
          'disponible en este momento.';
    }

    return 'No se pudieron cargar las carreras recomendadas.';
  }
}