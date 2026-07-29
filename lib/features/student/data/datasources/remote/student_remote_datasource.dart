import 'package:orientate/core/api/IApi.dart';

abstract class StudentRemoteDataSource {
  Future<Map<String, dynamic>> generateRecommendations(
      String token, {
        int topN = 5,
      });
}

class StudentRemoteDataSourceImpl
    implements StudentRemoteDataSource {
  final IApi api;

  StudentRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<Map<String, dynamic>> generateRecommendations(
      String token, {
        int topN = 5,
      }) async {
    if (token.trim().isEmpty) {
      throw Exception(
        'No hay una sesión activa para generar recomendaciones',
      );
    }

    try {
      return await api.generateRecommendations(
        token,
        topN: topN,
      );
    } catch (error) {
      throw Exception(
        'No fue posible generar las recomendaciones: $error',
      );
    }
  }
}