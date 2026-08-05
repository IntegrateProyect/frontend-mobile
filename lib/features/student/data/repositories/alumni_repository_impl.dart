import '../../domain/entities/alumni_entity.dart';
import '../../domain/repositories/alumni_repository.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  @override
  Future<List<AlumniEntity>> getAlumni() async {
    return [];
  }
}
