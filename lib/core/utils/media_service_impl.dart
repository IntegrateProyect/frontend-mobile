import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'media_service.dart';

class MediaServiceImpl implements MediaService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Uint8List?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      return null;
    }
  }
}
