class AppointmentEntity {
  final String id;
  final String studentId;
  final String counselorId;
  final DateTime sessionDate;
  final String motive;
  final String? observations;
  final String? agreement;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentEntity({
    required this.id,
    required this.studentId,
    required this.counselorId,
    required this.sessionDate,
    required this.motive,
    this.observations,
    this.agreement,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
