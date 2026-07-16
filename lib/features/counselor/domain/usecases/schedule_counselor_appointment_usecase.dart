import '../repositories/counselor_repository.dart';

class ScheduleCounselorAppointmentUseCase {
  final CounselorRepository repository;

  ScheduleCounselorAppointmentUseCase(this.repository);

  Future<void> call(String studentId, DateTime date, String motive) async {
    return await repository.scheduleAppointment(studentId, date, motive);
  }
}
