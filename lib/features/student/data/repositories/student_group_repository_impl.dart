import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/student_counselor_entity.dart';
import '../../domain/repositories/student_group_repository.dart';

class StudentGroupRepositoryImpl implements StudentGroupRepository {
  final IApi api;
  final UserService userService;

  StudentGroupRepositoryImpl({
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
  Future<List<dynamic>> getGroups() async {
    final token = await _requireToken();
    final response = await api.getStudentGroups(token);
    return response.where((item) {
      if (item is Map) return item.isNotEmpty;
      return item != null;
    }).toList();
  }

  @override
  Future<StudentCounselorEntity?> getCounselor() async {
    final token = await _requireToken();
    final response = await api.getStudentCounselor(token);
    if (response.isEmpty) return null;

    final counselor = StudentCounselorEntity.fromJson(response);

    if (counselor.id.isEmpty &&
        counselor.name == 'Por asignar' &&
        counselor.email.isEmpty) {
      return null;
    }

    return counselor;
  }

  @override
  Future<void> joinGroup(String accessCode) async {
    final token = await _requireToken();
    await api.joinGroup(token, accessCode);
  }
}
