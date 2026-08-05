import '../../../counselor/domain/entities/appointment_entity.dart';
import '../repositories/student_appointments_repository.dart';

class GetStudentAppointmentsUseCase {
  final StudentAppointmentsRepository repository;

  GetStudentAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() async {
    return await repository.getAppointments();
  }
}
