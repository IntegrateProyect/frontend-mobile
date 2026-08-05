import 'dart:typed_data';
import '../../../../core/utils/media_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/update_avatar_usecase.dart';

class AuthAvatarService {
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final MediaService _mediaService;

  AuthAvatarService({
    required UpdateAvatarUseCase updateAvatarUseCase,
    required MediaService mediaService,
  })  : _updateAvatarUseCase = updateAvatarUseCase,
        _mediaService = mediaService;

  Future<UserEntity> updateAvatar(Uint8List imageBytes) async {
    return await _updateAvatarUseCase(imageBytes);
  }

  Future<Uint8List?> pickImageFromGallery() async {
    return await _mediaService.pickImageFromGallery();
  }

  Future<Uint8List?> takePhoto() async {
    return await _mediaService.takePhoto();
  }
}
