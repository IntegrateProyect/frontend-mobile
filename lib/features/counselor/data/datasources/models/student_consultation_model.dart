import '../../../domain/entities/student_consultation_entity.dart';

class StudentConsultationModel extends StudentConsultationEntity {
  StudentConsultationModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.message,
    required super.createdAt,
    required super.status,
  });

  factory StudentConsultationModel.fromJson(Map<String, dynamic> json) {
    return StudentConsultationModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
