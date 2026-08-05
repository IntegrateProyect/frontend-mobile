import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/models/event_model.dart';

class EventsRepositoryImpl implements EventsRepository {
  final IApi api;
  final UserService userService;

  EventsRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<List<EventEntity>> getEvents() async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      return [];
    }

    final response = await api.getAllCatalogEvents(
      token.trim(),
    );

    return response
        .whereType<Map>()
        .map(
          (item) => EventModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
