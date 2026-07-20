import '../repositories/university_repository.dart';

class DeleteUniversityEventUseCase {
  final UniversityRepository repository;

  DeleteUniversityEventUseCase(this.repository);

  Future<void> call(String eventId) => repository.deleteEvent(eventId);
}
