import '../repositories/counselor_repository.dart';

class DeleteAppointmentUseCase {
  final CounselorRepository repository;

  DeleteAppointmentUseCase(this.repository);

  Future<void> call(String appointmentId) async {
    return await repository.deleteAppointment(appointmentId);
  }
}
