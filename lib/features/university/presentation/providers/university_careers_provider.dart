import 'package:flutter/material.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/usecases/get_university_careers_usecase.dart';
import '../../domain/usecases/add_university_career_usecase.dart';
import '../../domain/usecases/delete_university_career_usecase.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';

class UniversityCareersProvider extends ChangeNotifier {
  final GetUniversityCareersUseCase _getCareersUseCase;
  final AddUniversityCareerUseCase _addCareerUseCase;
  final DeleteUniversityCareerUseCase _deleteCareerUseCase;
  final GetUniversityProfileUseCase _getProfileUseCase; // Used for catalog

  List<UniversityCareerEntity> _careers = [];
  List<UniversityCareerEntity> _catalogCareers = [];
  bool _isLoading = false;
  String? _errorMessage;

  UniversityCareersProvider({
    required GetUniversityCareersUseCase getCareersUseCase,
    required AddUniversityCareerUseCase addCareerUseCase,
    required DeleteUniversityCareerUseCase deleteCareerUseCase,
    required GetUniversityProfileUseCase getProfileUseCase,
  })  : _getCareersUseCase = getCareersUseCase,
        _addCareerUseCase = addCareerUseCase,
        _deleteCareerUseCase = deleteCareerUseCase,
        _getProfileUseCase = getProfileUseCase;

  List<UniversityCareerEntity> get careers => _careers;
  List<UniversityCareerEntity> get catalogCareers => _catalogCareers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> fetchCareers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _careers = await _getCareersUseCase();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCatalogCareers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _catalogCareers = await _getProfileUseCase.repository.getCatalogCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCareer(UniversityCareerEntity career) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _addCareerUseCase(career);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCareer(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _deleteCareerUseCase(id);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
