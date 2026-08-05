import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/availability_slot_entity.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/get_counselor_appointments_usecase.dart';
import '../../domain/usecases/get_counselor_profile_usecase.dart';
import '../../domain/usecases/get_counselor_stats_usecase.dart';
import '../../domain/usecases/get_counselor_students_usecase.dart';
import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/repositories/counselor_repository.dart';

class CounselorDashboardManager {
  final GetGroupsUseCase _getGroupsUseCase;
  final GetConsultationsUseCase _getConsultationsUseCase;
  final GetCounselorProfileUseCase _getCounselorProfileUseCase;
  final GetCounselorStatsUseCase _getCounselStatsUseCase;
  final GetCounselorStudentsUseCase _getStudentsUseCase;
  final GetCounselorAppointmentsUseCase _getAppointmentsUseCase;
  final CounselorRepository _repository;

  CounselorDashboardManager({
    required GetGroupsUseCase getGroupsUseCase,
    required GetConsultationsUseCase getConsultationsUseCase,
    required GetCounselorProfileUseCase getCounselorProfileUseCase,
    required GetCounselorStatsUseCase getCounselorStatsUseCase,
    required GetCounselorStudentsUseCase getStudentsUseCase,
    required GetCounselorAppointmentsUseCase getAppointmentsUseCase,
    required CounselorRepository repository,
  })  : _getGroupsUseCase = getGroupsUseCase,
        _getConsultationsUseCase = getConsultationsUseCase,
        _getCounselorProfileUseCase = getCounselorProfileUseCase,
        _getCounselStatsUseCase = getCounselorStatsUseCase,
        _getStudentsUseCase = getStudentsUseCase,
        _getAppointmentsUseCase = getAppointmentsUseCase,
        _repository = repository;

  Future<List<dynamic>> loadGroupsSafely() async {
    try {
      return await _getGroupsUseCase.call();
    } catch (_) {
      return <dynamic>[];
    }
  }

  Future<List<StudentConsultationEntity>> loadConsultationsSafely() async {
    try {
      final result = await _getConsultationsUseCase.call();
      return List<StudentConsultationEntity>.from(result);
    } catch (_) {
      return <StudentConsultationEntity>[];
    }
  }

  Future<CounselorProfileEntity?> loadProfileSafely() async {
    try {
      return await _getCounselorProfileUseCase.call();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> loadStatsSafely() async {
    try {
      final result = await _getCounselStatsUseCase.call();
      return Map<String, dynamic>.from(result);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<List<StudentProfileEntity>> loadStudentsSafely() async {
    try {
      final dynamic result = await _getStudentsUseCase.call();
      if (result is! List) return <StudentProfileEntity>[];
      return result.whereType<StudentProfileEntity>().toList();
    } catch (_) {
      return <StudentProfileEntity>[];
    }
  }

  Future<List<AppointmentEntity>> loadAppointmentsSafely() async {
    try {
      final result = await _getAppointmentsUseCase.call();
      return List<AppointmentEntity>.from(result);
    } catch (_) {
      return <AppointmentEntity>[];
    }
  }

  Future<List<AvailabilitySlotEntity>> loadAvailabilitySafely() async {
    try {
      final result = await _repository.getAvailability();
      return result.map((json) => AvailabilitySlotEntity.fromJson(Map<String, dynamic>.from(json))).toList();
    } catch (_) {
      return <AvailabilitySlotEntity>[];
    }
  }
}
