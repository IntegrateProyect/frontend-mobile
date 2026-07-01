enum AlertType { highIndecision, scholarshipNeed, other }

enum AlertStatus { pending, resolved }

class StudentAlertEntity {
  final String id;
  final String studentId;
  final AlertType alertType;
  final AlertStatus status;
  final String details;
  final DateTime createdAt;

  StudentAlertEntity({
    required this.id,
    required this.studentId,
    required this.alertType,
    required this.status,
    required this.details,
    required this.createdAt,
  });
}
