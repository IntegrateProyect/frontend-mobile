import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../domain/entities/alumni_entity.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/repositories/student_repository.dart';

import '../datasources/models/student_profile_model.dart';
import '../datasources/models/vocational_result_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final IApi api;
  final UserService userService;

  StudentRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<StudentProfileEntity> getProfile() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token para obtener perfil');
    }

    final response = await api.getStudentProfile(token);

    debugPrint('XXX GET STUDENT PROFILE RESPONSE: $response');

    final dynamic data = response['data'] ?? response;

    if (data is Map<String, dynamic>) {
      return StudentProfileModel.fromJson(data);
    }

    if (data is Map) {
      return StudentProfileModel.fromJson(Map<String, dynamic>.from(data));
    }

    throw Exception('Formato inválido del perfil del estudiante');
  }

  @override
  Future<void> updateProfile(StudentProfileEntity profile) async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token para actualizar perfil');
    }

    final model = StudentProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      profileImageUrl: profile.profileImageUrl,
      groupName: profile.groupName,
      groupCode: profile.groupCode,
      subjectsLiked: profile.subjectsLiked,
      subjectsDisliked: profile.subjectsDisliked,
      interests: profile.interests,
      skills: profile.skills,
      needsScholarship: profile.needsScholarship,
      studyAbroad: profile.studyAbroad,
      vocationalClarity: profile.vocationalClarity,
    );

    await api.updateStudentProfile(token, model.toJson());
  }

  @override
  Future<List<VocationalResultEntity>> getVocationalResults() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      return [];
    }

    final List<dynamic> data = await api.getGameResults(token);

    return data
        .map(
          (item) => VocationalResultModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  @override
  Future<List<CareerEntity>> getRecommendedCareers() async {
    return [];
  }

  @override
  Future<List<UniversityEntity>> getCompatibleUniversities() async {
    return [];
  }

  @override
  Future<void> saveFavorite(String id, String type) async {}

  @override
  Future<void> requestCounselorSupport(String message) async {}

  @override
  Future<List<ScholarshipEntity>> getScholarships() async {
    return [];
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    return [];
  }

  @override
  Future<List<AlumniEntity>> getAlumni() async {
    return [];
  }
}