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
    final student = _asMap(json['student']);
    final user = _asMap(json['user']);
    final profile = _asMap(json['profile']);
    final group = _asMap(json['group']);
    final schoolGroup = _asMap(json['schoolGroup']);

    final firstName = _str(
      json['firstName'] ??
          user['firstName'] ??
          student['firstName'] ??
          profile['firstName'],
    );

    final lastName = _str(
      json['lastName'] ??
          user['lastName'] ??
          student['lastName'] ??
          profile['lastName'],
    );

    final fullName = _str(
      json['name'] ??
          json['fullName'] ??
          json['studentName'] ??
          user['name'] ??
          user['fullName'] ??
          student['name'] ??
          student['fullName'] ??
          profile['name'] ??
          profile['fullName'],
    );

    final name = fullName.isNotEmpty
        ? fullName
        : '$firstName $lastName'.trim().isNotEmpty
        ? '$firstName $lastName'.trim()
        : 'Estudiante';

    return StudentProfileModel(
      id: _str(
        json['id'] ??
            json['studentId'] ??
            json['userId'] ??
            student['id'] ??
            user['id'] ??
            profile['id'],
      ),
      name: name,
      email: _str(
        json['email'] ??
            json['studentEmail'] ??
            user['email'] ??
            student['email'] ??
            profile['email'],
        fallback: 'Sin correo',
      ),
      profileImageUrl: _nullableStr(
        json['profileImageUrl'] ??
            json['avatarUrl'] ??
            json['photoUrl'] ??
            user['profileImageUrl'] ??
            user['avatarUrl'] ??
            user['photoUrl'] ??
            student['profileImageUrl'] ??
            profile['profileImageUrl'],
      ),
      groupName: _nullableStr(
        json['groupName'] ??
            json['group_name'] ??
            group['name'] ??
            group['groupName'] ??
            schoolGroup['name'],
      ),
      groupCode: _nullableStr(
        json['groupCode'] ??
            json['accessCode'] ??
            json['group_code'] ??
            group['accessCode'] ??
            group['code'] ??
            schoolGroup['accessCode'],
      ),
      subjectsLiked: _toStringList(
        json['subjectsLiked'] ??
            profile['subjectsLiked'] ??
            json['favoriteSubjects'],
      ),
      subjectsDisliked: _toStringList(
        json['subjectsDisliked'] ?? profile['subjectsDisliked'],
      ),
      interests: _toStringList(
        json['interests'] ??
            profile['interests'] ??
            student['interests'],
      ),
      skills: _toStringList(
        json['skills'] ??
            profile['skills'] ??
            student['skills'],
      ),
      needsScholarship: json['needsScholarship'] == true ||
          profile['needsScholarship'] == true,
      studyAbroad: json['studyAbroad'] == true || profile['studyAbroad'] == true,
      vocationalClarity: _toInt(
        json['vocationalClarity'] ??
            profile['vocationalClarity'] ??
            student['vocationalClarity'] ??
            json['clarity'],
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