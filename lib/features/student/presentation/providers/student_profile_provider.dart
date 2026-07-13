import 'package:flutter/material.dart';

import '../../domain/entities/student_profile_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/update_student_profile_usecase.dart';

class StudentProfileProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final UpdateStudentProfileUseCase _updateProfileUseCase;

  StudentProfileProvider({
    required GetStudentProfileUseCase getProfileUseCase,
    required UpdateStudentProfileUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase;

  StudentProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  StudentProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _getProfileUseCase();
    } catch (error) {
      debugPrint('Error al cargar perfil: $error');
      _errorMessage = 'No se pudo cargar el perfil.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(
      StudentProfileEntity newProfile,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateProfileUseCase(newProfile);
      _profile = newProfile;

      return true;
    } catch (error) {
      _errorMessage = 'No se pudo actualizar el perfil.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}