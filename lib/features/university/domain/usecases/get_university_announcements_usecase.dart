import '../entities/university_announcement_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityAnnouncementsUseCase {
  final UniversityRepository repository;

  GetUniversityAnnouncementsUseCase(this.repository);

  Future<List<UniversityAnnouncementEntity>> call() => repository.getAnnouncements();
}
