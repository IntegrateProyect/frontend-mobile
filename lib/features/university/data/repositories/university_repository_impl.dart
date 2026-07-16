import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/entities/university_catalog_page_entity.dart';
import '../../domain/repositories/university_repository.dart';
import '../datasources/models/university_catalog_page_model.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final IApi api;
  final UserService userService;

  UniversityRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<UniversityProfileEntity> getProfile() async {
    // Implementación pendiente según necesidad del perfil de universidad
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(UniversityProfileEntity profile) async {
    // Implementación pendiente
  }

  @override
  Future<List<UniversityCareerEntity>> getCareers() async {
    return [];
  }

  @override
  Future<void> addCareer(UniversityCareerEntity career) async {
  }

  @override
  Future<void> deleteCareer(String careerId) async {
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
}
