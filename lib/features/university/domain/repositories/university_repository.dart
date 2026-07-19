import 'dart:typed_data';
import '../entities/university_profile_entity.dart';
import '../entities/university_career_entity.dart';
import '../entities/university_catalog_page_entity.dart';
import '../entities/university_event_entity.dart';
import '../entities/university_announcement_entity.dart';

abstract class UniversityRepository {
  Future<UniversityProfileEntity> getProfile();
  Future<void> updateProfile(UniversityProfileEntity profile);
  Future<List<UniversityCareerEntity>> getCareers();
  Future<void> addCareer(UniversityCareerEntity career);
  Future<void> deleteCareer(String careerId);
  Future<Map<String, dynamic>> claimUniversity(String cct, String rfc);
  Future<List<UniversityCareerEntity>> getCatalogCareers();

  // Métodos movidos de StudentRepository
  Future<UniversityCatalogPageEntity> getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  });

  // Eventos
  Future<List<UniversityEventEntity>> getEvents();
  Future<void> createEvent(UniversityEventEntity event);
  Future<void> updateEvent(UniversityEventEntity event);
  Future<void> deleteEvent(String eventId);
  Future<String> uploadEventImage(Uint8List bytes, String contentType);

  // Anuncios / Convocatorias
  Future<List<UniversityAnnouncementEntity>> getAnnouncements();
  Future<void> createAnnouncement(UniversityAnnouncementEntity announcement);
  Future<void> updateAnnouncement(UniversityAnnouncementEntity announcement);
  Future<void> deleteAnnouncement(String announcementId);
}
