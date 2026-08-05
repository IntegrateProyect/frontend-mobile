import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEventsUseCase {
  final EventsRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<EventEntity>> call() {
    return repository.getEvents();
  }
}
