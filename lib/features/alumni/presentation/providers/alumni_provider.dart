import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/repositories/alumni_repository.dart';

class AlumniProvider extends ChangeNotifier {
  final AlumniRepository repository;

  AlumniProvider({required this.repository});

  AlumniProfileEntity? _profile;
  List<SuccessStoryEntity> _stories = [];
  bool _isLoading = false;
  String? _errorMessage;

  AlumniProfileEntity? get profile => _profile;
  List<SuccessStoryEntity> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAlumniData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getProfile().catchError((e) => throw e),
        repository.getSuccessStories(),
      ]);

      _profile = results[0] as AlumniProfileEntity;
      _stories = results[1] as List<SuccessStoryEntity>;
    } catch (e) {
      final message = e.toString();
      if (message.contains('profile not found')) {
        _errorMessage = 'PROFILE_NOT_FOUND';
      } else {
        _errorMessage = message.replaceAll('Exception: ', '');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(AlumniProfileEntity profile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.updateProfile(profile);
      _profile = profile;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> shareStory(String content, {String title = 'Mi Historia de Éxito'}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.shareStory(title: title, content: content);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
