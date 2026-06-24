import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/repositories/university_repository.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  @override
  Future<UniversityProfileEntity> getProfile() async {
    // TODO: Implement actual data fetch
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(UniversityProfileEntity profile) async {
    // TODO: Implement update
  }

  @override
  Future<List<UniversityCareerEntity>> getCareers() async {
    return [];
  }

  @override
  Future<void> addCareer(UniversityCareerEntity career) async {
    // TODO: Implement add
  }

  @override
  Future<void> deleteCareer(String careerId) async {
    // TODO: Implement delete
  }
}
