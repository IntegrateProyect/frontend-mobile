import '../../../domain/entities/student_profile_entity.dart';

class StudentProfileModel extends StudentProfileEntity {
  StudentProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImageUrl,
    super.groupName,
    super.groupCode,
    super.subjectsLiked,
    super.subjectsDisliked,
    super.interests,
    super.skills,
    super.needsScholarship,
    super.studyAbroad,
    super.vocationalClarity,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']);
    final student = _asMap(json['student']);
    final authUser = _asMap(json['authUser']);
    final profile = _asMap(json['profile']);
    final group = _asMap(json['group']);
    final schoolGroup = _asMap(json['schoolGroup']);
    final classroom = _asMap(json['classroom']);

    // Intentar construir el nombre completo desde diversas fuentes y formatos
    String? foundName;

    // Lista de posibles fuentes de datos de usuario/nombre
    final sources = [json, user, student, authUser, profile];

    for (var source in sources) {
      if (source.isEmpty) continue;

      // 1. Prioridad a nombres completos
      foundName = source['name'] ?? source['fullName'] ?? source['display_name'] ?? source['nombre_completo'];
      if (foundName != null) break;

      // 2. Intentar combinar primer nombre y apellido
      final first = source['firstName'] ?? source['first_name'] ?? source['nombre'];
      final last = source['lastName'] ?? source['last_name'] ?? source['apellido'];

      if (first != null || last != null) {
        foundName = '${first ?? ''} ${last ?? ''}'.trim();
        if (foundName!.isNotEmpty) break;
      }
    }

    return StudentProfileModel(
      id: _str(json['id'] ?? user['id'] ?? student['id'] ?? authUser['id'] ?? profile['id']),
      name: _str(foundName, fallback: 'Estudiante'),
      email: _str(
        json['email'] ??
            user['email'] ??
            student['email'] ??
            authUser['email'] ??
            profile['email'],
        fallback: 'Sin correo',
      ),
      profileImageUrl: _nullableStr(
        json['profileImageUrl'] ??
            json['avatarUrl'] ??
            user['profileImageUrl'] ??
            user['avatarUrl'] ??
            json['photoUrl'] ??
            profile['photoUrl'] ??
            user['photoUrl'],
      ),
      groupName: _nullableStr(
        json['groupName'] ??
            json['group_name'] ??
            group['name'] ??
            group['groupName'] ??
            schoolGroup['name'] ??
            classroom['name'],
      ),
      groupCode: _nullableStr(
        json['groupCode'] ??
            json['accessCode'] ??
            json['group_code'] ??
            group['accessCode'] ??
            group['code'] ??
            schoolGroup['accessCode'] ??
            classroom['accessCode'],
      ),
      subjectsLiked: _toStringList(
        json['subjectsLiked'] ?? json['favoriteSubjects'] ?? json['likes'],
      ),
      subjectsDisliked: _toStringList(
        json['subjectsDisliked'] ?? json['dislikedSubjects'] ?? json['dislikes'],
      ),
      interests: _toStringList(json['interests'] ?? json['intereses']),
      skills: _toStringList(json['skills'] ?? json['habilidades']),
      needsScholarship: json['needsScholarship'] == true,
      studyAbroad: json['studyAbroad'] == true,
      vocationalClarity: _toInt(
        json['vocationalClarity'] ?? json['careerCertainty'] ?? json['clarity'],
        fallback: 1,
      ).clamp(1, 10),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectsLiked': subjectsLiked,
      'subjectsDisliked': subjectsDisliked,
      'interests': interests,
      'skills': skills,
      'needsScholarship': needsScholarship,
      'studyAbroad': studyAbroad,
      'vocationalClarity': vocationalClarity,
    };
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  static String _str(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String? _nullableStr(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
