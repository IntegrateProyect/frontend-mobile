
import '../../../domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  UniversityModel({
    required super.id,
    required super.name,
    required super.location,
    super.logoUrl,
    required super.availableCareers,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      logoUrl: json['logoUrl'],
      availableCareers: List<String>.from(json['availableCareers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'availableCareers': availableCareers,
    };
  }
}
