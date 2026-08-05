import 'package:flutter/material.dart';
import '../../../university/domain/entities/university_announcement_entity.dart';
import '../../domain/usecases/get_student_announcements_usecase.dart';

class StudentAnnouncementsProvider extends ChangeNotifier {
  final GetStudentAnnouncementsUseCase _getAnnouncementsUseCase;

  StudentAnnouncementsProvider({
    required GetStudentAnnouncementsUseCase getAnnouncementsUseCase,
  }) : _getAnnouncementsUseCase = getAnnouncementsUseCase;

  List<UniversityAnnouncementEntity> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<UniversityAnnouncementEntity> get announcements =>
      List.unmodifiable(_announcements);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> loadAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      _announcements = await _getAnnouncementsUseCase();
    } catch (e) {
      _errorMessage = 'Error al cargar los anuncios';
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }
}
