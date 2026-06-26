import 'package:flutter/material.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';

class StudentResultsProvider extends ChangeNotifier {
  final GetVocationalResultsUseCase _getResultsUseCase;

  List<VocationalResultEntity> _results = [];
  bool _isLoading = false;

  StudentResultsProvider({required this._getResultsUseCase});

  List<VocationalResultEntity> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> fetchResults() async {
    _isLoading = true;
    notifyListeners();
    try {
      _results = await _getResultsUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
