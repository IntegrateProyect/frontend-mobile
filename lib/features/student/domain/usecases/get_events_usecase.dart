import '../entities/event_entity.dart';
import '../repositories/student_repository.dart';

class GetEventsUseCase {
  final StudentRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<EventEntity>> call() {
    return repository.getEvents();
  }
}
