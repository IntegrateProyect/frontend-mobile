import 'package:flutter/material.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/usecases/get_recommended_careers_usecase.dart';

class CareersProvider extends ChangeNotifier {
  final GetRecommendedCareersUseCase _getRecommendedCareersUseCase;

  List<CareerEntity> _careers = [];
  bool _isLoading = false;

  CareersProvider({required GetRecommendedCareersUseCase getRecommendedCareersUseCase})
      : _getRecommendedCareersUseCase = getRecommendedCareersUseCase;

  List<CareerEntity> get careers => _careers;
  bool get isLoading => _isLoading;

  Future<void> fetchRecommendedCareers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _careers = await _getRecommendedCareersUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
