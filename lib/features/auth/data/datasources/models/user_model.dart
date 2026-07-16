import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.avatarUrl,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = _unwrapUser(json);

    final Map<String, dynamic>? profile =
        _asMap(data['profile']) ??
            _asMap(data['userProfile']);

    final String? firstName = _firstNonEmpty([
      data['firstName'],
      data['first_name'],
      data['nombre'],
      profile?['firstName'],
      profile?['first_name'],
      profile?['nombre'],
    ]);

    final String? lastName = _firstNonEmpty([
      data['lastName'],
      data['last_name'],
      data['apellido'],
      data['apellidos'],
      profile?['lastName'],
      profile?['last_name'],
      profile?['apellido'],
      profile?['apellidos'],
    ]);

    final String composedName = [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].join(' ').trim();

    final String? resolvedName = _firstNonEmpty([
      data['name'],
      data['fullName'],
      data['full_name'],
      data['displayName'],
      data['username'],
      data['nombreCompleto'],
      profile?['name'],
      profile?['fullName'],
      profile?['full_name'],
      profile?['nombreCompleto'],
      composedName,
    ]);

    return UserModel(
      id: _firstNonEmpty([
        data['id'],
        data['_id'],
        data['userId'],
        data['user_id'],
      ]) ??
          '',
      email: _firstNonEmpty([
        data['email'],
        data['correo'],
        profile?['email'],
      ]) ??
          '',
      name: resolvedName,
      photoUrl: _firstNonEmpty([
        data['photoUrl'],
        data['photo_url'],
        data['imageUrl'],
        profile?['photoUrl'],
      ]),
      avatarUrl: _firstNonEmpty([
        data['avatarUrl'],
        data['avatar_url'],
        data['profileImageUrl'],
        data['profile_image_url'],
        profile?['avatarUrl'],
        profile?['profileImageUrl'],
      ]),
      role: _extractRole(
        data['roleName'] ??
            data['role'] ??
            data['type'] ??
            data['userRole'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'avatarUrl': avatarUrl,
      'roleName': role,
    };
  }

  static Map<String, dynamic> _unwrapUser(
      Map<String, dynamic> json,
      ) {
    Map<String, dynamic> data = Map<String, dynamic>.from(json);

    if (data['data'] is Map) {
      data = Map<String, dynamic>.from(
        data['data'] as Map,
      );
    }

    if (data['user'] is Map) {
      data = Map<String, dynamic>.from(
        data['user'] as Map,
      );
    }

    return data;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
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

  static String? _extractRole(dynamic value) {
    if (value is Map) {
      return _firstNonEmpty([
        value['name'],
        value['roleName'],
        value['code'],
        value['type'],
      ]);
    }

    return _firstNonEmpty([value]);
  }
}