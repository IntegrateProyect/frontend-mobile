import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../university/data/datasources/models/university_catalog_page_model.dart';
import '../../../university/domain/entities/university_catalog_page_entity.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/models/recommended_career_model.dart';
import '../datasources/remote/recommendation_remote_datasource.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final IApi api;
  final UserService userService;
  final RecommendationRemoteDataSource recommendationRemoteDataSource;

  RecommendationsRepositoryImpl({
    required this.api,
    required this.userService,
    required this.recommendationRemoteDataSource,
  });

  Future<String> _requireToken() async {
    final token = await userService.getToken();
    if (token == null || token.trim().isEmpty) {
      throw Exception('No hay una sesión activa');
    }
    return token.trim();
  }

  @override
  Future<List<CareerEntity>> getRecommendedCareers({
    int topN = 5,
  }) async {
    final String token = await _requireToken();

    final Map<String, dynamic> response =
        await recommendationRemoteDataSource.generateRecommendations(
      token,
      topN: topN,
    );

    final dynamic data = response['data'];
    final dynamic rawRecommendations = response['recommendations'] ??
        (data is Map ? data['recommendations'] : null);

    if (rawRecommendations is! List) {
      throw const FormatException(
        'El servicio no devolvió una lista de recomendaciones.',
      );
    }

    return rawRecommendations
        .whereType<Map>()
        .map<CareerEntity>(
          (item) => RecommendedCareerModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  @override
  Future<UniversityCatalogPageEntity> getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  }) async {
    final token = await _requireToken();
    final response = await api.getCatalogUniversities(
      token,
      page: page,
      limit: limit,
      search: search,
    );

    return UniversityCatalogPageModel.fromJson(response);
  }
}
