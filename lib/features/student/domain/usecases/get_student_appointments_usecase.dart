import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../../counselor/domain/repositories/counselor_repository.dart';

class GetStudentAppointmentsUseCase {
  final CounselorRepository repository;

  GetStudentAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() async {
    return await repository.getAppointments();
  }
}
