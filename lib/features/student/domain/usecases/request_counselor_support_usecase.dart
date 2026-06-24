import '../repositories/student_repository.dart';

class RequestCounselorSupportUseCase {
  final StudentRepository repository;

  RequestCounselorSupportUseCase(this.repository);

  Future<void> call(String message) {
    return repository.requestCounselorSupport(message);
  }
}
