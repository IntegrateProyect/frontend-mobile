import 'package:flutter/material.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/usecases/get_university_careers_usecase.dart';
import '../../domain/usecases/add_university_career_usecase.dart';
import '../../domain/usecases/delete_university_career_usecase.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';
import '../../data/repositories/university_repository_impl.dart';

enum UniversityCareersState { initial, loading, loaded, error }

class UniversityCareersProvider extends ChangeNotifier {
  final GetUniversityCareersUseCase _getCareersUseCase;
  final AddUniversityCareerUseCase _addCareerUseCase;
  final DeleteUniversityCareerUseCase _deleteCareerUseCase;
  final GetUniversityProfileUseCase _getProfileUseCase; // Used for catalog

  List<UniversityCareerEntity> _careers = [];
  List<UniversityCareerEntity> _catalogCareers = [];
  UniversityCareersState _state = UniversityCareersState.initial;
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
  UniversityCareersState get state => _state;
  bool get isLoading => _state == UniversityCareersState.loading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> fetchCareers() async {
    _state = UniversityCareersState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _careers = await _getCareersUseCase();
      _state = UniversityCareersState.loaded;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _state = UniversityCareersState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCatalogCareers() async {
    _state = UniversityCareersState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _catalogCareers = await _getProfileUseCase.repository.getCatalogCareers();
      _state = UniversityCareersState.loaded;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _state = UniversityCareersState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addCareer(UniversityCareerEntity career) async {
    _state = UniversityCareersState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await _addCareerUseCase(career);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
      _state = UniversityCareersState.error;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> createCustomCareer({
    required String name,
    required String categoryId,
    required String description,
    required String location,
    required String modality,
    required double costApprox,
    required bool scholarshipAvailable,
    required String admissionDates,
    String? duration,
  }) async {
    _state = UniversityCareersState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final repo = _getProfileUseCase.repository;
      if (repo is UniversityRepositoryImpl) {
        await repo.createCustomCareer({
          'name': name,
          'categoryId': categoryId,
          'description': description,
          'location': location,
          'modality': modality,
          'costApprox': costApprox,
          'scholarshipAvailable': scholarshipAvailable,
          'admissionDates': admissionDates,
          'duration': duration ?? '8 Semestres',
        });
      }
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
      _state = UniversityCareersState.error;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteCareer(String id) async {
    _state = UniversityCareersState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await _deleteCareerUseCase(id);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
      _state = UniversityCareersState.error;
    } finally {
      notifyListeners();
    }
  }
}
