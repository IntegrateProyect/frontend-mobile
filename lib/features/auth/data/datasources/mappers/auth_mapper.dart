import '../../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      photoUrl: model.photoUrl,
      avatarUrl: model.avatarUrl,
      role: model.role,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
    );
  }
}
