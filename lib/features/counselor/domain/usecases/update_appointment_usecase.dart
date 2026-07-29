import '../repositories/counselor_repository.dart';

class UpdateAppointmentUseCase {
  final CounselorRepository repository;

  UpdateAppointmentUseCase(this.repository);

  Future<void> call(String appointmentId, Map<String, dynamic> data) async {
    return await repository.updateAppointment(appointmentId, data);
  }
}
