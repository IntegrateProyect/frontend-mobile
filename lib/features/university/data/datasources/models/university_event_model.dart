import '../../../domain/entities/university_event_entity.dart';

class UniversityEventModel extends UniversityEventEntity {
  UniversityEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.location,
    super.careerId,
    super.imageUrl,
    super.universityName,
  });

  factory UniversityEventModel.fromJson(Map<String, dynamic> json) {
    return UniversityEventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['eventDate'] != null 
          ? DateTime.parse(json['eventDate']) 
          : (json['date'] != null ? DateTime.parse(json['date']) : DateTime.now()),
      location: json['location'] ?? '',
      careerId: json['careerId']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      universityName: json['universityName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': date.toIso8601String(),
      'location': location,
      'careerId': careerId,
      'imageUrl': imageUrl,
      'universityName': universityName,
    };
  }
}
