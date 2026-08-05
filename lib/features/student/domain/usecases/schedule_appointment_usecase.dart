import '../repositories/student_appointments_repository.dart';

class ScheduleAppointmentUseCase {
  final StudentAppointmentsRepository repository;

  ScheduleAppointmentUseCase(this.repository);

  Future<void> call(DateTime date, String motive) async {
    return await repository.scheduleAppointment(date, motive);
  }
}
