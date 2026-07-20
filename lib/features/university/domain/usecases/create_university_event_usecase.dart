import '../entities/university_event_entity.dart';
import '../repositories/university_repository.dart';

class CreateUniversityEventUseCase {
  final UniversityRepository repository;

  CreateUniversityEventUseCase(this.repository);

  Future<void> call(UniversityEventEntity event) => repository.createEvent(event);
}
