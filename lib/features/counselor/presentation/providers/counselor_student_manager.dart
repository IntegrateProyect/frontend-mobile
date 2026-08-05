import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import '../../domain/entities/student_file_entity.dart';
import '../../domain/usecases/get_group_students_usecase.dart';
import '../../domain/usecases/get_student_file_usecase.dart';
import '../../domain/repositories/counselor_repository.dart';

class CounselorStudentManager {
  final GetGroupStudentsUseCase _getGroupStudentsUseCase;
  final GetStudentFileUseCase _getStudentFileUseCase;
  final CounselorRepository _repository;

  CounselorStudentManager({
    required GetGroupStudentsUseCase getGroupStudentsUseCase,
    required GetStudentFileUseCase getStudentFileUseCase,
    required CounselorRepository repository,
  })  : _getGroupStudentsUseCase = getGroupStudentsUseCase,
        _getStudentFileUseCase = getStudentFileUseCase,
        _repository = repository;

  Future<List<StudentProfileEntity>> getGroupStudents(String groupId) async {
    final List<StudentProfileEntity> result =
        await _getGroupStudentsUseCase.call(groupId.trim());
    return _removeDuplicatedStudents(result);
  }

  Future<StudentFileEntity?> loadStudentFile(String studentId) async {
    return await _getStudentFileUseCase.call(studentId.trim());
  }

  List<StudentProfileEntity> _removeDuplicatedStudents(
      List<StudentProfileEntity> students) {
    final Map<String, StudentProfileEntity> unique = {};
    for (final s in students) {
      if (s.id.isNotEmpty) unique[s.id] = s;
    }
    return unique.values.toList();
  }

  Future<void> updateStudentParents(
      String studentId, String? email1, String? email2) async {
    await _repository.updateStudentParents(studentId, email1, email2);
  }

  Future<void> sendStudentReport(
      String studentId, List<String> emails, String format) async {
    await _repository.sendStudentReport(studentId, emails, format);
  }
}
