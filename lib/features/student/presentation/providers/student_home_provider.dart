import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/student_counselor_entity.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/get_student_appointments_usecase.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';
import '../../domain/usecases/schedule_appointment_usecase.dart';

class StudentHomeProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final GetVocationalResultsUseCase _getResultsUseCase;
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetStudentAppointmentsUseCase _getAppointmentsUseCase;
  final ScheduleAppointmentUseCase _scheduleAppointmentUseCase;
  final GetEventsUseCase _getEventsUseCase;
  final UserService _userService;
  final IApi _api;

  StudentHomeProvider({
    required GetStudentProfileUseCase getProfileUseCase,
    required GetVocationalResultsUseCase getResultsUseCase,
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetStudentAppointmentsUseCase getAppointmentsUseCase,
    required ScheduleAppointmentUseCase scheduleAppointmentUseCase,
    required GetEventsUseCase getEventsUseCase,
    required UserService userService,
    required IApi api,
  })  : _getProfileUseCase = getProfileUseCase,
        _getResultsUseCase = getResultsUseCase,
        _getGamesUseCase = getGamesUseCase,
        _getAppointmentsUseCase = getAppointmentsUseCase,
        _scheduleAppointmentUseCase = scheduleAppointmentUseCase,
        _getEventsUseCase = getEventsUseCase,
        _userService = userService,
        _api = api;

  StudentProfileEntity? _profile;
  StudentCounselorEntity? _counselor;

  List<VocationalResultEntity> _results = [];
  List<dynamic> _availableGames = [];
  List<dynamic> _studentGroups = [];
  List<AppointmentEntity> _appointments = [];
  List<EventEntity> _events = [];

  bool _isLoading = false;
  bool _hasChatbotInteraction = false;
  String? _errorMessage;

  StudentProfileEntity? get profile => _profile;
  StudentCounselorEntity? get counselor => _counselor;

  List<VocationalResultEntity> get results =>
      List.unmodifiable(_results);

  List<dynamic> get availableGames =>
      List.unmodifiable(_availableGames);

  List<dynamic> get studentGroups =>
      List.unmodifiable(_studentGroups);

  List<AppointmentEntity> get appointments =>
      List.unmodifiable(_appointments);

  List<EventEntity> get events => List.unmodifiable(_events);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChatbotInteraction => _hasChatbotInteraction;
  bool get hasVocationalResults => _results.isNotEmpty;

  bool get hasStartedGames {
    if (_results.isNotEmpty) return true;

    return _availableGames.any((game) {
      final data = _asMap(game);
      if (data == null) return false;

      final status = _gameStatus(data);
      final progress = _toDouble(
        data['progress'] ??
            data['progressPercentage'] ??
            data['progress_percentage'] ??
            data['completionPercentage'] ??
            data['completion_percentage'],
      );

      final attempts = _toInt(
        data['attempts'] ??
            data['attemptCount'] ??
            data['attempt_count'],
      );

      final hasSession = _cleanOptionalValue(
        data['sessionId'] ??
            data['session_id'] ??
            data['activeSessionId'],
      ) !=
          null;

      return status == 'STARTED' ||
          status == 'IN_PROGRESS' ||
          status == 'COMPLETED' ||
          status == 'FINISHED' ||
          progress > 0 ||
          attempts > 0 ||
          hasSession;
    });
  }

  bool get hasCompletedGames {
    if (_results.isNotEmpty) return true;
    if (_availableGames.isEmpty) return false;

    final gameMaps = _availableGames
        .map(_asMap)
        .whereType<Map<String, dynamic>>()
        .toList();

    if (gameMaps.isEmpty) return false;

    return gameMaps.every((data) {
      final status = _gameStatus(data);
      final progress = _toDouble(
        data['progress'] ??
            data['progressPercentage'] ??
            data['progress_percentage'] ??
            data['completionPercentage'] ??
            data['completion_percentage'],
      );

      final completedValue =
          data['completed'] ?? data['isCompleted'] ?? data['is_completed'];

      return status == 'COMPLETED' ||
          status == 'FINISHED' ||
          progress >= 100 ||
          completedValue == true;
    });
  }

  /// Comprueba tanto la respuesta de GET /students/groups como
  /// los datos de grupo que puedan venir dentro del perfil.
  bool get hasGroup {
    if (_studentGroups.isNotEmpty) return true;

    final groupName = _validGroupValue(_profile?.groupName);
    final groupCode = _validGroupValue(_profile?.groupCode);

    return groupName != null || groupCode != null;
  }

  bool get hasCounselor {
    final counselorName = _counselor?.name.trim() ?? '';

    return counselorName.isNotEmpty &&
        !_isInvalidValue(counselorName) &&
        counselorName.toLowerCase() != 'por asignar';
  }

  String get firstName {
    final fullName = _profile?.name.trim() ?? '';

    if (fullName.isEmpty || _isGenericName(fullName)) {
      final email = _profile?.email.trim();

      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }

      return 'Estudiante';
    }

    final firstPart = fullName.split(RegExp(r'\s+')).first;

    if (_isGenericName(firstPart)) {
      final email = _profile?.email.trim();
      return email != null && email.isNotEmpty
          ? email.split('@').first
          : 'Estudiante';
    }

    return firstPart;
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) return null;

    final firstGroup = _studentGroups.first;

    if (firstGroup is Map<String, dynamic>) return firstGroup;

    if (firstGroup is Map) {
      return Map<String, dynamic>.from(firstGroup);
    }

    return null;
  }

  String get currentGroupName {
    final group = currentGroup;

    if (group != null) {
      final possibleNames = [
        group['name'],
        group['groupName'],
        group['group_name'],
        group['nombre'],
      ];

      for (final value in possibleNames) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }

    return _validGroupValue(_profile?.groupName) ??
        'Sin grupo asignado';
  }

  String get currentGroupCode {
    final group = currentGroup;

    if (group != null) {
      final possibleCodes = [
        group['accessCode'],
        group['access_code'],
        group['code'],
        group['groupCode'],
      ];

      for (final value in possibleCodes) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }

    return _validGroupValue(_profile?.groupCode) ?? 'Sin código';
  }

  String? get currentCounselorName {
    final endpointName = _cleanOptionalValue(_counselor?.name);

    if (endpointName != null &&
        endpointName.toLowerCase() != 'por asignar') {
      return endpointName;
    }

    return _getCounselorNameFromGroup();
  }

  String? get currentCounselorEmail {
    final email = _cleanOptionalValue(_counselor?.email);
    if (email != null) return email;

    final group = currentGroup;
    if (group == null) return null;

    final counselorData = group['counselor'];

    if (counselorData is Map) {
      return _cleanOptionalValue(counselorData['email']);
    }

    return _cleanOptionalValue(
      group['counselorEmail'] ?? group['counselor_email'],
    );
  }

  Future<void> loadHomeData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final loadedProfile = await _loadProfileSafely();
      if (loadedProfile != null) _profile = loadedProfile;

      _studentGroups = await _loadGroupsSafely();
      await _loadChatbotInteraction();

      // Solo consulta orientador y citas si ya pertenece a un grupo.
      if (hasGroup) {
        _counselor = await _loadCounselorSafely();
        _appointments = await _loadAppointmentsSafely();
      } else {
        _counselor = null;
        _appointments = [];
      }

      _results = await _loadResultsSafely();
      _availableGames = await _loadGamesSafely();
      _events = await _loadEventsSafely();
    } catch (error, stackTrace) {
      debugPrint('Error cargando inicio del estudiante: $error');
      debugPrintStack(stackTrace: stackTrace);
      _errorMessage =
      'No fue posible cargar toda la información del inicio.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHomeData() => loadHomeData();

  /// Une al alumno al grupo y actualiza inmediatamente todos los datos
  /// dependientes del grupo.
  Future<bool> joinGroupByCode(String accessCode) async {
    final cleanCode = accessCode.trim();

    if (cleanCode.isEmpty) {
      _errorMessage = 'Escribe el código del grupo.';
      notifyListeners();
      return false;
    }

    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception('No existe una sesión activa.');
      }

      await _api.joinGroup(token.trim(), cleanCode);

      _studentGroups = await _loadGroupsSafely();

      // Respaldo visual si el backend tarda unos instantes en reflejar
      // el grupo en GET /students/groups.
      if (_studentGroups.isEmpty && _profile != null) {
        _profile = _profile!.copyWith(groupCode: cleanCode);
      }

      _counselor = await _loadCounselorSafely();
      _appointments = await _loadAppointmentsSafely();

      return true;
    } catch (error) {
      _errorMessage =
          error.toString().replaceFirst('Exception: ', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markChatbotInteraction() async {
    if (_hasChatbotInteraction) return;

    _hasChatbotInteraction = true;
    notifyListeners();

    final studentId = _profile?.id.trim() ?? '';
    if (studentId.isEmpty) return;

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(
        'student_chatbot_interaction_$studentId',
        true,
      );
    } catch (error) {
      debugPrint('No se pudo guardar el progreso del chatbot: $error');
    }
  }

  Future<bool> scheduleAppointment(
      DateTime date,
      String motive,
      ) async {
    final cleanMotive = motive.trim();

    if (!hasGroup) {
      _errorMessage =
      'Primero debes unirte a un grupo para solicitar una cita.';
      notifyListeners();
      return false;
    }

    if (_profile == null) {
      _errorMessage = 'No se encontró la información del estudiante.';
      notifyListeners();
      return false;
    }

    if (!date.isAfter(DateTime.now())) {
      _errorMessage = 'La fecha de la cita debe ser una fecha futura.';
      notifyListeners();
      return false;
    }

    if (cleanMotive.isEmpty) {
      _errorMessage = 'Debes escribir el motivo de la cita.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleAppointmentUseCase(
        _profile!.id,
        date,
        cleanMotive,
      );

      _appointments = await _loadAppointmentsSafely();
      return true;
    } catch (error) {
      _errorMessage =
          error.toString().replaceFirst('Exception: ', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<StudentProfileEntity?> _loadProfileSafely() async {
    try {
      final profile = await _getProfileUseCase();

      if (profile.name.trim().isEmpty ||
          _isGenericName(profile.name)) {
        final emailName = profile.email.trim().split('@').first;

        return profile.copyWith(
          name: emailName.isEmpty ? 'Estudiante' : emailName,
        );
      }

      return profile;
    } catch (error) {
      debugPrint('No se pudo cargar el perfil: $error');
      return null;
    }
  }

  Future<List<dynamic>> _loadGroupsSafely() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) return [];

      final response = await _api.getStudentGroups(token.trim());

      // Evita considerar elementos vacíos como grupos válidos.
      return response.where((item) {
        if (item is Map) return item.isNotEmpty;
        return item != null;
      }).toList();
    } catch (error) {
      debugPrint('No se pudieron cargar los grupos: $error');
      return [];
    }
  }

  Future<StudentCounselorEntity?> _loadCounselorSafely() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) return null;

      final response = await _api.getStudentCounselor(token.trim());
      if (response.isEmpty) return null;

      final counselor = StudentCounselorEntity.fromJson(response);

      if (counselor.id.isEmpty &&
          counselor.name == 'Por asignar' &&
          counselor.email.isEmpty) {
        return null;
      }

      return counselor;
    } catch (error) {
      debugPrint('No se pudo cargar el orientador: $error');
      return null;
    }
  }

  Future<List<VocationalResultEntity>> _loadResultsSafely() async {
    try {
      return await _getResultsUseCase();
    } catch (error) {
      debugPrint('No se pudieron cargar los resultados: $error');
      return [];
    }
  }

  Future<List<dynamic>> _loadGamesSafely() async {
    try {
      return await _getGamesUseCase();
    } catch (error) {
      debugPrint('No se pudieron cargar los juegos: $error');
      return [];
    }
  }

  Future<List<AppointmentEntity>> _loadAppointmentsSafely() async {
    try {
      return await _getAppointmentsUseCase();
    } catch (error) {
      debugPrint('No se pudieron cargar las citas: $error');
      return [];
    }
  }

  Future<List<EventEntity>> _loadEventsSafely() async {
    try {
      return await _getEventsUseCase();
    } catch (error) {
      debugPrint('No se pudieron cargar los eventos: $error');
      return [];
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final user = await _userService.getUser();

      if (user == null || _profile != null) return;

      _profile = StudentProfileEntity(
        id: user.id,
        name: _cleanName(user.name),
        email: user.email,
      );
    } catch (error) {
      debugPrint('No se pudo cargar el usuario local: $error');
    }
  }

  Future<void> _loadChatbotInteraction() async {
    final studentId = _profile?.id.trim() ?? '';

    if (studentId.isEmpty) {
      _hasChatbotInteraction = false;
      return;
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      _hasChatbotInteraction = preferences.getBool(
        'student_chatbot_interaction_$studentId',
      ) ??
          false;
    } catch (error) {
      debugPrint('No se pudo cargar el progreso del chatbot: $error');
      _hasChatbotInteraction = false;
    }
  }

  String? _getCounselorNameFromGroup() {
    final group = currentGroup;
    if (group == null) return null;

    final counselorData = group['counselor'];

    if (counselorData is Map) {
      final possibleNames = [
        counselorData['name'],
        counselorData['fullName'],
        counselorData['nombre'],
      ];

      for (final value in possibleNames) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }

    final possibleGroupValues = [
      group['counselorName'],
      group['counselor_name'],
      group['orientador'],
      counselorData is String ? counselorData : null,
    ];

    for (final value in possibleGroupValues) {
      final text = _cleanOptionalValue(value);
      if (text != null) return text;
    }

    return null;
  }

  String _cleanName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty ||
        _isGenericName(name) ||
        _isInvalidValue(name)) {
      return 'Estudiante';
    }

    return name;
  }

  String? _validGroupValue(dynamic value) {
    final text = _cleanOptionalValue(value);
    if (text == null) return null;

    final normalized = text.toLowerCase();

    if (normalized == 'sin grupo' ||
        normalized == 'sin grupo asignado' ||
        normalized == 'sin código' ||
        normalized == 'por asignar') {
      return null;
    }

    return text;
  }

  String? _cleanOptionalValue(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || _isInvalidValue(text) ? null : text;
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  String _gameStatus(Map<String, dynamic> data) {
    return (data['status'] ??
        data['progressStatus'] ??
        data['progress_status'] ??
        data['state'] ??
        '')
        .toString()
        .trim()
        .toUpperCase();
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _isInvalidValue(String value) {
    final normalized = value.toLowerCase().trim();

    return normalized == 'null' ||
        normalized == 'undefined' ||
        normalized == 'n/a';
  }

  bool _isGenericName(String name) {
    final normalized = name.toLowerCase().trim();

    return normalized == 'estudiante' ||
        normalized == 'sin nombre' ||
        normalized == 'sin asignar' ||
        normalized == 'usuario' ||
        normalized == 'nombre' ||
        normalized == 'apellido' ||
        normalized == 'sin';
  }
}