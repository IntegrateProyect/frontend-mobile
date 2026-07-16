import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';

import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
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

  String? _sessionUserName;
  String? _sessionUserEmail;

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

  List<AppointmentEntity> get appointments {
    return List.unmodifiable(_appointments);
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasGroup {
    final profileGroup = _profile?.groupName?.trim() ?? '';

    return currentGroup != null || profileGroup.isNotEmpty;
  }

  String get studentDisplayName {
    return _resolveStudentName(
      remoteName: _profile?.name,
      localName: _sessionUserName,
      email: _profile?.email ?? _sessionUserEmail,
    );
  }

  String get firstName {
    final String displayName = studentDisplayName.trim();

    if (displayName.isEmpty) {
      return 'Estudiante';
    }

    return displayName
        .split(RegExp(r'\s+'))
        .first;
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) {
      return null;
    }

    return _unwrapGroup(
      _studentGroups.first,
    );
  }

  String get currentGroupName {
    final group = currentGroup;

    final String? name = _firstNonEmpty([
      group?['name'],
      group?['groupName'],
      group?['group_name'],
      group?['title'],
      _profile?.groupName,
    ]);

    return name ?? 'Sin grupo asignado';
  }

  String get currentGroupCode {
    final group = currentGroup;

    return _firstNonEmpty([
      group?['accessCode'],
      group?['access_code'],
      group?['groupCode'],
      group?['group_code'],
      group?['code'],
      _profile?.groupCode,
    ]) ??
        'Sin código';
  }

  String? get currentCounselorName {
    final group = currentGroup;

    if (group == null) {
      return null;
    }

    // Cuando el nombre viene directamente en el grupo.
    final String? directName = _firstValidPersonName([
      group['counselorName'],
      group['counselor_name'],
      group['counselorFullName'],
      group['counselor_full_name'],
      group['orientadorName'],
      group['orientador_name'],
      group['advisorName'],
      group['advisor_name'],
      group['tutorName'],
      group['tutor_name'],
    ]);

    if (directName != null) {
      return directName;
    }

    // Cuando el orientador viene como un objeto anidado.
    const nestedKeys = [
      'counselor',
      'orientador',
      'advisor',
      'tutor',
      'teacher',
      'counselorProfile',
      'counselor_profile',
      'orientadorProfile',
      'orientador_profile',
      'counselorUser',
      'counselor_user',
    ];

    for (final key in nestedKeys) {
      final String? name = _extractPersonName(
        group[key],
      );

      if (name != null) {
        return name;
      }
    }

    return null;
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final StudentProfileEntity? remoteProfile =
      await _loadProfileSafely();

      if (remoteProfile != null) {
        final String resolvedName = _resolveStudentName(
          remoteName: remoteProfile.name,
          localName: _sessionUserName ?? _profile?.name,
          email: remoteProfile.email.isNotEmpty
              ? remoteProfile.email
              : _sessionUserEmail,
        );

        final String resolvedEmail =
        remoteProfile.email.trim().isNotEmpty
            ? remoteProfile.email.trim()
            : (_sessionUserEmail ??
            _profile?.email ??
            '');

        _profile = remoteProfile.copyWith(
          name: resolvedName,
          email: resolvedEmail,
        );
      }

      _studentGroups = await _loadGroupsSafely();
      _results = await _loadResultsSafely();
      _availableGames = await _loadGamesSafely();
      _appointments = await _loadAppointmentsSafely();

      debugPrint(
        'Nombre del estudiante detectado: $studentDisplayName',
      );

      debugPrint(
        'Grupo actual detectado: $currentGroup',
      );

      debugPrint(
        'Orientador detectado: $currentCounselorName',
      );
    } catch (error) {
      debugPrint(
        'Error en StudentHomeProvider: $error',
      );

      _errorMessage =
      'No se pudo cargar la información del estudiante.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroupByCode(
      String accessCode,
      ) async {
    final String code = accessCode.trim();

    if (code.isEmpty) {
      _errorMessage = 'Ingresa el código del grupo.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No hay sesión activa');
      }

      await _api.joinGroup(token, code);

      _studentGroups =
      await _api.getStudentGroups(token);

      return true;
    } catch (error) {
      final String message = error.toString();

      if (message.contains('Ya eres miembro')) {
        final String? token =
        await _userService.getToken();

        if (token != null && token.isNotEmpty) {
          _studentGroups =
          await _api.getStudentGroups(token);
        }

        return true;
      }

      _errorMessage = message.replaceAll(
        'Exception: ',
        '',
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> scheduleAppointment(
      DateTime date,
      String motive,
      ) async {
    if (_profile == null) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleAppointmentUseCase(
        _profile!.id,
        date,
        motive,
      );

      _appointments =
      await _loadAppointmentsSafely();

      return true;
    } catch (error) {
      _errorMessage = error
          .toString()
          .replaceAll('Exception: ', '');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final user = await _userService.getUser();

      if (user == null) {
        return;
      }

      _sessionUserName = user.name?.trim();
      _sessionUserEmail = user.email.trim();

      if (_profile == null) {
        _profile = StudentProfileEntity(
          id: user.id,
          name: _resolveStudentName(
            remoteName: null,
            localName: user.name,
            email: user.email,
          ),
          email: user.email,
          profileImageUrl:
          user.avatarUrl ?? user.photoUrl,
        );
      }
    } catch (error) {
      debugPrint(
        'Usuario local no cargado: $error',
      );
    }
  }

  Future<StudentProfileEntity?>
  _loadProfileSafely() async {
    try {
      return await _getProfileUseCase();
    } catch (error) {
      debugPrint(
        'Perfil remoto no cargado: $error',
      );

      return null;
    }
  }

  Future<List<dynamic>>
  _loadGroupsSafely() async {
    try {
      final String? token =
      await _userService.getToken();

      if (token == null || token.isEmpty) {
        return [];
      }

      final groups =
      await _api.getStudentGroups(token);

      debugPrint(
        'Respuesta de grupos del estudiante: $groups',
      );

      return groups;
    } catch (error) {
      debugPrint(
        'Error cargando grupos: $error',
      );

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

  Future<List<dynamic>>
  _loadGamesSafely() async {
    try {
      return await _getGamesUseCase();
    } catch (error) {
      return [];
    }
  }

  Future<List<AppointmentEntity>>
  _loadAppointmentsSafely() async {
    try {
      return await _getAppointmentsUseCase();
    } catch (error) {
      debugPrint(
        'Error cargando citas: $error',
      );

      return [];
    }
  }

  String _resolveStudentName({
    required String? remoteName,
    required String? localName,
    required String? email,
  }) {
    final String? validName =
    _firstValidPersonName([
      remoteName,
      localName,
    ]);

    if (validName != null) {
      return validName;
    }

    return 'Estudiante';
  }

  Map<String, dynamic>? _unwrapGroup(
      dynamic value, {
        int depth = 0,
      }) {
    if (depth > 3) {
      return null;
    }

    if (value is! Map) {
      return null;
    }

    final Map<String, dynamic> map =
    Map<String, dynamic>.from(value);

    if (map['group'] is Map) {
      return _unwrapGroup(
        map['group'],
        depth: depth + 1,
      );
    }

    if (map['data'] is Map) {
      final nestedData = Map<String, dynamic>.from(
        map['data'] as Map,
      );

      if (nestedData['group'] is Map) {
        return _unwrapGroup(
          nestedData['group'],
          depth: depth + 1,
        );
      }
    }

    return map;
  }

  String? _extractPersonName(
      dynamic value, {
        int depth = 0,
      }) {
    if (depth > 4 || value == null) {
      return null;
    }

    if (value is String) {
      return _isValidPersonName(value)
          ? _cleanWhitespace(value)
          : null;
    }

    if (value is! Map) {
      return null;
    }

    final Map<String, dynamic> map =
    Map<String, dynamic>.from(value);

    final String? directName =
    _firstValidPersonName([
      map['name'],
      map['fullName'],
      map['full_name'],
      map['displayName'],
      map['display_name'],
      map['nombre'],
      map['nombreCompleto'],
      map['nombre_completo'],
    ]);

    if (directName != null) {
      return directName;
    }

    final String? firstName = _firstNonEmpty([
      map['firstName'],
      map['first_name'],
      map['nombre'],
    ]);

    final String? lastName = _firstNonEmpty([
      map['lastName'],
      map['last_name'],
      map['apellido'],
      map['apellidos'],
    ]);

    final String composedName = [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].join(' ').trim();

    if (_isValidPersonName(composedName)) {
      return _cleanWhitespace(composedName);
    }

    const nestedKeys = [
      'user',
      'profile',
      'person',
      'account',
      'data',
      'counselor',
      'orientador',
    ];

    for (final key in nestedKeys) {
      final String? nestedName =
      _extractPersonName(
        map[key],
        depth: depth + 1,
      );

      if (nestedName != null) {
        return nestedName;
      }
    }

    return null;
  }

  String? _firstValidPersonName(
      Iterable<dynamic> values,
      ) {
    for (final value in values) {
      final String text =
          value?.toString().trim() ?? '';

      if (_isValidPersonName(text)) {
        return _cleanWhitespace(text);
      }
    }

    return null;
  }

  String? _firstNonEmpty(
      Iterable<dynamic> values,
      ) {
    for (final value in values) {
      final String text =
          value?.toString().trim() ?? '';

      if (text.isNotEmpty &&
          text.toLowerCase() != 'null' &&
          text.toLowerCase() != 'undefined') {
        return text;
      }
    }

    return null;
  }

  bool _isValidPersonName(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return false;
    }

    final String normalized = text
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    const invalidNames = {
      'sin',
      'sin nombre',
      'estudiante',
      'student',
      'usuario',
      'user',
      'por asignar',
      'sin asignar',
      'no asignado',
      'null',
      'undefined',
    };

    if (invalidNames.contains(normalized)) {
      return false;
    }

    if (text.contains('@')) {
      return false;
    }

    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{12}$',
    );

    if (uuidRegex.hasMatch(text)) {
      return false;
    }

    if (RegExp(r'^\d+$').hasMatch(text)) {
      return false;
    }

    if (!text.contains(' ') &&
        RegExp(r'^[a-zA-Z0-9_-]{18,}$')
            .hasMatch(text)) {
      return false;
    }

    return true;
  }

  String _cleanWhitespace(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}