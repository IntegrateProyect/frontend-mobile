import '../../../counselor/domain/entities/appointment_entity.dart';

abstract class StudentAppointmentsRepository {
  Future<void> scheduleAppointment(
    DateTime date,
    String motive,
  );

  Future<List<AppointmentEntity>> getAppointments();
}
