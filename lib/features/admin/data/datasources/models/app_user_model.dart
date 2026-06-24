import '../../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
    };
  }
}
