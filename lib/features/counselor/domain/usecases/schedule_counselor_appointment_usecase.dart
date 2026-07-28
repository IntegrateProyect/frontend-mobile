import '../repositories/counselor_repository.dart';

class ScheduleCounselorAppointmentUseCase {
  final CounselorRepository repository;

  const ScheduleCounselorAppointmentUseCase({
    required this.repository,
  });

  Future<void> call(
      String studentId,
      DateTime date,
      String motive,
      ) {
    return repository.scheduleAppointment(
      studentId,
      date,
      motive,
    );
  }
}