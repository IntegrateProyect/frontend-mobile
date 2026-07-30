import 'package:flutter/foundation.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../auth/data/datasources/mappers/auth_mapper.dart';
import '../../../student/domain/entities/student_profile_entity.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/repositories/counselor_repository.dart';

import '../datasources/models/appointment_model.dart';
import '../datasources/models/student_consultation_model.dart';

class CounselorRepositoryImpl implements CounselorRepository {
  final IApi api;
  final UserService userService;

  CounselorRepositoryImpl({
    required this.api,
    required this.userService,
  });

  // =========================================================
  // TOKEN
  // =========================================================

  Future<String> _getToken() async {
    final String? token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception('No hay una sesión activa');
    }

    return token.trim();
  }

  // =========================================================
  // PERFIL DEL ORIENTADOR
  // =========================================================

  @override
  Future<CounselorProfileEntity> getProfile() async {
    final userModel = await userService.getUser();

    if (userModel == null) {
      throw Exception(
        'No se encontró la sesión del orientador',
      );
    }

    final user = AuthMapper.toEntity(userModel);

    return CounselorProfileEntity(
      id: user.id,
      name: _cleanText(
        user.name,
        fallback: 'Orientador',
      ),
      email: _cleanText(
        user.email,
        fallback: 'Sin correo',
      ),
      institution: 'Institución no especificada',
      profileImageUrl: user.effectivePhotoUrl,
    );
  }

  // =========================================================
  // GRUPOS
  // =========================================================

  @override
  Future<List<dynamic>> getGroups() async {
    final String token = await _getToken();

    final List<dynamic> groups = await api.getGroups(
      token,
    );

    debugPrint(
      'GRUPOS DEL ORIENTADOR: $groups',
    );

    return groups;
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(
      String groupId,
      ) async {
    final String token = await _getToken();

    return api.getGroupDetail(
      token,
      groupId,
    );
  }

  @override
  Future<Map<String, dynamic>> createGroup(
      String name,
      String? accessCode,
      ) async {
    final String token = await _getToken();

    final Map<String, dynamic> body = {
      'name': name.trim(),
    };

    final String cleanAccessCode =
        accessCode?.trim() ?? '';

    if (cleanAccessCode.isNotEmpty) {
      body['accessCode'] = cleanAccessCode;
    }

    return api.createGroup(
      token,
      body,
    );
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    final String token = await _getToken();

    final Map<String, dynamic> body = {};

    final String cleanName = name?.trim() ?? '';
    final String cleanCode =
        accessCode?.trim() ?? '';

    if (cleanName.isNotEmpty) {
      body['name'] = cleanName;
    }

    if (cleanCode.isNotEmpty) {
      body['accessCode'] = cleanCode;
    }

    return api.updateGroup(
      token,
      groupId,
      body,
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final String token = await _getToken();
    await api.deleteGroup(token, groupId);
  }

  // =========================================================
  // ALUMNOS DE UN GRUPO
  // =========================================================

  @override
  Future<List<StudentProfileEntity>> getGroupStudents(
      String groupId,
      ) async {
    final String token = await _getToken();

    final List<dynamic> response =
    await api.getGroupStudents(
      token,
      groupId,
    );

    final List<StudentProfileEntity> students = [];

    for (final dynamic item in response) {
      if (item is! Map) continue;

      final Map<String, dynamic> studentData =
      Map<String, dynamic>.from(item);

      final String studentId =
      _extractStudentId(studentData);

      if (studentId.isEmpty) continue;

      String name = _extractStudentName(studentData);
      String email = _extractStudentEmail(studentData);
      String? imageUrl = _extractStudentImage(studentData);

      if (name.isEmpty || email.isEmpty) {
        try {
          final Map<String, dynamic> fileResponse =
          await api.getStudentFile(token, studentId);
          final completeProfile = _extractStudentProfile(fileResponse);
          if (name.isEmpty) name = _extractStudentName(completeProfile);
          if (email.isEmpty) email = _extractStudentEmail(completeProfile);
          imageUrl ??= _extractStudentImage(completeProfile);
        } catch (_) {}
      }

      if (name.isEmpty && email.isNotEmpty && email.contains('@')) {
        name = _nameFromEmail(email);
      }

      students.add(
        StudentProfileEntity(
          id: studentId,
          name: name.isNotEmpty ? name : 'Alumno sin nombre',
          email: email.isNotEmpty ? email : 'Correo no disponible',
          profileImageUrl: imageUrl,
        ),
      );
    }

    return _removeDuplicatedStudents(students);
  }

  @override
  Future<List<StudentProfileEntity>> getStudents() async {
    final String token = await _getToken();

    try {
      final List<dynamic> response = await api.getCounselorStudents(token);
      if (response.isNotEmpty) {
        final List<StudentProfileEntity> students = [];
        for (final dynamic item in response) {
          if (item is! Map) continue;
          final Map<String, dynamic> data = Map<String, dynamic>.from(item);
          final String studentId = _extractStudentId(data);
          if (studentId.isEmpty) continue;

          String name = _extractStudentName(data);
          String email = _extractStudentEmail(data);
          if (name.isEmpty && email.isNotEmpty && email.contains('@')) {
            name = _nameFromEmail(email);
          }

          students.add(
            StudentProfileEntity(
              id: studentId,
              name: name.isNotEmpty ? name : 'Alumno sin nombre',
              email: email.isNotEmpty ? email : 'Correo no disponible',
              profileImageUrl: _extractStudentImage(data),
            ),
          );
        }
        return _removeDuplicatedStudents(students);
      }
    } catch (_) {}

    final List<dynamic> groups = await api.getGroups(token);
    final List<StudentProfileEntity> allStudents = [];
    for (final dynamic item in groups) {
      if (item is! Map) continue;
      final Map<String, dynamic> group = Map<String, dynamic>.from(item);
      final String groupId = group['id']?.toString() ?? '';
      if (groupId.isEmpty) continue;
      try {
        allStudents.addAll(await getGroupStudents(groupId));
      } catch (_) {}
    }

    return _removeDuplicatedStudents(allStudents);
  }

  // =========================================================
  // EXPEDIENTE
  // =========================================================

  @override
  Future<Map<String, dynamic>> getStudentFile(
      String studentId,
      ) async {
    final String token = await _getToken();
    return api.getStudentFile(token, studentId);
  }

  @override
  Future<void> updateStudentParents(
      String studentId,
      String? email1,
      String? email2,
      ) async {
    final String token = await _getToken();
    await api.updateStudentParents(token, studentId, email1, email2);
  }

  @override
  Future<void> sendStudentReport(
      String studentId,
      List<String> emails,
      String format,
      ) async {
    final String token = await _getToken();
    await api.sendStudentReport(token, studentId, emails, format);
  }

  // =========================================================
  // SESIONES
  // =========================================================

  @override
  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    final String token = await _getToken();
    await api.registerSession(token, studentId, sessionData);
  }

  // =========================================================
  // TAREAS
  // =========================================================

  @override
  Future<void> assignTask(
      Map<String, dynamic> taskData,
      ) async {
    final String token = await _getToken();
    await api.createTask(token, taskData);
  }

  // =========================================================
  // SOLICITUD DE APOYO
  // =========================================================

  @override
  Future<void> requestSupport(String message) async {
    final String token = await _getToken();
    await api.requestCounselorSupport(token, message);
  }

  // =========================================================
  // CONSULTAS
  // =========================================================

  @override
  Future<List<StudentConsultationEntity>> getConsultations() async {
    final String token = await _getToken();
    final List<dynamic> response = await api.getConsultations(token);
    return response
        .whereType<Map>()
        .map((dynamic item) => StudentConsultationModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  @override
  Future<void> respondToConsultation(String consultationId, String response) async {
    // Implementar si existe el endpoint
  }

  // =========================================================
  // ESTADÍSTICAS
  // =========================================================

  @override
  Future<Map<String, dynamic>> getStats() async {
    final String token = await _getToken();
    return api.getCounselorStats(token);
  }

  // =========================================================
  // CITAS
  // =========================================================

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    return getCounselorAppointments();
  }

  @override
  Future<List<AppointmentEntity>> getCounselorAppointments() async {
    final String token = await _getToken();
    final List<dynamic> response = await api.getCounselorAppointments(token);
    return response
        .whereType<Map>()
        .map((dynamic item) => AppointmentModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  @override
  Future<void> scheduleAppointment(
      String studentId,
      DateTime date,
      String motive,
      ) async {
    final String token = await _getToken();
    final String cleanStudentId = studentId.trim();
    final String cleanMotive = motive.trim();

    if (cleanStudentId.isEmpty) {
      throw Exception('Selecciona un alumno.');
    }

    if (cleanMotive.isEmpty) {
      throw Exception('Ingresa el motivo de la cita.');
    }

    if (!date.isAfter(DateTime.now())) {
      throw Exception(
        'La fecha y hora de la cita deben ser futuras.',
      );
    }

    // El backend recibe ISO con la hora local que se desea agendar
    await api.counselorScheduleAppointment(
      token,
      <String, dynamic>{
        'studentId': cleanStudentId,
        'sessionDate': date.toIso8601String(),
        'motive': cleanMotive,
      },
    );
  }

  @override
  Future<AppointmentEntity> getAppointmentDetail(String appointmentId) async {
    final String token = await _getToken();
    final response = await api.getAppointmentDetail(token, appointmentId);
    return AppointmentModel.fromJson(response);
  }

  @override
  Future<void> updateAppointment(String appointmentId, Map<String, dynamic> data) async {
    final String token = await _getToken();
    await api.updateAppointment(token, appointmentId, data);
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    final String token = await _getToken();
    await api.deleteAppointment(token, appointmentId);
  }

  // =========================================================
  // DISPONIBILIDAD
  // =========================================================

  @override
  Future<List<dynamic>> getAvailability() async {
    final String token = await _getToken();
    return api.getCounselorAvailability(token);
  }

  @override
  Future<void> saveAvailability(List<Map<String, dynamic>> slots) async {
    final String token = await _getToken();
    await api.saveCounselorAvailability(token, slots);
  }

  // =========================================================
  // HELPERS INTERNOS
  // =========================================================

  String _extractStudentId(Map<String, dynamic> data) {
    return data['studentId']?.toString() ??
        data['student_id']?.toString() ??
        data['userId']?.toString() ??
        data['id']?.toString() ?? '';
  }

  String _extractStudentName(Map<String, dynamic> data) {
    return data['name']?.toString() ??
        data['fullName']?.toString() ??
        data['studentName']?.toString() ?? '';
  }

  String _extractStudentEmail(Map<String, dynamic> data) {
    return data['email']?.toString() ??
        data['studentEmail']?.toString() ?? '';
  }

  String? _extractStudentImage(Map<String, dynamic> data) {
    return data['profileImageUrl']?.toString() ??
        data['avatarUrl']?.toString();
  }

  Map<String, dynamic> _extractStudentProfile(Map<String, dynamic> response) {
    return Map<String, dynamic>.from(response['data'] ?? response);
  }

  List<StudentProfileEntity> _removeDuplicatedStudents(List<StudentProfileEntity> students) {
    final Map<String, StudentProfileEntity> unique = {};
    for (final s in students) {
      if (s.id.isNotEmpty) unique[s.id] = s;
    }
    return unique.values.toList();
  }

  String _nameFromEmail(String email) {
    return email.split('@').first;
  }

  String _cleanText(String? value, {required String fallback}) {
    final t = value?.trim() ?? '';
    return t.isNotEmpty ? t : fallback;
  }
}
