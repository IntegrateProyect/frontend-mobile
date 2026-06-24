import '../../../domain/entities/university_career_entity.dart';

class UniversityCareerModel extends UniversityCareerEntity {
  UniversityCareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.duration,
    required super.cost,
  });

  factory UniversityCareerModel.fromJson(Map<String, dynamic> json) {
    return UniversityCareerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'cost': cost,
    };
  }
}
