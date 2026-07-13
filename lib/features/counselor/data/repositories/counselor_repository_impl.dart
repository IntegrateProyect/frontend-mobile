import 'package:flutter/material.dart';

import 'package:orientate/features/student/data/datasources/models/student_profile_model.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import 'package:orientate/features/student/domain/entities/appointment_entity.dart';
import 'package:orientate/features/student/data/datasources/models/appointment_model.dart';

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

  CounselorRepositoryImpl({
    required this.api,
    required this.userService,
  });

  Future<String> _getToken() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    return token;
  }

  @override
  Future<CounselorProfileEntity> getProfile() async {
    final userModel = await userService.getUser();

    if (userModel == null) {
      throw Exception('No se encontró sesión de usuario');
    }

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
    final token = await _getToken();
    return api.getGroups(token);
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(String groupId) async {
    final token = await _getToken();
    return api.getGroupDetail(token, groupId);
  }

  @override
  Future<Map<String, dynamic>> createGroup(
      String name,
      String? accessCode,
      ) async {
    final token = await _getToken();

    return api.createGroup(token, {
      'name': name,
      'accessCode': accessCode ?? '',
    });
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    final token = await _getToken();

    final data = <String, dynamic>{};

    if (name != null && name.trim().isNotEmpty) {
      data['name'] = name.trim();
    }

    if (accessCode != null && accessCode.trim().isNotEmpty) {
      data['accessCode'] = accessCode.trim();
    }

    return api.updateGroup(token, groupId, data);
  }

  @override
  Future<List<dynamic>> getGroupStudents(String groupId) async {
    final token = await _getToken();
    return api.getGroupStudents(token, groupId);
  }

  @override
  Future<List<StudentProfileEntity>> getStudents() async {
    final token = await _getToken();

    final directStudents = await api.getCounselorStudents(token);

    if (directStudents.isNotEmpty) {
      final students = directStudents.map((item) {
        final normalized = _normalizeStudentJson(item);
        return StudentProfileModel.fromJson(normalized);
      }).toList();

      return _removeDuplicatedStudents(students);
    }

    final groups = await api.getGroups(token);

    final List<StudentProfileEntity> allStudents = [];

    for (final groupRaw in groups) {
      final group = _asMap(groupRaw);
      final groupId = _getString(
        group['id'] ??
            group['_id'] ??
            group['groupId'],
      );

      if (groupId.isEmpty) continue;

      final groupName = _getString(
        group['name'] ??
            group['groupName'],
      );

      final groupCode = _getString(
        group['accessCode'] ??
            group['access_code'] ??
            group['code'],
      );

      final studentsByGroup = await api.getGroupStudents(token, groupId);

      for (final item in studentsByGroup) {
        final normalized = _normalizeStudentJson(
          item,
          groupName: groupName,
          groupCode: groupCode,
        );
        allStudents.add(StudentProfileModel.fromJson(normalized));
      }
    }

    return _removeDuplicatedStudents(allStudents);
  }

  List<StudentProfileEntity> _removeDuplicatedStudents(
      List<StudentProfileEntity> students,
      ) {
    final Map<String, StudentProfileEntity> unique = {};

    for (final student in students) {
      final key = student.id.trim().isNotEmpty
          ? student.id
          : '${student.name}-${student.email}';

      unique[key] = student;
    }

    return unique.values.toList();
  }

  Map<String, dynamic> _normalizeStudentJson(
      dynamic raw, {
        String? groupName,
        String? groupCode,
      }) {
    final map = _asMap(raw);

    final student = _asMap(map['student']);
    final user = _asMap(map['user']);
    final profile = _asMap(map['profile']);
    final authUser = _asMap(map['authUser']);
    final account = _asMap(map['account']);
    final group = _asMap(map['group']);
    final schoolGroup = _asMap(map['schoolGroup']);
    final classroom = _asMap(map['classroom']);

    final source = <String, dynamic>{};

    source.addAll(map);
    source.addAll(student);
    source.addAll(profile);

    source['id'] = _firstNotEmpty([
      map['id'],
      map['_id'],
      map['studentId'],
      map['userId'],
      student['id'],
      student['_id'],
      profile['id'],
      profile['_id'],
      user['id'],
      user['_id'],
      authUser['id'],
      account['id'],
    ]);

    source['name'] = _firstNotEmpty([
      map['name'],
      map['fullName'],
      map['studentName'],
      map['nombre'],
      map['nombre_completo'],
      student['name'],
      student['fullName'],
      student['nombre'],
      student['nombre_completo'],
      profile['name'],
      profile['fullName'],
      user['name'],
      user['fullName'],
      user['nombre'],
      authUser['name'],
      authUser['fullName'],
      account['name'],
      account['fullName'],
      _buildFullName([
        map['firstName'],
        map['lastName'],
      ]),
      _buildFullName([
        student['firstName'],
        student['lastName'],
      ]),
      _buildFullName([
        user['firstName'],
        user['lastName'],
      ]),
      _buildFullName([
        map['nombre'],
        map['apellido'],
      ]),
      _buildFullName([
        student['nombre'],
        student['apellido'],
      ]),
    ]);

    source['email'] = _firstNotEmpty([
      map['email'],
      map['studentEmail'],
      map['correo'],
      student['email'],
      student['studentEmail'],
      student['correo'],
      profile['email'],
      user['email'],
      user['correo'],
      authUser['email'],
      account['email'],
    ]);

    source['profileImageUrl'] = _firstNotEmpty([
      map['profileImageUrl'],
      map['avatarUrl'],
      map['photoUrl'],
      student['profileImageUrl'],
      student['avatarUrl'],
      student['photoUrl'],
      profile['profileImageUrl'],
      user['profileImageUrl'],
      user['avatarUrl'],
      user['photoUrl'],
      authUser['avatarUrl'],
      account['avatarUrl'],
    ]);

    source['groupName'] = _firstNotEmpty([
      groupName,
      map['groupName'],
      map['group_name'],
      group['name'],
      group['groupName'],
      schoolGroup['name'],
      classroom['name'],
    ]);

    source['groupCode'] = _firstNotEmpty([
      groupCode,
      map['groupCode'],
      map['accessCode'],
      map['group_code'],
      group['accessCode'],
      group['access_code'],
      group['code'],
      schoolGroup['accessCode'],
      classroom['accessCode'],
    ]);

    source['interests'] = _firstList([
      map['interests'],
      map['intereses'],
      student['interests'],
      student['intereses'],
      profile['interests'],
      profile['intereses'],
    ]);

    source['skills'] = _firstList([
      map['skills'],
      map['habilidades'],
      student['skills'],
      student['habilidades'],
      profile['skills'],
      profile['habilidades'],
    ]);

    source['subjectsLiked'] = _firstList([
      map['subjectsLiked'],
      map['favoriteSubjects'],
      profile['subjectsLiked'],
      student['subjectsLiked'],
    ]);

    source['subjectsDisliked'] = _firstList([
      map['subjectsDisliked'],
      profile['subjectsDisliked'],
      student['subjectsDisliked'],
    ]);

    source['needsScholarship'] =
        map['needsScholarship'] ?? profile['needsScholarship'] ?? false;

    source['studyAbroad'] =
        map['studyAbroad'] ?? profile['studyAbroad'] ?? false;

    source['vocationalClarity'] = _firstNotEmpty([
      map['vocationalClarity'],
      map['careerCertainty'],
      map['clarity'],
      map['claridadVocacional'],
      student['vocationalClarity'],
      profile['vocationalClarity'],
      profile['clarity'],
    ]);

    return source;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  String _getString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  dynamic _firstNotEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;

      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }

      if (value is num || value is bool) {
        return value;
      }
    }

    return null;
  }

  List<String> _firstList(List<dynamic> values) {
    for (final value in values) {
      if (value is List && value.isNotEmpty) {
        return value.map((e) => e.toString()).toList();
      }

      if (value is String && value.trim().isNotEmpty) {
        return value
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return [];
  }

  String? _buildFullName(List<dynamic> parts) {
    final text = parts
        .where((part) => part != null && part.toString().trim().isNotEmpty)
        .map((part) => part.toString().trim())
        .join(' ');

    return text.isEmpty ? null : text;
  }

  @override
  Future<Map<String, dynamic>> getStudentFile(String studentId) async {
    final token = await _getToken();
    return api.getStudentFile(token, studentId);
  }

  @override
  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    final token = await _getToken();
    await api.registerSession(token, studentId, sessionData);
  }

  @override
  Future<void> assignTask(Map<String, dynamic> taskData) async {
    final token = await _getToken();
    await api.createTask(token, taskData);
  }

  @override
  Future<List<StudentConsultationEntity>> getConsultations() async {
    final token = await _getToken();
    final list = await api.getConsultations(token);

    return list.map((item) {
      return StudentConsultationModel.fromJson(_asMap(item));
    }).toList();
  }

  @override
  Future<void> respondToConsultation(
      String consultationId,
      String response,
      ) async {
    // Pendiente si el backend agrega este endpoint.
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    final token = await _getToken();
    return api.getCounselorStats(token);
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final token = await _getToken();
    final response = await api.getCounselorAppointments(token);
    return response.map((item) => AppointmentModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }
}
