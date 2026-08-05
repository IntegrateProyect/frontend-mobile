import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../counselor/data/datasources/models/appointment_model.dart';
import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../domain/repositories/student_appointments_repository.dart';

class StudentAppointmentsRepositoryImpl implements StudentAppointmentsRepository {
  final IApi api;
  final UserService userService;

  StudentAppointmentsRepositoryImpl({
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
  Future<void> scheduleAppointment(
    DateTime date,
    String motive,
  ) async {
    final token = await _requireToken();

    await api.scheduleAppointment(
      token,
      {
        'sessionDate': date.toIso8601String(),
        'motive': motive,
      },
    );
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      return [];
    }

    final response = await api.getStudentAppointments(
      token.trim(),
    );

    return response
        .whereType<Map>()
        .map(
          (item) => AppointmentModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
