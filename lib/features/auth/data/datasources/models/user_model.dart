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
    // Búsqueda profunda: el usuario puede venir en la raíz, en 'data', en 'user' o en 'data.user'
    Map<String, dynamic> data = json;
    
    if (json['data'] is Map) {
      data = Map<String, dynamic>.from(json['data']);
    }
    
    // Si después de extraer 'data', existe una clave 'user', entramos un nivel más
    if (data['user'] is Map) {
      data = Map<String, dynamic>.from(data['user']);
    }

    return UserModel(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      name: (data['name'] ?? data['fullName'] ?? '').toString(),
      photoUrl: data['photoUrl']?.toString(),
      avatarUrl: (data['avatarUrl'] ?? data['avatar_url'])?.toString(),
      role: (data['roleName'] ?? data['role'] ?? data['type'])?.toString(),
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
}
