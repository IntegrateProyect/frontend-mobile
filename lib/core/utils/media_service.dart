import 'dart:typed_data';

abstract class MediaService {
  Future<Uint8List?> pickImageFromGallery();
  Future<Uint8List?> takePhoto();
}
