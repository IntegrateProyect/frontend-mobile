import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/repositories/alumni_repository.dart';
import '../datasources/mappers/alumni_mapper.dart';
import '../datasources/models/alumni_profile_model.dart';
import '../datasources/models/success_story_model.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  final IApi api;
  final UserService userService;

  AlumniRepositoryImpl({required this.api, required this.userService});

  @override
  Future<AlumniProfileEntity> getProfile() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('No session found');

    final result = await api.getAlumniProfile(token);
    final profileData = result['profile'] ?? result['data'] ?? result;

    return AlumniMapper.toProfileEntity(AlumniProfileModel.fromJson(profileData));
  }

  @override
  Future<void> updateProfile(AlumniProfileEntity profile) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('No session found');

    final model = AlumniProfileModel(
      name: profile.name,
      email: profile.email,
      graduationYear: profile.graduationYear,
      degree: profile.degree,
      company: profile.company,
    );

    await api.updateAlumniProfile(token, model.toJson());
  }

  @override
  Future<List<SuccessStoryEntity>> getSuccessStories() async {
    final token = await userService.getToken();
    if (token == null) throw Exception('No session found');

    final List<dynamic> result = await api.getSuccessStories(token);

    return result.map((json) {
      return AlumniMapper.toStoryEntity(SuccessStoryModel.fromJson(json));
    }).toList();
  }

  @override
  Future<void> shareStory(String storyContent) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('No session found');

    await api.shareSuccessStory(token, {'story': storyContent});
  }
}
