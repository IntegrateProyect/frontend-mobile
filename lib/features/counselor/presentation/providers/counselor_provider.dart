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
import '../../domain/repositories/counselor_repository.dart';

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
  final ScheduleCounselorAppointmentUseCase _scheduleAppointmentUseCase;
  final CounselorRepository _repository;

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
    required CounselorRepository repository,
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
        _scheduleAppointmentUseCase = scheduleAppointmentUseCase,
        _repository = repository;

  CounselorProfileEntity? _profile;

  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  List<AppointmentEntity> _appointments = [];
  List<AvailabilitySlotEntity> _availability = [];

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

  List<dynamic> get groups => List<dynamic>.unmodifiable(_groups);

  List<StudentProfileEntity> get students => List<StudentProfileEntity>.unmodifiable(_students);

  List<StudentConsultationEntity> get consultations => List<StudentConsultationEntity>.unmodifiable(_consultations);

  List<AppointmentEntity> get appointments => List<AppointmentEntity>.unmodifiable(_appointments);
  
  List<AvailabilitySlotEntity> get availability => List<AvailabilitySlotEntity>.unmodifiable(_availability);

  StudentFileEntity? get currentStudentFile => _currentStudentFile;

  Map<String, dynamic> get stats => Map<String, dynamic>.unmodifiable(_stats);

  bool get isLoading => _isLoading;

  bool get isLoadingFile => _isLoadingFile;

  bool get isLoadingGroupStudents => _isLoadingGroupStudents;

  String? get errorMessage => _errorMessage;

  // =========================================================
  // CONTADORES
  // =========================================================

  int get totalStudentsCount {
    final int apiValue = _toInt(_stats['totalStudents'] ?? _stats['total_students']);
    return apiValue > 0 ? apiValue : _students.length;
  }

  int get activeStudentsCount => _toInt(_stats['activeStudents'] ?? _stats['active_students']);
  int get lowProgressCount => _toInt(_stats['lowProgress'] ?? _stats['low_progress']);
  int get highIndecisionCount => _toInt(_stats['highIndecision'] ?? _stats['high_indecision']);
  int get solicitudesCount => _toInt(_stats['requests'] ?? _stats['solicitudes']);
  int get groupsCount {
    final int apiValue = _toInt(_stats['groups'] ?? _stats['totalGroups'] ?? _stats['total_groups']);
    return apiValue > 0 ? apiValue : _groups.length;
  }
  int get reportesCount => _toInt(_stats['reports'] ?? _stats['reportes']);

  // =========================================================
  // DASHBOARD
  // =========================================================

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final groupsResult = await _loadGroupsSafely();
      final consultationsResult = await _loadConsultationsSafely();
      final profileResult = await _loadProfileSafely();
      final statsResult = await _loadStatsSafely();
      final studentsResult = await _loadStudentsSafely();
      final appointmentsResult = await _loadAppointmentsSafely();
      final availabilityResult = await _loadAvailabilitySafely();

      _groups = groupsResult;
      _consultations = consultationsResult;
      _profile = profileResult;
      _stats = statsResult;
      _students = _removeDuplicatedStudents(studentsResult);
      _appointments = appointmentsResult;
      _availability = availabilityResult;

    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> _loadGroupsSafely() async {
    try {
      return await _getGroupsUseCase.call();
    } catch (_) {
      return <dynamic>[];
    }
  }

  Future<List<StudentConsultationEntity>> _loadConsultationsSafely() async {
    try {
      final result = await _getConsultationsUseCase.call();
      return List<StudentConsultationEntity>.from(result);
    } catch (_) {
      return <StudentConsultationEntity>[];
    }
  }

  Future<CounselorProfileEntity?> _loadProfileSafely() async {
    try {
      return await _getCounselorProfileUseCase.call();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _loadStatsSafely() async {
    try {
      final result = await _getCounselStatsUseCase.call();
      return Map<String, dynamic>.from(result);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<List<StudentProfileEntity>> _loadStudentsSafely() async {
    try {
      final dynamic result = await _getStudentsUseCase.call();
      if (result is! List) return <StudentProfileEntity>[];
      return result.whereType<StudentProfileEntity>().toList();
    } catch (_) {
      return <StudentProfileEntity>[];
    }
  }

  Future<List<AppointmentEntity>> _loadAppointmentsSafely() async {
    try {
      final result = await _getAppointmentsUseCase.call();
      return List<AppointmentEntity>.from(result);
    } catch (_) {
      return <AppointmentEntity>[];
    }
  }

  Future<List<AvailabilitySlotEntity>> _loadAvailabilitySafely() async {
    try {
      final result = await _repository.getAvailability();
      return result.map((json) => AvailabilitySlotEntity.fromJson(Map<String, dynamic>.from(json))).toList();
    } catch (_) {
      return <AvailabilitySlotEntity>[];
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

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createGroupUseCase.call(cleanName, accessCode.trim().isEmpty ? null : accessCode.trim());
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateGroup(String groupId, {String? name, String? accessCode}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateGroupUseCase.call(groupId, name: name?.trim(), accessCode: accessCode?.trim());
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteGroup(String groupId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteGroup(groupId);
      await loadDashboardData();
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // DISPONIBILIDAD (AGENDA)
  // =========================================================

  Future<bool> saveAvailability(List<AvailabilitySlotEntity> slots) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> rawSlots = slots.map((s) => s.toJson()).toList();
      await _repository.saveAvailability(rawSlots);
      _availability = await _loadAvailabilitySafely();
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<AvailabilitySlotEntity> availabilityForDate(DateTime date) {
    // dayOfWeek en DateTime: 1 (Lunes) a 7 (Domingo)
    // dayOfWeek en Entity: 0 (Domingo) a 6 (Sábado)
    final day = date.weekday % 7; 
    return _availability.where((s) => s.dayOfWeek == day).toList();
  }

  bool isInsideAvailability(DateTime dateTime) {
    final daySlots = availabilityForDate(dateTime);
    if (daySlots.isEmpty) return false;

    final time = TimeOfDay.fromDateTime(dateTime);
    final minutes = time.hour * 60 + time.minute;

    for (final slot in daySlots) {
      final startParts = slot.startTime.split(':');
      final endParts = slot.endTime.split(':');
      
      if (startParts.length < 2 || endParts.length < 2) continue;

      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (minutes >= startMinutes && minutes <= endMinutes) return true;
    }

    return false;
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

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleAppointmentUseCase.call(
        cleanStudentId,
        date,
        cleanMotive,
      );

      _appointments = await _loadAppointmentsSafely();
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // OTROS MÉTODOS (SIN CAMBIOS)
  // =========================================================

  Future<List<StudentProfileEntity>> getGroupStudents(String groupId) async {
    _isLoadingGroupStudents = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final List<StudentProfileEntity> result = await _getGroupStudentsUseCase.call(groupId.trim());
      return _removeDuplicatedStudents(result);
    } catch (error) {
      _errorMessage = _cleanError(error);
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
      _currentStudentFile = await _getStudentFileUseCase.call(studentId.trim());
    } catch (error) {
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

  List<StudentProfileEntity> _removeDuplicatedStudents(List<StudentProfileEntity> students) {
    final Map<String, StudentProfileEntity> unique = {};
    for (final s in students) {
      if (s.id.isNotEmpty) unique[s.id] = s;
    }
    return unique.values.toList();
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '').trim();
  }
}
