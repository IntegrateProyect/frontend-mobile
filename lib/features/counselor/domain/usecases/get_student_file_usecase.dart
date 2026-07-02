import '../entities/student_file_entity.dart';
import '../entities/student_alert_entity.dart';
import '../repositories/counselor_repository.dart';

class GetStudentFileUseCase {
  final CounselorRepository repository;

  GetStudentFileUseCase(this.repository);

  Future<StudentFileEntity> call(String studentId) async {
    final data = await repository.getStudentFile(studentId);
    return _mapToEntity(data);
  }

  StudentFileEntity _mapToEntity(Map<String, dynamic> data) {
    final List<dynamic> alertsJson = data['alerts'] ?? [];
    
    return StudentFileEntity(
      profile: data['profile'] ?? {},
      tasks: data['tasks'] ?? [],
      sessions: data['sessions'] ?? [],
      alerts: alertsJson.map((json) {
        return StudentAlertEntity(
          id: json['id'] ?? '',
          studentId: json['studentId'] ?? '',
          alertType: _mapAlertType(json['alertType']),
          status: _mapAlertStatus(json['status']),
          details: json['details'] ?? '',
          createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
        );
      }).toList(),
    );
  }

  AlertType _mapAlertType(String? type) {
    switch (type) {
      case 'HIGH_INDECISION': return AlertType.highIndecision;
      case 'SCHOLARSHIP_NEED': return AlertType.scholarshipNeed;
      default: return AlertType.other;
    }
  }

  AlertStatus _mapAlertStatus(String? status) {
    switch (status) {
      case 'RESOLVED': return AlertStatus.resolved;
      default: return AlertStatus.pending;
    }
  }
}
