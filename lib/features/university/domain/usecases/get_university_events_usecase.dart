import '../entities/university_event_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityEventsUseCase {
  final UniversityRepository repository;

  GetUniversityEventsUseCase(this.repository);

  Future<List<UniversityEventEntity>> call() {
    return repository.getEvents();
  }
}
