import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/usecases/get_alumni_profile_usecase.dart';
import '../../domain/usecases/manage_stories_usecase.dart';

class AlumniHomeProvider extends ChangeNotifier {
  final GetAlumniProfileUseCase getProfileUseCase;
  final ManageStoriesUseCase manageStoriesUseCase;

  AlumniHomeProvider({
    required this.getProfileUseCase,
    required this.manageStoriesUseCase,
  });

  AlumniProfileEntity? _profile;
  List<SuccessStoryEntity> _recentStories = [];
  bool _isLoading = false;
  String? _errorMessage;

  AlumniProfileEntity? get profile => _profile;
  List<SuccessStoryEntity> get recentStories => _recentStories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        getProfileUseCase(),
        manageStoriesUseCase.getStories(),
      ]);

      _profile = results[0] as AlumniProfileEntity;
      _recentStories = results[1] as List<SuccessStoryEntity>;
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
}
