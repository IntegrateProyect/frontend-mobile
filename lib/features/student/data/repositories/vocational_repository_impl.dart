import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/repositories/vocational_repository.dart';
import '../datasources/models/vocational_result_model.dart';

class VocationalRepositoryImpl implements VocationalRepository {
  final IApi api;
  final UserService userService;

  VocationalRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<List<VocationalResultEntity>> getVocationalResults() async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      return [];
    }

    final response = await api.getGameResults(
      token.trim(),
    );

    return response
        .whereType<Map>()
        .map(
          (item) => VocationalResultModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
