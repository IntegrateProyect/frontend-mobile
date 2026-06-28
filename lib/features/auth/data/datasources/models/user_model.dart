import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Forzamos la conversión a String y evitamos nulos en campos requeridos
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: json['name']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      // Buscamos el rol en diferentes posibles nombres de campo del backend
      role: (json['roleName'] ?? json['role'] ?? json['type'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'roleName': role,
    };
  }
}
