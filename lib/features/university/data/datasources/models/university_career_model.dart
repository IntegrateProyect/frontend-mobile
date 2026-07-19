import '../../../domain/entities/university_career_entity.dart';

class UniversityCareerModel extends UniversityCareerEntity {
  UniversityCareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.cost,
    super.location,
    super.modality,
    super.scholarshipAvailable,
    super.admissionDates,
    super.latitude,
    super.longitude,
    super.duration,
  });

  factory UniversityCareerModel.fromJson(Map<String, dynamic> json) {
    return UniversityCareerModel(
      id: json['id'] ?? json['careerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      cost: (json['cost'] ?? json['costApprox'] as num?)?.toDouble() ?? 0.0,
      location: json['location'],
      modality: json['modality'],
      scholarshipAvailable: json['scholarshipAvailable'] ?? json['scholarship_available'],
      admissionDates: json['admissionDates'] ?? json['admission_dates'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cost': cost,
      'location': location,
      'modality': modality,
      'scholarshipAvailable': scholarshipAvailable,
      'admissionDates': admissionDates,
      'latitude': latitude,
      'longitude': longitude,
      'duration': duration,
    };
  }
}
