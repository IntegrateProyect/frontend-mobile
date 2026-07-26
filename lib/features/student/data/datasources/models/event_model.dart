
import '../../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.location,
    required super.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] ?? json['eventDate'];
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: rawDate != null ? DateTime.parse(rawDate.toString()) : DateTime.now(),
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
    };
  }
}
