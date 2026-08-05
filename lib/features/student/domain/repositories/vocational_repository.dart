import '../entities/vocational_result_entity.dart';

abstract class VocationalRepository {
  Future<List<VocationalResultEntity>> getVocationalResults();
}
