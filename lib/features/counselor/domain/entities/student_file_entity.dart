import 'student_alert_entity.dart';

class StudentFileEntity {
  final Map<String, dynamic> profile;
  final List<dynamic> tasks;
  final List<dynamic> sessions;
  final List<StudentAlertEntity> alerts;

  StudentFileEntity({
    required this.profile,
    required this.tasks,
    required this.sessions,
    required this.alerts,
  });
}
