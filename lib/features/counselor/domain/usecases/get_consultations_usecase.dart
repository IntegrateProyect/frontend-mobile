import '../entities/student_consultation_entity.dart';
import '../repositories/counselor_repository.dart';

class GetConsultationsUseCase {
  final CounselorRepository repository;

  GetConsultationsUseCase(this.repository);

  Future<List<StudentConsultationEntity>> call() {
    return repository.getConsultations();
  }
}
