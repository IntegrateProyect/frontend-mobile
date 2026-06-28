import '../repositories/counselor_repository.dart';

class GetCounselorStudentsUseCase {
  final CounselorRepository repository;

  GetCounselorStudentsUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getStudents();
  }
}
