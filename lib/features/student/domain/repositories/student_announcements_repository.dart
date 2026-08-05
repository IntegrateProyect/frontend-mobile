import '../../../university/domain/entities/university_announcement_entity.dart';

abstract class StudentAnnouncementsRepository {
  Future<List<UniversityAnnouncementEntity>> getAnnouncements();
}
