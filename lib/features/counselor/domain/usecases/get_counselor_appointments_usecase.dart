import '../../../student/domain/entities/appointment_entity.dart';
import '../repositories/counselor_repository.dart';

class GetCounselorAppointmentsUseCase {
  final CounselorRepository repository;

  GetCounselorAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() async {
    return await repository.getAppointments();
  }
}
