import 'student_alert_entity.dart';

class StudentFileEntity {
  final Map<String, dynamic> profile;
  final List<dynamic> tasks;
  final List<dynamic> sessions;
  final List<StudentAlertEntity> alerts;
  final Map<String, dynamic>? riasec;
  final List<dynamic>? recommendations;

  StudentFileEntity({
    required this.profile,
    required this.tasks,
    required this.sessions,
    required this.alerts,
    this.riasec,
    this.recommendations,
  });
}
