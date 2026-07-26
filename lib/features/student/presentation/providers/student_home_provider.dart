import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';

import '../../domain/entities/student_counselor_entity.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';

import '../../../counselor/domain/entities/appointment_entity.dart';

import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';
import '../../domain/usecases/get_student_appointments_usecase.dart';
import '../../domain/usecases/schedule_appointment_usecase.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';

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

  List<EventEntity> get events =>
      List.unmodifiable(_events);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasGroup => _studentGroups.isNotEmpty;

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

      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }

      return 'Estudiante';
    }

    return firstPart;
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) {
      return null;
    }

    final dynamic firstGroup = _studentGroups.first;

    if (firstGroup is Map<String, dynamic>) {
      return firstGroup;
    }

    if (firstGroup is Map) {
      return Map<String, dynamic>.from(firstGroup);
    }

    return null;
  }

  String get currentGroupName {
    final group = currentGroup;

    if (group == null) {
      return _cleanProfileGroupName();
    }

    final possibleNames = [
      group['name'],
      group['groupName'],
      group['group_name'],
      group['nombre'],
    ];

    for (final value in possibleNames) {
      final text = _cleanOptionalValue(value);

      if (text != null) {
        return text;
      }
    }

    return _cleanProfileGroupName();
  }

  String get currentGroupCode {
    final group = currentGroup;

    if (group == null) {
      final profileCode = _cleanOptionalValue(
        _profile?.groupCode,
      );

      return profileCode ?? 'Sin código';
    }

    final possibleCodes = [
      group['accessCode'],
      group['access_code'],
      group['code'],
      group['groupCode'],
    ];

    for (final value in possibleCodes) {
      final text = _cleanOptionalValue(value);

      if (text != null) {
        return text;
      }
    }

    final profileCode = _cleanOptionalValue(
      _profile?.groupCode,
    );

    return profileCode ?? 'Sin código';
  }

  /// Primero utiliza GET /students/counselor.
  /// Si el endpoint no devuelve información, busca al orientador
  /// dentro de la información del grupo.
  String? get currentCounselorName {
    final endpointCounselorName = _cleanOptionalValue(
      _counselor?.name,
    );

    if (endpointCounselorName != null &&
        endpointCounselorName.toLowerCase() != 'por asignar') {
      return endpointCounselorName;
    }

    return _getCounselorNameFromGroup();
  }

  String? get currentCounselorEmail {
    final email = _cleanOptionalValue(
      _counselor?.email,
    );

    if (email != null) {
      return email;
    }

    final group = currentGroup;

    if (group == null) {
      return null;
    }

    final counselorData = group['counselor'];

    if (counselorData is Map) {
      return _cleanOptionalValue(
        counselorData['email'],
      );
    }

    return _cleanOptionalValue(
      group['counselorEmail'] ??
          group['counselor_email'],
    );
  }

  Future<void> loadHomeData() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final loadedProfile = await _loadProfileSafely();

      if (loadedProfile != null) {
        _profile = loadedProfile;
      }

      _studentGroups = await _loadGroupsSafely();

      // Nuevo: obtiene el orientador directamente del endpoint.
      _counselor = await _loadCounselorSafely();

      _results = await _loadResultsSafely();
      _availableGames = await _loadGamesSafely();
      _appointments = await _loadAppointmentsSafely();
      _events = await _loadEventsSafely();
    } catch (error, stackTrace) {
      debugPrint(
        'Error cargando inicio del estudiante: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage =
      'No fue posible cargar toda la información del inicio.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  Future<bool> scheduleAppointment(
      DateTime date,
      String motive,
      ) async {
    final cleanMotive = motive.trim();

    if (_profile == null) {
      _errorMessage =
      'No se encontró la información del estudiante.';
      notifyListeners();
      return false;
    }

    if (!date.isAfter(DateTime.now())) {
      _errorMessage =
      'La fecha de la cita debe ser una fecha futura.';
      notifyListeners();
      return false;
    }

    if (cleanMotive.isEmpty) {
      _errorMessage =
      'Debes escribir el motivo de la cita.';
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
      _errorMessage = error
          .toString()
          .replaceFirst('Exception: ', '');

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
        final emailName = profile.email
            .trim()
            .split('@')
            .first;

        return profile.copyWith(
          name: emailName.isEmpty
              ? 'Estudiante'
              : emailName,
        );
      }

      return profile;
    } catch (error) {
      debugPrint(
        'No se pudo cargar el perfil: $error',
      );

      return null;
    }
  }

  Future<List<dynamic>> _loadGroupsSafely() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) {
        return [];
      }

      return await _api.getStudentGroups(
        token.trim(),
      );
    } catch (error) {
      debugPrint(
        'No se pudieron cargar los grupos: $error',
      );

      return [];
    }
  }

  Future<StudentCounselorEntity?>
  _loadCounselorSafely() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.trim().isEmpty) {
        return null;
      }

      final response = await _api.getStudentCounselor(
        token.trim(),
      );

      if (response.isEmpty) {
        return null;
      }

      final counselor =
      StudentCounselorEntity.fromJson(response);

      if (counselor.id.isEmpty &&
          counselor.name == 'Por asignar' &&
          counselor.email.isEmpty) {
        return null;
      }

      return counselor;
    } catch (error) {
      // El inicio sigue funcionando aunque todavía
      // no exista un orientador asignado.
      debugPrint(
        'No se pudo cargar el orientador: $error',
      );

      return null;
    }
  }

  Future<List<VocationalResultEntity>>
  _loadResultsSafely() async {
    try {
      return await _getResultsUseCase();
    } catch (error) {
      debugPrint(
        'No se pudieron cargar los resultados: $error',
      );

      return [];
    }
  }

  Future<List<dynamic>> _loadGamesSafely() async {
    try {
      return await _getGamesUseCase();
    } catch (error) {
      debugPrint(
        'No se pudieron cargar los juegos: $error',
      );

      return [];
    }
  }

  Future<List<AppointmentEntity>>
  _loadAppointmentsSafely() async {
    try {
      return await _getAppointmentsUseCase();
    } catch (error) {
      debugPrint(
        'No se pudieron cargar las citas: $error',
      );

      return [];
    }
  }

  Future<List<EventEntity>> _loadEventsSafely() async {
    try {
      return await _getEventsUseCase();
    } catch (error) {
      debugPrint(
        'No se pudieron cargar los eventos: $error',
      );

      return [];
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final user = await _userService.getUser();

      if (user == null || _profile != null) {
        return;
      }

      _profile = StudentProfileEntity(
        id: user.id,
        name: _cleanName(user.name),
        email: user.email,
      );
    } catch (error) {
      debugPrint(
        'No se pudo cargar el usuario local: $error',
      );
    }
  }

  String? _getCounselorNameFromGroup() {
    final group = currentGroup;

    if (group == null) {
      return null;
    }

    final counselorData = group['counselor'];

    if (counselorData is Map) {
      final possibleNames = [
        counselorData['name'],
        counselorData['fullName'],
        counselorData['nombre'],
      ];

      for (final value in possibleNames) {
        final text = _cleanOptionalValue(value);

        if (text != null) {
          return text;
        }
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

      if (text != null) {
        return text;
      }
    }

    return null;
  }

  String _cleanProfileGroupName() {
    final profileGroupName = _cleanOptionalValue(
      _profile?.groupName,
    );

    return profileGroupName ?? 'Sin grupo asignado';
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

  String? _cleanOptionalValue(dynamic value) {
    final text = value?.toString().trim() ?? '';

    if (text.isEmpty || _isInvalidValue(text)) {
      return null;
    }

    return text;
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