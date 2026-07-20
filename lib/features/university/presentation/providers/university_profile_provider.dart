import 'package:flutter/material.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';

class UniversityProfileProvider extends ChangeNotifier {
  final GetUniversityProfileUseCase _getProfileUseCase;

  UniversityProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  UniversityProfileProvider({
    required GetUniversityProfileUseCase getProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase;

  UniversityProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> claimUniversity(String cct, String rfc) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await _getProfileUseCase.repository.claimUniversity(cct, rfc);
    } catch (e) {
      _errorMessage = _cleanError(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
