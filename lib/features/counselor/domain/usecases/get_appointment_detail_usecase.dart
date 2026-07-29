import '../entities/appointment_entity.dart';
import '../repositories/counselor_repository.dart';

class GetAppointmentDetailUseCase {
  final CounselorRepository repository;

  GetAppointmentDetailUseCase(this.repository);

  Future<AppointmentEntity> call(String appointmentId) async {
    return await repository.getAppointmentDetail(appointmentId);
  }
}
