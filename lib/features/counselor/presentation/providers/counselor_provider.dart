import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import 'package:orientate/features/student/domain/entities/appointment_entity.dart';

import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/entities/student_file_entity.dart';

import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/create_group_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/usecases/get_group_details_usecase.dart';
import '../../domain/usecases/register_session_usecase.dart';
import '../../domain/usecases/assign_task_usecase.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/get_counselor_profile_usecase.dart';
import '../../domain/usecases/get_counselor_stats_usecase.dart';
import '../../domain/usecases/get_counselor_students_usecase.dart';
import '../../domain/usecases/get_student_file_usecase.dart';
import '../../domain/usecases/get_counselor_appointments_usecase.dart';

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

  CounselorProfileEntity? _profile;
  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  Map<String, dynamic> _stats = {};
  List<AppointmentEntity> _appointments = [];

  StudentFileEntity? _currentStudentFile;

  bool _isLoading = false;
  bool _isLoadingFile = false;
  String? _errorMessage;

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
        _getAppointmentsUseCase = getAppointmentsUseCase;

  CounselorProfileEntity? get profile => _profile;
  List<dynamic> get groups => _groups;
  List<StudentProfileEntity> get students => _students;
  List<StudentConsultationEntity> get consultations => _consultations;
  StudentFileEntity? get currentStudentFile => _currentStudentFile;
  List<AppointmentEntity> get appointments => _appointments;

  bool get isLoading => _isLoading;
  bool get isLoadingFile => _isLoadingFile;
  String? get errorMessage => _errorMessage;

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  int get totalStudentsCount {
    final apiValue = _toInt(_stats['totalStudents']);
    return apiValue > 0 ? apiValue : _students.length;
  }

  int get activeStudentsCount {
    return _toInt(_stats['activeStudents']);
  }

  int get lowProgressCount {
    return _toInt(_stats['lowProgress']);
  }

  int get highIndecisionCount {
    return _toInt(_stats['highIndecision']);
  }

  int get solicitudesCount {
    return _toInt(_stats['requests']);
  }

  int get groupsCount {
    final apiValue = _toInt(_stats['groups']);
    return apiValue > 0 ? apiValue : _groups.length;
  }

  int get reportesCount {
    return _toInt(_stats['reports']);
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        _getGroupsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando grupos: $e');
          return <dynamic>[];
        }),
        _getConsultationsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando consultas: $e');
          return <StudentConsultationEntity>[];
        }),
        _getCounselorProfileUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando perfil orientador: $e');
          return null;
        }),
        _getCounselStatsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando estadísticas: $e');
          return <String, dynamic>{};
        }),
        _getStudentsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando alumnos: $e');
          return <StudentProfileEntity>[];
        }),
        _getAppointmentsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando citas: $e');
          return <AppointmentEntity>[];
        }),
      ]);

      _groups = List<dynamic>.from(results[0] as List);
      _consultations =
      List<StudentConsultationEntity>.from(results[1] as List);
      _profile = results[2] as CounselorProfileEntity?;
      _stats = Map<String, dynamic>.from(results[3] as Map);
      _students = List<StudentProfileEntity>.from(results[4] as List);
      _appointments = List<AppointmentEntity>.from(results[5] as List);

      debugPrint('XXX GRUPOS CARGADOS: ${_groups.length}');
      debugPrint('XXX ALUMNOS CARGADOS: ${_students.length}');
      debugPrint('XXX CITAS CARGADAS: ${_appointments.length}');
      debugPrint('XXX STATS: $_stats');
    } catch (e) {
      debugPrint('XXX Error general CounselorProvider: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStudentFile(String studentId) async {
    _isLoadingFile = true;
    _errorMessage = null;
    _currentStudentFile = null;
    notifyListeners();

    try {
      _currentStudentFile = await _getStudentFileUseCase.call(studentId);
    } catch (e) {
      debugPrint('XXX Error cargando expediente alumno: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingFile = false;
      notifyListeners();
    }
  }

  Future<bool> createGroup(String name, String accessCode) async {
    final cleanName = name.trim();
    final cleanCode = accessCode.trim();

    if (cleanName.isEmpty) {
      _errorMessage = 'Ingresa el nombre del grupo';
      notifyListeners();
      return false;
    }

    if (cleanCode.isEmpty) {
      _errorMessage = 'Ingresa el código de acceso';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createGroupUseCase.call(cleanName, cleanCode);
      await loadDashboardData();
      return true;
    } catch (e) {
      debugPrint('XXX Error creando grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getGroupDetails(String groupId) async {
    try {
      final details = await _getGroupDetailsUseCase.call(groupId);
      return Map<String, dynamic>.from(details);
    } catch (e) {
      debugPrint('XXX Error obteniendo detalle grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateGroupUseCase.call(
        groupId,
        name: name?.trim(),
        accessCode: accessCode?.trim(),
      );

      await loadDashboardData();
      return true;
    } catch (e) {
      debugPrint('XXX Error actualizando grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerSessionUseCase.call(studentId, sessionData);
      await loadStudentFile(studentId);
    } catch (e) {
      debugPrint('XXX Error registrando sesión: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignTask(Map<String, dynamic> taskData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _assignTaskUseCase.call(taskData);
    } catch (e) {
      debugPrint('XXX Error asignando tarea: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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
