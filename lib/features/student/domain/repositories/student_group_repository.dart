import '../entities/student_counselor_entity.dart';

abstract class StudentGroupRepository {
  Future<List<dynamic>> getGroups();
  Future<StudentCounselorEntity?> getCounselor();
  Future<void> joinGroup(String accessCode);
}
