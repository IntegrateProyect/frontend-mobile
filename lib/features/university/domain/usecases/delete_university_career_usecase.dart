import '../repositories/university_repository.dart';

class DeleteUniversityCareerUseCase {
  final UniversityRepository repository;

  DeleteUniversityCareerUseCase(this.repository);

  Future<void> call(String id) => repository.deleteCareer(id);
}
