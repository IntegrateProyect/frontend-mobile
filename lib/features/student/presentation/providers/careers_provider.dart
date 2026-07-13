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
  String? _errorMessage;

  List<CareerEntity> get careers => List.unmodifiable(_careers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendedCareers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _careers = await _getCareersUseCase();
    } catch (error) {
      debugPrint('Error al cargar carreras: $error');
      _errorMessage = 'No se pudieron cargar las carreras.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}