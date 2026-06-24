import 'package:flutter/material.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/usecases/get_compatible_universities_usecase.dart';

class UniversitiesProvider extends ChangeNotifier {
  final GetCompatibleUniversitiesUseCase _getCompatibleUniversitiesUseCase;

  List<UniversityEntity> _universities = [];
  bool _isLoading = false;

  UniversitiesProvider({required GetCompatibleUniversitiesUseCase getCompatibleUniversitiesUseCase})
      : _getCompatibleUniversitiesUseCase = getCompatibleUniversitiesUseCase;

  List<UniversityEntity> get universities => _universities;
  bool get isLoading => _isLoading;

  Future<void> fetchCompatibleUniversities() async {
    _isLoading = true;
    notifyListeners();
    try {
      _universities = await _getCompatibleUniversitiesUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
