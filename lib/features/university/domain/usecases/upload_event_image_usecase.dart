import 'dart:typed_data';
import '../repositories/university_repository.dart';

class UploadEventImageUseCase {
  final UniversityRepository repository;

  UploadEventImageUseCase(this.repository);

  Future<String> call(Uint8List bytes, String contentType) => repository.uploadEventImage(bytes, contentType);
}
