import 'package:flutter/material.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/usecases/manage_stories_usecase.dart';

class SuccessStoriesProvider extends ChangeNotifier {
  final ManageStoriesUseCase manageStoriesUseCase;

  SuccessStoriesProvider({required this.manageStoriesUseCase}) {
    searchController.addListener(() {
      notifyListeners();
    });
  }

  final TextEditingController searchController = TextEditingController();

  List<SuccessStoryEntity> _stories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SuccessStoryEntity> get stories {
    if (searchController.text.isEmpty) {
      return _stories;
    }
    final query = searchController.text.toLowerCase();
    return _stories.where((s) => 
      s.alumniName.toLowerCase().contains(query) || 
      s.career.toLowerCase().contains(query) ||
      s.story.toLowerCase().contains(query)
    ).toList();
  }
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await manageStoriesUseCase.getStories();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
