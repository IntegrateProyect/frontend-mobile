import 'package:flutter/material.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/availability_slot_entity.dart';
import '../../domain/usecases/schedule_counselor_appointment_usecase.dart';
import '../../domain/usecases/get_appointment_detail_usecase.dart';
import '../../domain/usecases/update_appointment_usecase.dart';
import '../../domain/usecases/delete_appointment_usecase.dart';
import '../../domain/repositories/counselor_repository.dart';

class CounselorAppointmentManager {
  final ScheduleCounselorAppointmentUseCase _scheduleAppointmentUseCase;
  final GetAppointmentDetailUseCase _getAppointmentDetailUseCase;
  final UpdateAppointmentUseCase _updateAppointmentUseCase;
  final DeleteAppointmentUseCase _deleteAppointmentUseCase;
  final CounselorRepository _repository;

  CounselorAppointmentManager({
    required ScheduleCounselorAppointmentUseCase scheduleAppointmentUseCase,
    required GetAppointmentDetailUseCase getAppointmentDetailUseCase,
    required UpdateAppointmentUseCase updateAppointmentUseCase,
    required DeleteAppointmentUseCase deleteAppointmentUseCase,
    required CounselorRepository repository,
  })  : _scheduleAppointmentUseCase = scheduleAppointmentUseCase,
        _getAppointmentDetailUseCase = getAppointmentDetailUseCase,
        _updateAppointmentUseCase = updateAppointmentUseCase,
        _deleteAppointmentUseCase = deleteAppointmentUseCase,
        _repository = repository;

  Future<void> saveAvailability(List<AvailabilitySlotEntity> slots) async {
    final List<Map<String, dynamic>> rawSlots = slots.map((s) => s.toJson()).toList();
    await _repository.saveAvailability(rawSlots);
  }

  bool isInsideAvailability(DateTime dateTime, List<AvailabilitySlotEntity> currentAvailability) {
    final day = dateTime.weekday % 7;
    final daySlots = currentAvailability.where((s) => s.dayOfWeek == day).toList();
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

  Future<void> scheduleAppointment(String studentId, DateTime date, String motive) async {
    await _scheduleAppointmentUseCase.call(studentId, date, motive);
  }

  Future<AppointmentEntity?> getAppointmentDetail(String id) async {
    return await _getAppointmentDetailUseCase.call(id);
  }

  Future<void> updateAppointment(String id, Map<String, dynamic> data) async {
    await _updateAppointmentUseCase.call(id, data);
  }

  Future<void> deleteAppointment(String id) async {
    await _deleteAppointmentUseCase.call(id);
  }
}
