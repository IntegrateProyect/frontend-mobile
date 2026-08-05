import '../../../university/domain/entities/scholarship_entity.dart';
import '../../domain/repositories/scholarships_repository.dart';

class ScholarshipsRepositoryImpl implements ScholarshipsRepository {
  @override
  Future<List<ScholarshipEntity>> getScholarships() async {
    return [];
  }
}
