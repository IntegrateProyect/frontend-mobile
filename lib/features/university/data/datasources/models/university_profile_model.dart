import '../../../domain/entities/university_profile_entity.dart';

class UniversityProfileModel extends UniversityProfileEntity {
  UniversityProfileModel({
    required super.id,
    required super.name,
    required super.description,
    required super.location,
    super.logoUrl,
    super.website,
  });

  factory UniversityProfileModel.fromJson(Map<String, dynamic> json) {
    return UniversityProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      logoUrl: json['logoUrl'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'logoUrl': logoUrl,
      'website': website,
    };
  }
}
