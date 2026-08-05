import '../../../university/domain/entities/scholarship_entity.dart';

abstract class ScholarshipsRepository {
  Future<List<ScholarshipEntity>> getScholarships();
}
