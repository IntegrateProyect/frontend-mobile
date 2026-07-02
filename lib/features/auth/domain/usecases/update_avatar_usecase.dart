import 'dart:typed_data';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateAvatarUseCase {
  final AuthRepository repository;

  UpdateAvatarUseCase(this.repository);

  Future<UserEntity> call(Uint8List imageBytes) {
    return repository.updateAvatar(imageBytes);
  }
}
