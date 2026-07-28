import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../counselor/data/datasources/models/appointment_model.dart';
import '../../../counselor/domain/entities/appointment_entity.dart';
import '../../../university/data/datasources/models/university_catalog_page_model.dart';
import '../../../university/domain/entities/scholarship_entity.dart';
import '../../../university/domain/entities/university_catalog_page_entity.dart';
import '../../domain/entities/alumni_entity.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/university_catalog_page_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/student_repository.dart';

import '../datasources/models/student_profile_model.dart';
import '../datasources/models/university_catalog_page_model.dart';
import '../datasources/models/vocational_result_model.dart';
import '../datasources/models/appointment_model.dart';
import '../datasources/models/event_model.dart';

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

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'No hay token para obtener el perfil',
      );
    }

    final response = await api.getStudentProfile(token);

    final dynamic data = response['data'] ?? response;

    if (data is Map<String, dynamic>) {
      return StudentProfileModel.fromJson(data);
    }

    if (data is Map) {
      return StudentProfileModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }

    throw Exception(
      'Formato inválido del perfil del estudiante',
    );
  }

  @override
  Future<void> updateProfile(
      StudentProfileEntity profile,
      ) async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'No hay token para actualizar el perfil',
      );
    }

    // Mapeo directo para evitar errores de compilación con toJson()
    final Map<String, dynamic> profileData = {
      'name': profile.name,
      'subjectsLiked': profile.subjectsLiked,
      'subjectsDisliked': profile.subjectsDisliked,
      'interests': profile.interests,
      'skills': profile.skills,
      'needsScholarship': profile.needsScholarship,
      'studyAbroad': profile.studyAbroad,
      'vocationalClarity': profile.vocationalClarity,
    };

    await api.updateStudentProfile(
      token,
      profileData,
    );
  }

  @override
  Future<List<VocationalResultEntity>>
  getVocationalResults() async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      return [];
    }

    final List<dynamic> response =
    await api.getGameResults(token);

    return response
        .whereType<Map>()
        .map(
          (item) => VocationalResultModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  @override
  Future<List<CareerEntity>>
  getRecommendedCareers() async {
    return [];
  }

  @override
  Future<UniversityCatalogPageEntity>getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  }) async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'No hay una sesión activa para consultar universidades',
      );
    }

    final response = await api.getCatalogUniversities(
      token,
      page: page,
      limit: limit,
      search: search,
    );

    return UniversityCatalogPageModel.fromJson(
      response,
    );
  }

  @override
  Future<void> saveFavorite(
      String id,
      String type,
      ) async {
    // Pendiente de conectar con el endpoint.
  }

  @override
  Future<void> requestCounselorSupport(
      String message,
      ) async {
    // Pendiente de conectar con el endpoint.
  }

  @override
  Future<List<ScholarshipEntity>>
  getScholarships() async {
    return [];
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    final token = await userService.getToken();
    if (token == null || token.trim().isEmpty) {
      return [];
    }

    final response = await api.getAllCatalogEvents(token.trim());

    return response
        .whereType<Map>()
        .map(
          (item) => EventModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  @override
  Future<List<AlumniEntity>> getAlumni() async {
    return [];
  }

  @override
  Future<void> scheduleAppointment(DateTime date, String motive) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('No autenticado');

    await api.scheduleAppointment(token, {
      'sessionDate': date.toIso8601String(),
      'motive': motive,
    });
  }

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final token = await userService.getToken();
    if (token == null) return [];

    final response = await api.getStudentAppointments(token);
    return response.map((item) => AppointmentModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }
}
