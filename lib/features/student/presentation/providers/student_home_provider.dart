import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/UserService.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';

enum StudentHomeState { initial, loading, loaded, error }

class StudentHomeProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final UserService _userService;

  StudentHomeProvider({
    required GetStudentProfileUseCase getProfileUseCase,
    required UserService userService,
  })  : _getProfileUseCase = getProfileUseCase,
        _userService = userService;

  StudentProfileEntity? _profile;
  StudentHomeState _state = StudentHomeState.initial;
  bool _hasChatbotInteraction = false;
  String? _errorMessage;
  bool _isDisposed = false;

  StudentProfileEntity? get profile => _profile;
  StudentHomeState get state => _state;
  bool get isLoading => _state == StudentHomeState.loading;
  String? get errorMessage => _errorMessage;
  bool get hasChatbotInteraction => _hasChatbotInteraction;

  String get firstName {
    final fullName = _profile?.name.trim() ?? '';
    if (fullName.isEmpty || _isGenericName(fullName)) {
      final email = _profile?.email.trim();
      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }
      return 'Estudiante';
    }
    return fullName.split(RegExp(r'\s+')).first;
  }

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

  Future<void> loadHomeData() async {
    if (_state == StudentHomeState.loading) return;

    _state = StudentHomeState.loading;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      await _loadLocalUser();
      final remoteProfile = await _loadProfileSafely();
      if (remoteProfile != null) _profile = remoteProfile;
      await _loadChatbotInteraction();
      _state = StudentHomeState.loaded;
    } catch (error) {
      _errorMessage = 'Error al cargar datos de inicio';
      _state = StudentHomeState.error;
    } finally {
      _safeNotifyListeners();
    }
  }

  Future<void> markChatbotInteraction() async {
    if (_hasChatbotInteraction) return;
    _hasChatbotInteraction = true;
    _safeNotifyListeners();

    final studentId = _profile?.id.trim() ?? '';
    if (studentId.isEmpty) return;

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('student_chatbot_interaction_$studentId', true);
    } catch (error) {
      debugPrint('No se pudo guardar el progreso del chatbot: $error');
    }
  }

  Future<StudentProfileEntity?> _loadProfileSafely() async {
    try {
      final profile = await _getProfileUseCase();
      if (profile.name.trim().isEmpty || _isGenericName(profile.name)) {
        final emailName = profile.email.trim().split('@').first;
        return profile.copyWith(
          name: emailName.isEmpty ? 'Estudiante' : emailName,
        );
      }
      return profile;
    } catch (error) {
      return null;
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final user = await _userService.getUser();
      if (user == null || _profile != null) return;
      
      _profile = StudentProfileEntity(
        id: user.id,
        name: user.name ?? 'Estudiante',
        email: user.email ?? '',
      );
    } catch (error) {
      debugPrint('No se pudo cargar el usuario local: $error');
    }
  }

  Future<void> _loadChatbotInteraction() async {
    final studentId = _profile?.id.trim() ?? '';
    if (studentId.isEmpty) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      _hasChatbotInteraction = preferences.getBool('student_chatbot_interaction_$studentId') ?? false;
    } catch (error) {
      _hasChatbotInteraction = false;
    }
  }

  bool _isGenericName(String name) {
    final normalized = name.toLowerCase().trim();
    return normalized == 'estudiante' || normalized == 'usuario' || normalized == 'nombre';
  }
}
