import '../../../../../core/api/IApi.dart';

abstract class RecommendationRemoteDataSource {
  Future<Map<String, dynamic>> generateRecommendations(
      String token, {
        int topN = 5,
      });
}

class RecommendationRemoteDataSourceImpl
    implements RecommendationRemoteDataSource {
  final IApi api;

  RecommendationRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<Map<String, dynamic>> generateRecommendations(
      String token, {
        int topN = 5,
      }) {
    return api.generateRecommendations(
      token,
      topN: topN,
    );
  }
}