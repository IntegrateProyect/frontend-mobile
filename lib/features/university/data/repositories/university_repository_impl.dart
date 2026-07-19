import 'dart:typed_data';
import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../auth/data/datasources/models/user_model.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/entities/university_catalog_page_entity.dart';
import '../../domain/entities/university_event_entity.dart';
import '../../domain/entities/university_announcement_entity.dart';
import '../../domain/repositories/university_repository.dart';
import '../datasources/models/university_catalog_page_model.dart';
import '../datasources/models/university_career_model.dart';
import '../datasources/models/university_profile_model.dart';
import '../datasources/models/university_event_model.dart';
import '../datasources/models/university_announcement_model.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final IApi api;
  final UserService userService;

  UniversityRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<UniversityProfileEntity> getProfile() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    final response = await api.getMe(token);
    final userModel = UserModel.fromJson(response);

    return UniversityProfileModel(
      id: userModel.id,
      name: userModel.universityName ?? userModel.name ?? 'Sin verificar',
      description: 'Estatus: ${userModel.verificationStatus ?? 'UNVERIFIED'}',
      location: userModel.universityName != null ? 'Verificado' : 'Pendiente de CCT',
      logoUrl: userModel.avatarUrl,
      website: userModel.email,
    );
  }

  @override
  Future<void> updateProfile(UniversityProfileEntity profile) async {
    // No-op en el backend ya que el nombre oficial proviene de SEP/SAT CCT
  }

  @override
  Future<List<UniversityCareerEntity>> getCareers() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    final list = await api.getUniversityCareers(token);
    return list.map((item) => UniversityCareerModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<void> addCareer(UniversityCareerEntity career) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    await api.addUniversityCareer(token, {
      'careerId': career.id,
      'location': career.location ?? 'Chiapas',
      'modality': career.modality ?? 'Presencial',
      'costApprox': career.cost,
      'scholarshipAvailable': career.scholarshipAvailable ?? true,
      'admissionDates': career.admissionDates ?? 'Anual',
    });
  }

  @override
  Future<Map<String, dynamic>> claimUniversity(String cct, String rfc) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    return api.claimUniversity(token, cct: cct, rfc: rfc);
  }

  @override
  Future<List<UniversityCareerEntity>> getCatalogCareers() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    final list = await api.getCatalogCareers(token);
    return list.map((item) => UniversityCareerModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<void> deleteCareer(String careerId) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    await api.deleteUniversityCareer(token, careerId);
  }

  @override
  Future<UniversityCatalogPageEntity> getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  }) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');

    final response = await api.getCatalogUniversities(
      token,
      page: page,
      limit: limit,
      search: search,
    );

    return UniversityCatalogPageModel.fromJson(response);
  }

  // --- EVENTOS ---
  @override
  Future<List<UniversityEventEntity>> getEvents() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final list = await api.getUniversityEvents(token);
    return list.map((item) => UniversityEventModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<void> createEvent(UniversityEventEntity event) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final model = UniversityEventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      careerId: event.careerId,
      imageUrl: event.imageUrl,
    );
    await api.createUniversityEvent(token, model.toJson());
  }

  @override
  Future<void> updateEvent(UniversityEventEntity event) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final model = UniversityEventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      careerId: event.careerId,
      imageUrl: event.imageUrl,
    );
    await api.updateUniversityEvent(token, event.id, model.toJson());
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    await api.deleteUniversityEvent(token, eventId);
  }

  @override
  Future<String> uploadEventImage(Uint8List bytes, String contentType) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    
    final presignedData = await api.getEventPresignedUrl(token, contentType: contentType);
    final uploadUrl = presignedData['uploadUrl']?.toString();
    final fileUrl = presignedData['imageUrl']?.toString();
    if (uploadUrl == null || fileUrl == null) {
      throw Exception('No se pudo generar la URL de carga para la imagen.');
    }
    
    await api.uploadImageToS3(uploadUrl, bytes);
    return fileUrl;
  }

  // --- ANUNCIOS / CONVOCATORIAS ---
  @override
  Future<List<UniversityAnnouncementEntity>> getAnnouncements() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final list = await api.getUniversityAnnouncements(token);
    return list.map((item) => UniversityAnnouncementModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<void> createAnnouncement(UniversityAnnouncementEntity announcement) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final model = UniversityAnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      description: announcement.description,
      category: announcement.category,
    );
    await api.createUniversityAnnouncement(token, model.toJson());
  }

  @override
  Future<void> updateAnnouncement(UniversityAnnouncementEntity announcement) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    final model = UniversityAnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      description: announcement.description,
      category: announcement.category,
    );
    await api.updateUniversityAnnouncement(token, announcement.id, model.toJson());
  }

  @override
  Future<void> deleteAnnouncement(String announcementId) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no válida');
    await api.deleteUniversityAnnouncement(token, announcementId);
  }
}
