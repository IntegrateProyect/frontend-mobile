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
    return _results.isEmpty
        ? null
        : _results.first;
  }

  bool get isLoading => _isLoading;

  bool get hasResults => _results.isNotEmpty;

  String? get errorMessage => _errorMessage;

  Future<void> fetchResults() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _getResultsUseCase();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al cargar resultados vocacionales: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage =
      'No se pudieron cargar los resultados vocacionales.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() {
    return fetchResults();
  }

  void clear() {
    _results = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}