import '../entities/alumni_entity.dart';

abstract class AlumniRepository {
  Future<List<AlumniEntity>> getAlumni();
}
