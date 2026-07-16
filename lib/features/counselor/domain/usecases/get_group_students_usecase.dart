import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import '../repositories/counselor_repository.dart';

class GetGroupStudentsUseCase {
  final CounselorRepository repository;

  GetGroupStudentsUseCase(this.repository);

  Future<List<StudentProfileEntity>> call(String groupId) async {
    return await repository.getGroupStudents(groupId);
  }
}
