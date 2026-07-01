import 'package:orientate/features/student/data/datasources/models/student_profile_model.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../auth/data/datasources/mappers/auth_mapper.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/repositories/counselor_repository.dart';
import '../datasources/models/student_consultation_model.dart';

class CounselorRepositoryImpl implements CounselorRepository {
  final IApi api;
  final UserService userService;

  CounselorRepositoryImpl({required this.api, required this.userService});

  @override
  Future<CounselorProfileEntity> getProfile() async {
    final userModel = await userService.getUser();
    if (userModel == null) throw Exception("No se encontró sesión de usuario");
    final userEntity = AuthMapper.toEntity(userModel);

    return CounselorProfileEntity(
      id: userEntity.id,
      name: userEntity.name ?? 'Sin nombre',
      email: userEntity.email,
      institution: 'Institución no especificada',
      profileImageUrl: userEntity.photoUrl,
    );
  }

  @override
  Future<List<dynamic>> getGroups() async {
    final token = await userService.getToken();
    return await api.getGroups(token ?? '');
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(String groupId) async {
    final token = await userService.getToken();
    return await api.getGroupDetail(token ?? '', groupId);
  }

  @override
  Future<Map<String, dynamic>> createGroup(String name, String? accessCode) async {
    final token = await userService.getToken();
    return await api.createGroup(token ?? '', {
      'name': name,
      'accessCode': accessCode ?? '',
    });
  }

  @override
  Future<Map<String, dynamic>> updateGroup(String groupId, {String? name, String? accessCode}) async {
    final token = await userService.getToken();
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (accessCode != null) data['accessCode'] = accessCode;

    return await api.updateGroup(token ?? '', groupId, data);
  }

  @override
  Future<List<dynamic>> getGroupStudents(String groupId) async {
    final token = await userService.getToken();
    return await api.getGroupStudents(token ?? '', groupId);
  }

  @override
  Future<List<StudentProfileEntity>> getStudents() async {
    final token = await userService.getToken();
    final List<dynamic> data = await api.getCounselorStudents(token ?? '');
    return data.map((json) => StudentProfileModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getStudentFile(String studentId) async {
    final token = await userService.getToken();
    return await api.getStudentFile(token ?? '', studentId);
  }

  @override
  Future<void> registerSession(String studentId, Map<String, dynamic> sessionData) async {
    final token = await userService.getToken();
    await api.registerSession(token ?? '', studentId, sessionData);
  }

  @override
  Future<void> assignTask(Map<String, dynamic> taskData) async {
    final token = await userService.getToken();
    await api.createTask(token ?? '', taskData);
  }

  @override
  Future<List<StudentConsultationEntity>> getConsultations() async {
    final token = await userService.getToken();
    final list = await api.getConsultations(token ?? '');
    return list.map((item) => StudentConsultationModel.fromJson(item)).toList();
  }

  @override
  Future<void> respondToConsultation(String consultationId, String response) async {
    // Implementar si la API lo permite
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    final token = await userService.getToken();
    return await api.getCounselorStats(token ?? '');
  }
}
