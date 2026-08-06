import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/availability_slot_entity.dart';
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
import '../../domain/usecases/get_appointment_detail_usecase.dart';
import '../../domain/usecases/update_appointment_usecase.dart';
import '../../domain/usecases/delete_appointment_usecase.dart';
import '../../domain/repositories/counselor_repository.dart';

import 'counselor_error_helper.dart';
import 'counselor_dashboard_manager.dart';
import 'counselor_group_manager.dart';
import 'counselor_appointment_manager.dart';
import 'counselor_student_manager.dart';

enum CounselorState { initial, loading, loaded, error }

class CounselorProvider extends ChangeNotifier {
  final CounselorDashboardManager _dashboardManager;
  final CounselorGroupManager _groupManager;
  final CounselorAppointmentManager _appointmentManager;
  final CounselorStudentManager _studentManager;

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
    required ScheduleCounselorAppointmentUseCase scheduleAppointmentUseCase,
    required GetAppointmentDetailUseCase getAppointmentDetailUseCase,
    required UpdateAppointmentUseCase updateAppointmentUseCase,
    required DeleteAppointmentUseCase deleteAppointmentUseCase,
    required CounselorRepository repository,
  })  : _dashboardManager = CounselorDashboardManager(
          getGroupsUseCase: getGroupsUseCase,
          getConsultationsUseCase: getConsultationsUseCase,
          getCounselorProfileUseCase: getCounselorProfileUseCase,
          getCounselorStatsUseCase: getCounselorStatsUseCase,
          getStudentsUseCase: getStudentsUseCase,
          getAppointmentsUseCase: getAppointmentsUseCase,
          repository: repository,
        ),
        _groupManager = CounselorGroupManager(
          createGroupUseCase: createGroupUseCase,
          updateGroupUseCase: updateGroupUseCase,
          repository: repository,
        ),
        _appointmentManager = CounselorAppointmentManager(
          scheduleAppointmentUseCase: scheduleAppointmentUseCase,
          getAppointmentDetailUseCase: getAppointmentDetailUseCase,
          updateAppointmentUseCase: updateAppointmentUseCase,
          deleteAppointmentUseCase: deleteAppointmentUseCase,
          repository: repository,
        ),
        _studentManager = CounselorStudentManager(
          getGroupStudentsUseCase: getGroupStudentsUseCase,
          getStudentFileUseCase: getStudentFileUseCase,
          repository: repository,
        );

  CounselorProfileEntity? _profile;

  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  List<AppointmentEntity> _appointments = [];
  List<AvailabilitySlotEntity> _availability = [];

  Map<String, dynamic> _stats = {};

  StudentFileEntity? _currentStudentFile;

  CounselorState _state = CounselorState.initial;
  bool _isLoadingFile = false;
  bool _isLoadingGroupStudents = false;

  String? _errorMessage;

  // =========================================================
  // GETTERS
  // =========================================================

  CounselorProfileEntity? get profile => _profile;

  List<dynamic> get groups => List<dynamic>.unmodifiable(_groups);

  List<StudentProfileEntity> get students => List<StudentProfileEntity>.unmodifiable(_students);

  List<StudentConsultationEntity> get consultations => List<StudentConsultationEntity>.unmodifiable(_consultations);

  List<AppointmentEntity> get appointments => List<AppointmentEntity>.unmodifiable(_appointments);

  List<AvailabilitySlotEntity> get availability => List<AvailabilitySlotEntity>.unmodifiable(_availability);

  StudentFileEntity? get currentStudentFile => _currentStudentFile;

  Map<String, dynamic> get stats => Map<String, dynamic>.unmodifiable(_stats);

  CounselorState get state => _state;

  bool get isLoading => _state == CounselorState.loading;

  bool get isLoadingFile => _isLoadingFile;

  bool get isLoadingGroupStudents => _isLoadingGroupStudents;

  String? get errorMessage => _errorMessage;

  // =========================================================
  // CONTADORES
  // =========================================================

  int get totalStudentsCount {
    final int apiValue = CounselorErrorHelper.toInt(_stats['totalStudents'] ?? _stats['total_students']);
    return apiValue > 0 ? apiValue : _students.length;
  }

  int get activeStudentsCount => CounselorErrorHelper.toInt(_stats['activeStudents'] ?? _stats['active_students']);
  int get lowProgressCount => CounselorErrorHelper.toInt(_stats['lowProgress'] ?? _stats['low_progress']);
  int get highIndecisionCount => CounselorErrorHelper.toInt(_stats['highIndecision'] ?? _stats['high_indecision']);
  int get solicitudesCount => CounselorErrorHelper.toInt(_stats['requests'] ?? _stats['solicitudes']);
  int get groupsCount {
    final int apiValue = CounselorErrorHelper.toInt(_stats['groups'] ?? _stats['totalGroups'] ?? _stats['total_groups']);
    return apiValue > 0 ? apiValue : _groups.length;
  }
  int get reportesCount => CounselorErrorHelper.toInt(_stats['reports'] ?? _stats['reportes']);

  // =========================================================
  // DASHBOARD
  // =========================================================

  Future<void> loadDashboardData() async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dashboardManager.loadGroupsSafely(),
        _dashboardManager.loadConsultationsSafely(),
        _dashboardManager.loadProfileSafely(),
        _dashboardManager.loadStatsSafely(),
        _dashboardManager.loadStudentsSafely(),
        _dashboardManager.loadAppointmentsSafely(),
        _dashboardManager.loadAvailabilitySafely(),
      ]);

      _groups = results[0] as List<dynamic>;
      _consultations = results[1] as List<StudentConsultationEntity>;
      _profile = results[2] as CounselorProfileEntity?;
      _stats = results[3] as Map<String, dynamic>;
      _students = _removeDuplicatedStudents(results[4] as List<StudentProfileEntity>);
      _appointments = results[5] as List<AppointmentEntity>;
      _availability = results[6] as List<AvailabilitySlotEntity>;
      _state = CounselorState.loaded;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
    } finally {
      notifyListeners();
    }
  }

  // =========================================================
  // GRUPOS
  // =========================================================

  Future<bool> createGroup(String name, String accessCode) async {
    final String cleanName = name.trim();
    if (cleanName.isEmpty) {
      _errorMessage = 'Ingresa el nombre del grupo.';
      notifyListeners();
      return false;
    }

    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _groupManager.createGroup(cleanName, accessCode.trim().isEmpty ? null : accessCode.trim());
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateGroup(String groupId, {String? name, String? accessCode}) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _groupManager.updateGroup(groupId, name: name?.trim(), accessCode: accessCode?.trim());
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteGroup(String groupId) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _groupManager.deleteGroup(groupId);
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  // =========================================================
  // DISPONIBILIDAD (AGENDA)
  // =========================================================

  Future<bool> saveAvailability(List<AvailabilitySlotEntity> slots) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _appointmentManager.saveAvailability(slots);
      _availability = await _dashboardManager.loadAvailabilitySafely();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  List<AvailabilitySlotEntity> availabilityForDate(DateTime date) {
    final day = date.weekday % 7;
    return _availability.where((s) => s.dayOfWeek == day).toList();
  }

  bool isInsideAvailability(DateTime dateTime) {
    return _appointmentManager.isInsideAvailability(dateTime, _availability);
  }

  // =========================================================
  // AGENDAR CITA
  // =========================================================

  Future<bool> scheduleAppointment(
      String studentId,
      DateTime date,
      String motive,
      ) async {
    final String cleanStudentId = studentId.trim();
    final String cleanMotive = motive.trim();

    if (cleanStudentId.isEmpty) {
      _errorMessage = 'Selecciona un alumno.';
      notifyListeners();
      return false;
    }

    if (cleanMotive.isEmpty) {
      _errorMessage = 'Ingresa el motivo de la cita.';
      notifyListeners();
      return false;
    }

    if (!date.isAfter(DateTime.now())) {
      _errorMessage = 'La fecha de la cita debe ser futura.';
      notifyListeners();
      return false;
    }

    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _appointmentManager.scheduleAppointment(
        cleanStudentId,
        date,
        cleanMotive,
      );

      _appointments = await _dashboardManager.loadAppointmentsSafely();
      _state = CounselorState.loaded;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<AppointmentEntity?> getAppointmentDetail(String id) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final detail = await _appointmentManager.getAppointmentDetail(id);
      _state = CounselorState.loaded;
      return detail;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateAppointment(String id, Map<String, dynamic> data) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _appointmentManager.updateAppointment(id, data);
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteAppointment(String id) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _appointmentManager.deleteAppointment(id);
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  // =========================================================
  // OTROS MÉTODOS
  // =========================================================

  Future<List<StudentProfileEntity>> getGroupStudents(String groupId) async {
    _isLoadingGroupStudents = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await _studentManager.getGroupStudents(groupId);
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      rethrow;
    } finally {
      _isLoadingGroupStudents = false;
      notifyListeners();
    }
  }

  Future<void> loadStudentFile(String studentId) async {
    _isLoadingFile = true;
    _errorMessage = null;
    _currentStudentFile = null;
    notifyListeners();
    try {
      _currentStudentFile = await _studentManager.loadStudentFile(studentId);
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
    } finally {
      _isLoadingFile = false;
      notifyListeners();
    }
  }

  void clearCurrentStudentFile() {
    _currentStudentFile = null;
    notifyListeners();
  }

  List<StudentProfileEntity> _removeDuplicatedStudents(List<StudentProfileEntity> students) {
    final Map<String, StudentProfileEntity> unique = {};
    for (final s in students) {
      if (s.id.isNotEmpty) unique[s.id] = s;
    }
    return unique.values.toList();
  }

  Future<bool> updateStudentParents(String studentId, String? email1, String? email2) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentManager.updateStudentParents(studentId, email1, email2);
      await loadStudentFile(studentId);
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> sendStudentReport(String studentId, List<String> emails, String format) async {
    _state = CounselorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentManager.sendStudentReport(studentId, emails, format);
      return true;
    } catch (error) {
      _errorMessage = CounselorErrorHelper.cleanError(error);
      _state = CounselorState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }
}
