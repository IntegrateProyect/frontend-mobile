
import '../../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.studentId,
    required super.counselorId,
    required super.sessionDate,
    required super.motive,
    super.observations,
    super.agreement,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      counselorId: json['counselorId'] ?? '',
      sessionDate: DateTime.parse(json['sessionDate'] ?? DateTime.now().toIso8601String()),
      motive: json['motive'] ?? '',
      observations: json['observations'],
      agreement: json['agreement'],
      status: json['status'] ?? 'SCHEDULED',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionDate': sessionDate.toIso8601String(),
      'motive': motive,
    };
  }
}
