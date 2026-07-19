import '../../../domain/entities/university_announcement_entity.dart';

class UniversityAnnouncementModel extends UniversityAnnouncementEntity {
  UniversityAnnouncementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    super.universityName,
  });

  factory UniversityAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return UniversityAnnouncementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      universityName: json['universityName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'universityName': universityName,
    };
  }
}
