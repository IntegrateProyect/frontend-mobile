import '../repositories/counselor_repository.dart';

class RegisterSessionUseCase {
  final CounselorRepository repository;

  RegisterSessionUseCase(this.repository);

  Future<void> call(String studentId, Map<String, dynamic> sessionData) {
    return repository.registerSession(studentId, sessionData);
  }
}
