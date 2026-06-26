import 'package:flutter/material.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';
import '../../domain/usecases/manage_careers_usecase.dart';

class UniversityProvider extends ChangeNotifier {
  final GetUniversityProfileUseCase _getProfileUseCase;
  final ManageCareersUseCase _manageCareersUseCase;

  UniversityProfileEntity? _profile;
  List<UniversityCareerEntity> _careers = [];
  bool _isLoading = false;

  UniversityProvider({
    required this._getProfileUseCase,
    required ManageCareersUseCase manageCareersUseCase,
  })  : _manageCareersUseCase = manageCareersUseCase;

  UniversityProfileEntity? get profile => _profile;
  List<UniversityCareerEntity> get careers => _careers;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCareers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _careers = await _manageCareersUseCase.getCareers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCareer(UniversityCareerEntity career) async {
    await _manageCareersUseCase.addCareer(career);
    await fetchCareers();
  }
}
