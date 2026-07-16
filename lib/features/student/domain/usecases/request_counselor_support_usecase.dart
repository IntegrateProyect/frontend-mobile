import '../../../counselor/domain/repositories/counselor_repository.dart';

class RequestCounselorSupportUseCase {
  final CounselorRepository repository;

  RequestCounselorSupportUseCase(this.repository);

  Future<void> call(String message) {
    return repository.requestSupport(message);
  }
}
