class StudentConsultationEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String message;
  final DateTime createdAt;
  final String status; // 'pending', 'responded'

  StudentConsultationEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.message,
    required this.createdAt,
    required this.status,
  });
}
