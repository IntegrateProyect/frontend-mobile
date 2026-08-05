import 'package:flutter/material.dart';
import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../domain/usecases/get_student_appointments_usecase.dart';
import '../../domain/usecases/schedule_appointment_usecase.dart';

class StudentAppointmentsProvider extends ChangeNotifier {
  final GetStudentAppointmentsUseCase _getAppointmentsUseCase;
  final ScheduleAppointmentUseCase _scheduleAppointmentUseCase;

  StudentAppointmentsProvider({
    required GetStudentAppointmentsUseCase getAppointmentsUseCase,
    required ScheduleAppointmentUseCase scheduleAppointmentUseCase,
  })  : _getAppointmentsUseCase = getAppointmentsUseCase,
        _scheduleAppointmentUseCase = scheduleAppointmentUseCase;

  List<AppointmentEntity> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<AppointmentEntity> get appointments => List.unmodifiable(_appointments);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> loadAppointments() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      _appointments = await _getAppointmentsUseCase();
    } catch (e) {
      _errorMessage = 'Error al cargar las citas';
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> scheduleAppointment(DateTime date, String motive) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      await _scheduleAppointmentUseCase(date, motive);
      await loadAppointments();
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '').trim();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }
}
