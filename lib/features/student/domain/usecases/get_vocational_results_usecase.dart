import '../entities/vocational_result_entity.dart';
import '../repositories/student_repository.dart';

class GetVocationalResultsUseCase {
  final StudentRepository repository;

  GetVocationalResultsUseCase(this.repository);

  Future<List<VocationalResultEntity>> call() {
    return repository.getVocationalResults();
  }
}
