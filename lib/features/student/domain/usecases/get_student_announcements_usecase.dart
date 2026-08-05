import '../../../university/domain/entities/university_announcement_entity.dart';
import '../repositories/student_announcements_repository.dart';

class GetStudentAnnouncementsUseCase {
  final StudentAnnouncementsRepository repository;

  GetStudentAnnouncementsUseCase(this.repository);

  Future<List<UniversityAnnouncementEntity>> call() {
    return repository.getAnnouncements();
  }
}
