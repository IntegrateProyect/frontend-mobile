import 'package:flutter/material.dart';
import '../../domain/entities/university_announcement_entity.dart';
import '../../domain/usecases/get_university_announcements_usecase.dart';
import '../../domain/usecases/create_university_announcement_usecase.dart';
import '../../domain/usecases/update_university_announcement_usecase.dart';
import '../../domain/usecases/delete_university_announcement_usecase.dart';

class UniversityAnnouncementsProvider extends ChangeNotifier {
  final GetUniversityAnnouncementsUseCase _getAnnouncementsUseCase;
  final CreateUniversityAnnouncementUseCase _createAnnouncementUseCase;
  final UpdateUniversityAnnouncementUseCase _updateAnnouncementUseCase;
  final DeleteUniversityAnnouncementUseCase _deleteAnnouncementUseCase;

  List<UniversityAnnouncementEntity> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- Form State ---
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String selectedCategory = 'General';
  bool isSubmitting = false;

  UniversityAnnouncementsProvider({
    required GetUniversityAnnouncementsUseCase getAnnouncementsUseCase,
    required CreateUniversityAnnouncementUseCase createAnnouncementUseCase,
    required UpdateUniversityAnnouncementUseCase updateAnnouncementUseCase,
    required DeleteUniversityAnnouncementUseCase deleteAnnouncementUseCase,
  })  : _getAnnouncementsUseCase = getAnnouncementsUseCase,
        _createAnnouncementUseCase = createAnnouncementUseCase,
        _updateAnnouncementUseCase = updateAnnouncementUseCase,
        _deleteAnnouncementUseCase = deleteAnnouncementUseCase;

  List<UniversityAnnouncementEntity> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void resetForm({UniversityAnnouncementEntity? announcement}) {
    if (announcement != null) {
      titleController.text = announcement.title;
      descController.text = announcement.description;
      selectedCategory = announcement.category;
    } else {
      titleController.clear();
      descController.clear();
      selectedCategory = 'General';
    }
    isSubmitting = false;
    notifyListeners();
  }

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _announcements = await _getAnnouncementsUseCase();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForm({String? id}) async {
    isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final announcement = UniversityAnnouncementEntity(
        id: id ?? '',
        title: titleController.text.trim(),
        description: descController.text.trim(),
        category: selectedCategory,
      );

      if (id == null) {
        await _createAnnouncementUseCase(announcement);
      } else {
        await _updateAnnouncementUseCase(announcement);
      }
      await fetchAnnouncements();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _deleteAnnouncementUseCase(id);
      await fetchAnnouncements();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
