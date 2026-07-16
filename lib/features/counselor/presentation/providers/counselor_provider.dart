import 'package:flutter/material.dart';

import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/entities/student_file_entity.dart';

import '../../domain/usecases/assign_task_usecase.dart';
import '../../domain/usecases/create_group_usecase.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/get_counselor_appointments_usecase.dart';
import '../../domain/usecases/get_counselor_profile_usecase.dart';
import '../../domain/usecases/get_counselor_stats_usecase.dart';
import '../../domain/usecases/get_counselor_students_usecase.dart';
import '../../domain/usecases/get_group_details_usecase.dart';
import '../../domain/usecases/get_group_students_usecase.dart';
import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/get_student_file_usecase.dart';
import '../../domain/usecases/register_session_usecase.dart';
import '../../domain/usecases/schedule_counselor_appointment_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';

class CounselorProvider extends ChangeNotifier {
  final GetGroupsUseCase _getGroupsUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final GetGroupDetailsUseCase _getGroupDetailsUseCase;
  final RegisterSessionUseCase _registerSessionUseCase;
  final AssignTaskUseCase _assignTaskUseCase;
  final GetConsultationsUseCase _getConsultationsUseCase;
  final GetCounselorProfileUseCase _getCounselorProfileUseCase;
  final GetCounselorStatsUseCase _getCounselStatsUseCase;
  final GetCounselorStudentsUseCase _getStudentsUseCase;
  final GetStudentFileUseCase _getStudentFileUseCase;
  final GetCounselorAppointmentsUseCase _getAppointmentsUseCase;
  final GetGroupStudentsUseCase _getGroupStudentsUseCase;
  final ScheduleCounselorAppointmentUseCase
  _scheduleAppointmentUseCase;

  CounselorProvider({
    required GetGroupsUseCase getGroupsUseCase,
    required CreateGroupUseCase createGroupUseCase,
    required UpdateGroupUseCase updateGroupUseCase,
    required GetGroupDetailsUseCase getGroupDetailsUseCase,
    required RegisterSessionUseCase registerSessionUseCase,
    required AssignTaskUseCase assignTaskUseCase,
    required GetConsultationsUseCase getConsultationsUseCase,
    required GetCounselorProfileUseCase getCounselorProfileUseCase,
    required GetCounselorStatsUseCase getCounselorStatsUseCase,
    required GetCounselorStudentsUseCase getStudentsUseCase,
    required GetStudentFileUseCase getStudentFileUseCase,
    required GetCounselorAppointmentsUseCase getAppointmentsUseCase,
    required GetGroupStudentsUseCase getGroupStudentsUseCase,
    required ScheduleCounselorAppointmentUseCase
    scheduleAppointmentUseCase,
  })  : _getGroupsUseCase = getGroupsUseCase,
        _createGroupUseCase = createGroupUseCase,
        _updateGroupUseCase = updateGroupUseCase,
        _getGroupDetailsUseCase = getGroupDetailsUseCase,
        _registerSessionUseCase = registerSessionUseCase,
        _assignTaskUseCase = assignTaskUseCase,
        _getConsultationsUseCase = getConsultationsUseCase,
        _getCounselorProfileUseCase = getCounselorProfileUseCase,
        _getCounselStatsUseCase = getCounselorStatsUseCase,
        _getStudentsUseCase = getStudentsUseCase,
        _getStudentFileUseCase = getStudentFileUseCase,
        _getAppointmentsUseCase = getAppointmentsUseCase,
        _getGroupStudentsUseCase = getGroupStudentsUseCase,
        _scheduleAppointmentUseCase = scheduleAppointmentUseCase;

  CounselorProfileEntity? _profile;

  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  List<AppointmentEntity> _appointments = [];

  Map<String, dynamic> _stats = {};

  StudentFileEntity? _currentStudentFile;

  bool _isLoading = false;
  bool _isLoadingFile = false;
  bool _isLoadingGroupStudents = false;

  String? _errorMessage;

  // =========================================================
  // GETTERS
  // =========================================================

  CounselorProfileEntity? get profile => _profile;

  List<dynamic> get groups {
    return List<dynamic>.unmodifiable(_groups);
  }

  List<StudentProfileEntity> get students {
    return List<StudentProfileEntity>.unmodifiable(_students);
  }

  List<StudentConsultationEntity> get consultations {
    return List<StudentConsultationEntity>.unmodifiable(
      _consultations,
    );
  }

  List<AppointmentEntity> get appointments {
    return List<AppointmentEntity>.unmodifiable(
      _appointments,
    );
  }

  StudentFileEntity? get currentStudentFile {
    return _currentStudentFile;
  }

  Map<String, dynamic> get stats {
    return Map<String, dynamic>.unmodifiable(_stats);
  }

  bool get isLoading => _isLoading;

  bool get isLoadingFile => _isLoadingFile;

  bool get isLoadingGroupStudents {
    return _isLoadingGroupStudents;
  }

  String? get errorMessage => _errorMessage;

  // =========================================================
  // CONTADORES
  // =========================================================

  int get totalStudentsCount {
    final int apiValue = _toInt(
      _stats['totalStudents'] ??
          _stats['total_students'],
    );

    return apiValue > 0
        ? apiValue
        : _students.length;
  }

  int get activeStudentsCount {
    return _toInt(
      _stats['activeStudents'] ??
          _stats['active_students'],
    );
  }

  int get lowProgressCount {
    return _toInt(
      _stats['lowProgress'] ??
          _stats['low_progress'],
    );
  }

  int get highIndecisionCount {
    return _toInt(
      _stats['highIndecision'] ??
          _stats['high_indecision'],
    );
  }

  int get solicitudesCount {
    return _toInt(
      _stats['requests'] ??
          _stats['solicitudes'],
    );
  }

  int get groupsCount {
    final int apiValue = _toInt(
      _stats['groups'] ??
          _stats['totalGroups'] ??
          _stats['total_groups'],
    );

    return apiValue > 0
        ? apiValue
        : _groups.length;
  }

  int get reportesCount {
    return _toInt(
      _stats['reports'] ??
          _stats['reportes'],
    );
  }

  // =========================================================
  // DASHBOARD
  // =========================================================

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      /*
       * Cada carga se protege individualmente.
       * Si un endpoint falla, los demás datos continúan cargando.
       */
      final List<dynamic> groupsResult =
      await _loadGroupsSafely();

      final List<StudentConsultationEntity>
      consultationsResult =
      await _loadConsultationsSafely();

      final CounselorProfileEntity? profileResult =
      await _loadProfileSafely();

      final Map<String, dynamic> statsResult =
      await _loadStatsSafely();

      final List<StudentProfileEntity> studentsResult =
      await _loadStudentsSafely();

      final List<AppointmentEntity> appointmentsResult =
      await _loadAppointmentsSafely();

      _groups = groupsResult;
      _consultations = consultationsResult;
      _profile = profileResult;
      _stats = statsResult;
      _students = _removeDuplicatedStudents(
        studentsResult,
      );
      _appointments = appointmentsResult;

      debugPrint(
        '========================================',
      );
      debugPrint(
        'DASHBOARD DEL ORIENTADOR CARGADO',
      );
      debugPrint(
        'Grupos: ${_groups.length}',
      );
      debugPrint(
        'Alumnos: ${_students.length}',
      );
      debugPrint(
        'Consultas: ${_consultations.length}',
      );
      debugPrint(
        'Citas: ${_appointments.length}',
      );
      debugPrint(
        'Estadísticas: $_stats',
      );

      for (final student in _students) {
        debugPrint(
          'ALUMNO DASHBOARD: '
              'id=${student.id} | '
              'nombre=${student.name} | '
              'correo=${student.email}',
        );
      }

      debugPrint(
        '========================================',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR GENERAL EN COUNSELOR PROVIDER: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> _loadGroupsSafely() async {
    try {
      final List<dynamic> result =
      await _getGroupsUseCase.call();

      debugPrint(
        'GRUPOS CARGADOS: ${result.length}',
      );

      return result;
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO GRUPOS: $error',
      );

      return <dynamic>[];
    }
  }

  Future<List<StudentConsultationEntity>>
  _loadConsultationsSafely() async {
    try {
      final result =
      await _getConsultationsUseCase.call();

      return List<StudentConsultationEntity>.from(
        result,
      );
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO CONSULTAS: $error',
      );

      return <StudentConsultationEntity>[];
    }
  }

  Future<CounselorProfileEntity?>
  _loadProfileSafely() async {
    try {
      return await _getCounselorProfileUseCase.call();
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO PERFIL DEL ORIENTADOR: $error',
      );

      return null;
    }
  }

  Future<Map<String, dynamic>>
  _loadStatsSafely() async {
    try {
      final result =
      await _getCounselStatsUseCase.call();

      return Map<String, dynamic>.from(result);
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO ESTADÍSTICAS: $error',
      );

      return <String, dynamic>{};
    }
  }

  Future<List<StudentProfileEntity>>
  _loadStudentsSafely() async {
    try {
      final dynamic result =
      await _getStudentsUseCase.call();

      if (result is! List) {
        debugPrint(
          'RESPUESTA INVÁLIDA AL CARGAR ALUMNOS: '
              '${result.runtimeType}',
        );

        return <StudentProfileEntity>[];
      }

      final List<StudentProfileEntity> students =
      result
          .whereType<StudentProfileEntity>()
          .toList();

      debugPrint(
        'ALUMNOS GENERALES CARGADOS: '
            '${students.length}',
      );

      return students;
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO ALUMNOS GENERALES: $error',
      );

      return <StudentProfileEntity>[];
    }
  }

  Future<List<AppointmentEntity>>
  _loadAppointmentsSafely() async {
    try {
      final result =
      await _getAppointmentsUseCase.call();

      return List<AppointmentEntity>.from(
        result,
      );
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO CITAS: $error',
      );

      return <AppointmentEntity>[];
    }
  }

  // =========================================================
  // ALUMNOS DE UN GRUPO
  // =========================================================

  Future<List<StudentProfileEntity>> getGroupStudents(
      String groupId,
      ) async {
    final String cleanGroupId = groupId.trim();

    if (cleanGroupId.isEmpty) {
      throw Exception(
        'El identificador del grupo está vacío',
      );
    }

    _isLoadingGroupStudents = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint(
        'SOLICITANDO ALUMNOS DEL GRUPO: '
            '$cleanGroupId',
      );

      final List<StudentProfileEntity> result =
      await _getGroupStudentsUseCase.call(
        cleanGroupId,
      );

      final List<StudentProfileEntity> students =
      _removeDuplicatedStudents(result);

      debugPrint(
        'PROVIDER RECIBIÓ ${students.length} '
            'ALUMNOS DEL GRUPO $cleanGroupId',
      );

      for (final student in students) {
        debugPrint(
          'ALUMNO DEL GRUPO: '
              'id=${student.id} | '
              'nombre=${student.name} | '
              'correo=${student.email}',
        );
      }

      return students;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR CARGANDO ALUMNOS DEL GRUPO '
            '$cleanGroupId: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      rethrow;
    } finally {
      _isLoadingGroupStudents = false;
      notifyListeners();
    }
  }

  // =========================================================
  // EXPEDIENTE DEL ALUMNO
  // =========================================================

  Future<void> loadStudentFile(
      String studentId,
      ) async {
    final String cleanStudentId = studentId.trim();

    if (cleanStudentId.isEmpty) {
      _errorMessage =
      'El identificador del alumno está vacío.';
      notifyListeners();
      return;
    }

    _isLoadingFile = true;
    _errorMessage = null;
    _currentStudentFile = null;
    notifyListeners();

    try {
      _currentStudentFile =
      await _getStudentFileUseCase.call(
        cleanStudentId,
      );

      debugPrint(
        'EXPEDIENTE CARGADO PARA EL ALUMNO: '
            '$cleanStudentId',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR CARGANDO EXPEDIENTE DEL ALUMNO: '
            '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);
    } finally {
      _isLoadingFile = false;
      notifyListeners();
    }
  }

  void clearCurrentStudentFile() {
    _currentStudentFile = null;
    notifyListeners();
  }

  // =========================================================
  // CREAR GRUPO
  // =========================================================

  Future<bool> createGroup(
      String name,
      String accessCode,
      ) async {
    final String cleanName = name.trim();
    final String cleanCode = accessCode.trim();

    if (cleanName.isEmpty) {
      _errorMessage =
      'Ingresa el nombre del grupo.';
      notifyListeners();

      return false;
    }

    /*
     * El backend permite generar el código automáticamente.
     * Por eso se permite enviarlo vacío.
     */
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createGroupUseCase.call(
        cleanName,
        cleanCode.isEmpty
            ? null
            : cleanCode,
      );

      await loadDashboardData();

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR CREANDO GRUPO: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // DETALLE DE GRUPO
  // =========================================================

  Future<Map<String, dynamic>?> getGroupDetails(
      String groupId,
      ) async {
    final String cleanGroupId = groupId.trim();

    if (cleanGroupId.isEmpty) {
      _errorMessage =
      'El identificador del grupo está vacío.';
      notifyListeners();

      return null;
    }

    try {
      final Map<String, dynamic> details =
      await _getGroupDetailsUseCase.call(
        cleanGroupId,
      );

      return Map<String, dynamic>.from(
        details,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR OBTENIENDO DETALLE DEL GRUPO: '
            '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);
      notifyListeners();

      return null;
    }
  }

  // =========================================================
  // ACTUALIZAR GRUPO
  // =========================================================

  Future<bool> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    final String cleanGroupId = groupId.trim();
    final String cleanName = name?.trim() ?? '';
    final String cleanCode =
        accessCode?.trim() ?? '';

    if (cleanGroupId.isEmpty) {
      _errorMessage =
      'El identificador del grupo está vacío.';
      notifyListeners();

      return false;
    }

    if (cleanName.isEmpty &&
        cleanCode.isEmpty) {
      _errorMessage =
      'No hay cambios para actualizar.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateGroupUseCase.call(
        cleanGroupId,
        name: cleanName.isEmpty
            ? null
            : cleanName,
        accessCode: cleanCode.isEmpty
            ? null
            : cleanCode,
      );

      await loadDashboardData();

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR ACTUALIZANDO GRUPO: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // REGISTRAR SESIÓN
  // =========================================================

  Future<bool> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    final String cleanStudentId =
    studentId.trim();

    if (cleanStudentId.isEmpty) {
      _errorMessage =
      'No se encontró el alumno.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerSessionUseCase.call(
        cleanStudentId,
        sessionData,
      );

      await loadStudentFile(
        cleanStudentId,
      );

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR REGISTRANDO SESIÓN: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // ASIGNAR TAREA
  // =========================================================

  Future<bool> assignTask(
      Map<String, dynamic> taskData,
      ) async {
    if (taskData.isEmpty) {
      _errorMessage =
      'No hay información para asignar la tarea.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _assignTaskUseCase.call(
        taskData,
      );

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR ASIGNANDO TAREA: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // AGENDAR CITA
  // =========================================================

  Future<bool> scheduleAppointment(
      String studentId,
      DateTime date,
      String motive,
      ) async {
    final String cleanStudentId =
    studentId.trim();

    final String cleanMotive = motive.trim();

    if (cleanStudentId.isEmpty) {
      _errorMessage =
      'Selecciona un alumno.';
      notifyListeners();

      return false;
    }

    if (cleanMotive.isEmpty) {
      _errorMessage =
      'Ingresa el motivo de la cita.';
      notifyListeners();

      return false;
    }

    if (!date.isAfter(DateTime.now())) {
      _errorMessage =
      'La fecha de la cita debe ser futura.';
      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleAppointmentUseCase.call(
        cleanStudentId,
        date,
        cleanMotive,
      );

      _appointments =
      await _loadAppointmentsSafely();

      notifyListeners();

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'ERROR AGENDANDO CITA: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _errorMessage = _cleanError(error);

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // UTILIDADES
  // =========================================================

  List<StudentProfileEntity>
  _removeDuplicatedStudents(
      List<StudentProfileEntity> students,
      ) {
    final Map<String, StudentProfileEntity> unique =
    <String, StudentProfileEntity>{};

    for (final student in students) {
      final String id = student.id.trim();

      final String email = student.email
          .trim()
          .toLowerCase();

      final String key = id.isNotEmpty
          ? id
          : email;

      if (key.isNotEmpty) {
        unique[key] = student;
      }
    }

    return unique.values.toList();
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}