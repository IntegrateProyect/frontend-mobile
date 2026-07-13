import 'package:flutter/material.dart';

import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';

class StudentResultsProvider extends ChangeNotifier {
  final GetVocationalResultsUseCase _getResultsUseCase;

  StudentResultsProvider({
    required GetVocationalResultsUseCase getResultsUseCase,
  }) : _getResultsUseCase = getResultsUseCase;

  List<VocationalResultEntity> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VocationalResultEntity> get results {
    return List.unmodifiable(_results);
  }

  VocationalResultEntity? get latestResult {
    return _results.isEmpty ? null : _results.first;
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchResults() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _getResultsUseCase();
    } catch (error) {
      debugPrint('Error al cargar resultados: $error');
      _errorMessage = 'No se pudieron cargar los resultados.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}