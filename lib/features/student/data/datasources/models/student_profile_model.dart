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

  factory StudentProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final Map<String, dynamic> root = _unwrapData(json);

    final Map<String, dynamic>? profile = _firstMap([
      root['profile'],
      root['studentProfile'],
      root['student_profile'],
      root['vocationalProfile'],
    ]);

    final Map<String, dynamic> data = {
      ...root,
      if (profile != null) ...profile,
    };

    final Map<String, dynamic>? student = _firstMap([
      data['student'],
      root['student'],
    ]);

    final Map<String, dynamic>? user = _firstMap([
      data['user'],
      root['user'],
      student?['user'],
      profile?['user'],
    ]);

    final Map<String, dynamic>? group = _firstMap([
      data['group'],
      data['studentGroup'],
      student?['group'],
    ]);

    final String? firstName = _firstNonEmpty([
      data['firstName'],
      data['first_name'],
      data['nombre'],
      user?['firstName'],
      user?['first_name'],
      user?['nombre'],
    ]);

    final String? lastName = _firstNonEmpty([
      data['lastName'],
      data['last_name'],
      data['apellido'],
      data['apellidos'],
      user?['lastName'],
      user?['last_name'],
      user?['apellido'],
      user?['apellidos'],
    ]);

    final String composedName = [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].join(' ').trim();

    final String resolvedName = _firstNonEmpty([
      data['name'],
      data['fullName'],
      data['full_name'],
      data['nombreCompleto'],
      user?['name'],
      user?['fullName'],
      user?['full_name'],
      user?['nombreCompleto'],
      composedName,
    ]) ??
        '';

    return StudentProfileModel(
      id: _firstNonEmpty([
        data['id'],
        data['_id'],
        data['studentId'],
        data['student_id'],
        user?['id'],
      ]) ??
          '',
      name: resolvedName,
      email: _firstNonEmpty([
        data['email'],
        data['correo'],
        user?['email'],
      ]) ??
          '',
      profileImageUrl: _firstNonEmpty([
        data['profileImageUrl'],
        data['profile_image_url'],
        data['avatarUrl'],
        data['avatar_url'],
        user?['profileImageUrl'],
        user?['avatarUrl'],
      ]),
      groupName: _firstNonEmpty([
        data['groupName'],
        data['group_name'],
        group?['name'],
        group?['groupName'],
      ]),
      groupCode: _firstNonEmpty([
        data['groupCode'],
        data['group_code'],
        group?['accessCode'],
        group?['access_code'],
        group?['code'],
      ]),
      subjectsLiked: _toStringList(
        data['subjectsLiked'] ??
            data['subjects_liked'],
      ),
      subjectsDisliked: _toStringList(
        data['subjectsDisliked'] ??
            data['subjects_disliked'],
      ),
      interests: _toStringList(
        data['interests'],
      ),
      skills: _toStringList(
        data['skills'],
      ),
      needsScholarship: _toBool(
        data['needsScholarship'] ??
            data['needs_scholarship'],
      ),
      studyAbroad: _toBool(
        data['studyAbroad'] ??
            data['study_abroad'],
      ),
      vocationalClarity: _toInt(
        data['vocationalClarity'] ??
            data['vocational_clarity'],
        fallback: 1,
      ),
    );
  }

  static Map<String, dynamic> _unwrapData(
      Map<String, dynamic> json,
      ) {
    if (json['data'] is Map) {
      return Map<String, dynamic>.from(
        json['data'] as Map,
      );
    }

    return Map<String, dynamic>.from(json);
  }

  static Map<String, dynamic>? _firstMap(
      Iterable<dynamic> values,
      ) {
    for (final value in values) {
      if (value is Map<String, dynamic>) {
        return value;
      }

      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
    }

    return null;
  }

  static String? _firstNonEmpty(
      Iterable<dynamic> values,
      ) {
    for (final value in values) {
      final String text = value?.toString().trim() ?? '';

      if (text.isNotEmpty &&
          text.toLowerCase() != 'null' &&
          text.toLowerCase() != 'undefined') {
        return text;
      }
    }

    return null;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value
        .map((item) {
      if (item is Map) {
        return _firstNonEmpty([
          item['name'],
          item['label'],
          item['title'],
          item['value'],
        ]) ??
            '';
      }

      return item?.toString().trim() ?? '';
    })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().toLowerCase();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'si' ||
        normalized == 'sí';
  }

  static int _toInt(
      dynamic value, {
        required int fallback,
      }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        fallback;
  }
}