import 'package:flutter/material.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/update_student_profile_usecase.dart';

class StudentProfileProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final UpdateStudentProfileUseCase _updateProfileUseCase;

  StudentProfileEntity? _profile;
  bool _isLoading = false;

  StudentProfileProvider({
    required this._getProfileUseCase,
    required UpdateStudentProfileUseCase updateProfileUseCase,
  })  : _updateProfileUseCase = updateProfileUseCase;

  StudentProfileEntity? get profile => _profile;
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

  Future<void> updateProfile(StudentProfileEntity newProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _updateProfileUseCase(newProfile);
      _profile = newProfile;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
