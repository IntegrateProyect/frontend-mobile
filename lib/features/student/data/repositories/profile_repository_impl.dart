import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/models/student_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final IApi api;
  final UserService userService;

  ProfileRepositoryImpl({
    required this.api,
    required this.userService,
  });

  Future<String> _requireToken() async {
    final token = await userService.getToken();
    if (token == null || token.trim().isEmpty) {
      throw Exception('No hay una sesión activa');
    }
    return token.trim();
  }

  @override
  Future<StudentProfileEntity> getProfile() async {
    final token = await _requireToken();
    final response = await api.getStudentProfile(token);
    final dynamic data = response['data'] ?? response;

    if (data is Map) {
      return StudentProfileModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }

    throw Exception('Formato inválido del perfil del estudiante');
  }

  @override
  Future<void> updateProfile(StudentProfileEntity profile) async {
    final token = await _requireToken();

    await api.updateStudentProfile(
      token,
      {
        'name': profile.name,
        'subjectsLiked': profile.subjectsLiked,
        'subjectsDisliked': profile.subjectsDisliked,
        'interests': profile.interests,
        'skills': profile.skills,
        'needsScholarship': profile.needsScholarship,
        'studyAbroad': profile.studyAbroad,
        'vocationalClarity': profile.vocationalClarity,
      },
    );
  }
}
