import '../repositories/counselor_repository.dart';

class RespondConsultationUseCase {
  final CounselorRepository repository;

  RespondConsultationUseCase(this.repository);

  Future<void> call(String consultationId, String response) {
    return repository.respondToConsultation(consultationId, response);
  }
}
