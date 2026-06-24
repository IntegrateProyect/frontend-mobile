import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/usecases/get_alumni_profile_usecase.dart';
import '../../domain/usecases/manage_stories_usecase.dart';

class AlumniProvider extends ChangeNotifier {
  final GetAlumniProfileUseCase _getProfileUseCase;
  final ManageStoriesUseCase _manageStoriesUseCase;

  AlumniProfileEntity? _profile;
  List<SuccessStoryEntity> _stories = [];
  bool _isLoading = false;

  AlumniProvider({
    required GetAlumniProfileUseCase getProfileUseCase,
    required ManageStoriesUseCase manageStoriesUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _manageStoriesUseCase = manageStoriesUseCase;

  AlumniProfileEntity? get profile => _profile;
  List<SuccessStoryEntity> get stories => _stories;
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

  Future<void> fetchStories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stories = await _manageStoriesUseCase.getStories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
