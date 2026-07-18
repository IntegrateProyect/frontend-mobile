import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/usecases/get_alumni_profile_usecase.dart';
import '../../domain/usecases/manage_stories_usecase.dart';

class WriteStoryProvider extends ChangeNotifier {
  final GetAlumniProfileUseCase getProfileUseCase;
  final ManageStoriesUseCase manageStoriesUseCase;

  WriteStoryProvider({
    required this.getProfileUseCase,
    required this.manageStoriesUseCase,
  }) {
    // Escuchar cambios en el controlador para actualizar el preview
    storyController.addListener(() {
      notifyListeners();
    });
  }

  final TextEditingController storyController = TextEditingController();

  AlumniProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  AlumniProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await getProfileUseCase();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitStory() async {
    final content = storyController.text.trim();
    if (content.isEmpty) {
      _errorMessage = 'Por favor, escribe tu historia';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await manageStoriesUseCase.shareStory(content);
      storyController.clear();
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
