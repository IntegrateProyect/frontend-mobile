import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../university/data/datasources/models/university_announcement_model.dart';
import '../../../university/domain/entities/university_announcement_entity.dart';
import '../../domain/repositories/student_announcements_repository.dart';

class StudentAnnouncementsRepositoryImpl implements StudentAnnouncementsRepository {
  final IApi api;
  final UserService userService;

  StudentAnnouncementsRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<List<UniversityAnnouncementEntity>> getAnnouncements() async {
    final token = await userService.getToken();
    if (token == null || token.trim().isEmpty) return [];

    final list = await api.getStudentAnnouncements(token.trim());
    return list
        .map((item) => UniversityAnnouncementModel.fromJson(
            Map<String, dynamic>.from(item)))
        .toList();
  }
}
