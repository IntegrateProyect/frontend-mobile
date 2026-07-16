import '../entities/university_profile_entity.dart';
import '../entities/university_career_entity.dart';
import '../entities/university_catalog_page_entity.dart';

abstract class UniversityRepository {
  Future<UniversityProfileEntity> getProfile();
  Future<void> updateProfile(UniversityProfileEntity profile);
  Future<List<UniversityCareerEntity>> getCareers();
  Future<void> addCareer(UniversityCareerEntity career);
  Future<void> deleteCareer(String careerId);

  // Métodos movidos de StudentRepository
  Future<UniversityCatalogPageEntity> getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  });
}
