import '../entities/vocational_result_entity.dart';
import '../repositories/vocational_repository.dart';

class GetVocationalResultsUseCase {
  final VocationalRepository repository;

  GetVocationalResultsUseCase(this.repository);

  Future<List<VocationalResultEntity>> call() {
    return repository.getVocationalResults();
  }
}
