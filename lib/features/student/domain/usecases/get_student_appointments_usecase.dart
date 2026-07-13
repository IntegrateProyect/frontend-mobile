import '../entities/appointment_entity.dart';
import '../repositories/student_repository.dart';

class GetStudentAppointmentsUseCase {
  final StudentRepository repository;

  GetStudentAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() async {
    return await repository.getAppointments();
  }
}
