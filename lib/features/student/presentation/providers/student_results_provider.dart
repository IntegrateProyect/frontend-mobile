import 'package:flutter/material.dart';

import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';

enum StudentResultsState { initial, loading, loaded, error }

class StudentResultsProvider extends ChangeNotifier {
  final GetVocationalResultsUseCase _getResultsUseCase;

  StudentResultsProvider({
    required GetVocationalResultsUseCase getResultsUseCase,
  }) : _getResultsUseCase = getResultsUseCase;

  List<VocationalResultEntity> _results = [];
  StudentResultsState _state = StudentResultsState.initial;
  String? _errorMessage;
  bool _isDisposed = false;

  List<VocationalResultEntity> get results {
    return List.unmodifiable(_results);
  }

  VocationalResultEntity? get latestResult {
    return _results.isEmpty ? null : _results.first;
  }

  StudentResultsState get state => _state;
  bool get isLoading => _state == StudentResultsState.loading;
  bool get hasResults => _results.isNotEmpty;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchResults() async {
    if (_state == StudentResultsState.loading) return;

    _state = StudentResultsState.loading;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      _results = await _getResultsUseCase();
      _state = StudentResultsState.loaded;
    } catch (error, stackTrace) {
      debugPrint('Error al cargar resultados vocacionales: $error');
      debugPrintStack(stackTrace: stackTrace);
      _errorMessage = 'No se pudieron cargar los resultados vocacionales.';
      _state = StudentResultsState.error;
    } finally {
      _safeNotifyListeners();
    }
  }

  Future<void> refresh() {
    return fetchResults();
  }

  void clear() {
    _results = [];
    _state = StudentResultsState.initial;
    _errorMessage = null;
    _safeNotifyListeners();
  }
}
