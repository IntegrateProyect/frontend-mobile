import '../entities/university_event_entity.dart';
import '../repositories/university_repository.dart';

class UpdateUniversityEventUseCase {
  final UniversityRepository repository;

  UpdateUniversityEventUseCase(this.repository);

  Future<void> call(UniversityEventEntity event) => repository.updateEvent(event);
}
