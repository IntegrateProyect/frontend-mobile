import '../repositories/student_repository.dart';

class ScheduleAppointmentUseCase {
  final StudentRepository repository;

  ScheduleAppointmentUseCase(this.repository);

  Future<void> call(DateTime date, String motive) async {
    return await repository.scheduleAppointment(date, motive);
  }
}
