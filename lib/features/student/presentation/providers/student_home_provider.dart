import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';

import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';
import '../../domain/usecases/get_student_appointments_usecase.dart';
import '../../domain/usecases/schedule_appointment_usecase.dart';

class StudentHomeProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final GetVocationalResultsUseCase _getResultsUseCase;
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetStudentAppointmentsUseCase _getAppointmentsUseCase;
  final ScheduleAppointmentUseCase _scheduleAppointmentUseCase;
  final UserService _userService;
  final IApi _api;

  StudentHomeProvider({
    required GetStudentProfileUseCase getProfileUseCase,
    required GetVocationalResultsUseCase getResultsUseCase,
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetStudentAppointmentsUseCase getAppointmentsUseCase,
    required ScheduleAppointmentUseCase scheduleAppointmentUseCase,
    required UserService userService,
    required IApi api,
  })  : _getProfileUseCase = getProfileUseCase,
        _getResultsUseCase = getResultsUseCase,
        _getGamesUseCase = getGamesUseCase,
        _getAppointmentsUseCase = getAppointmentsUseCase,
        _scheduleAppointmentUseCase = scheduleAppointmentUseCase,
        _userService = userService,
        _api = api;

  StudentProfileEntity? _profile;
  List<VocationalResultEntity> _results = [];
  List<dynamic> _availableGames = [];
  List<dynamic> _studentGroups = [];
  List<AppointmentEntity> _appointments = [];

  bool _isLoading = false;
  String? _errorMessage;

  StudentProfileEntity? get profile => _profile;

  List<VocationalResultEntity> get results {
    return List.unmodifiable(_results);
  }

  List<dynamic> get availableGames {
    return List.unmodifiable(_availableGames);
  }

  List<dynamic> get studentGroups {
    return List.unmodifiable(_studentGroups);
  }

  List<AppointmentEntity> get appointments => _appointments;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasGroup => _studentGroups.isNotEmpty;

  String get firstName {
    final name = _profile?.name.trim();

    if (name != null &&
        name.isNotEmpty &&
        name.toLowerCase() != 'estudiante') {
      return name.split(' ').first;
    }

    final email = _profile?.email.trim();

    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Estudiante';
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) return null;

    final group = _studentGroups.first;

    if (group is Map<String, dynamic>) {
      return group;
    }

    if (group is Map) {
      return Map<String, dynamic>.from(group);
    }

    return null;
  }

  String get currentGroupName {
    return currentGroup?['name']?.toString() ??
        currentGroup?['groupName']?.toString() ??
        'Grupo asignado';
  }

  String get currentGroupCode {
    return currentGroup?['accessCode']?.toString() ??
        currentGroup?['access_code']?.toString() ??
        currentGroup?['code']?.toString() ??
        'Sin código';
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final profile = await _loadProfileSafely();

      if (profile != null) {
        _profile = profile;
      }

      _studentGroups = await _loadGroupsSafely();
      _results = await _loadResultsSafely();
      _availableGames = await _loadGamesSafely();
      _appointments = await _loadAppointmentsSafely();
    } catch (error) {
      debugPrint('Error en StudentHomeProvider: $error');

      _errorMessage =
      'No se pudo cargar la información del estudiante.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroupByCode(String accessCode) async {
    final code = accessCode.trim();

    if (code.isEmpty) {
      _errorMessage = 'Ingresa el código del grupo.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No hay sesión activa');
      }

      await _api.joinGroup(token, code);

      _studentGroups = await _api.getStudentGroups(token);

      return true;
    } catch (error) {
      final message = error.toString();

      if (message.contains('Ya eres miembro')) {
        final token = await _userService.getToken();

        if (token != null && token.isNotEmpty) {
          _studentGroups = await _api.getStudentGroups(token);
        }

        return true;
      }

      _errorMessage = message.replaceAll('Exception: ', '');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final user = await _userService.getUser();

      if (user != null && _profile == null) {
        _profile = StudentProfileEntity(
          id: user.id,
          name: _cleanName(user.name),
          email: user.email,
        );
      }
    } catch (error) {
      debugPrint('Usuario local no cargado: $error');
    }
  }

  Future<StudentProfileEntity?> _loadProfileSafely() async {
    try {
      final profile = await _getProfileUseCase();

      if (profile.name.trim().isEmpty ||
          profile.name.toLowerCase() == 'estudiante') {
        return profile.copyWith(
          name: profile.email.split('@').first,
        );
      }

      return profile;
    } catch (error) {
      debugPrint('Perfil remoto no cargado: $error');
      return null;
    }
  }

  Future<List<dynamic>> _loadGroupsSafely() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        return [];
      }

      return await _api.getStudentGroups(token);
    } catch (error) {
      return [];
    }
  }

  Future<List<VocationalResultEntity>>
  _loadResultsSafely() async {
    try {
      return await _getResultsUseCase();
    } catch (error) {
      return [];
    }
  }

  Future<List<dynamic>> _loadGamesSafely() async {
    try {
      return await _getGamesUseCase();
    } catch (error) {
      return [];
    }
  }

  Future<List<AppointmentEntity>> _loadAppointmentsSafely() async {
    try {
      return await _getAppointmentsUseCase();
    } catch (error) {
      debugPrint('Error cargando citas: $error');
      return [];
    }
  }

  Future<bool> scheduleAppointment(DateTime date, String motive) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleAppointmentUseCase(date, motive);
      _appointments = await _loadAppointmentsSafely();
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _cleanName(String? value) {
    final name = value?.trim();

    if (name == null || name.isEmpty) {
      return 'Estudiante';
    }

    return name;
  }
}
