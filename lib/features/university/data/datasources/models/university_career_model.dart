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
    double parsedCost = 0.0;
    final rawCost = json['cost'] ?? json['costApprox'];
    if (rawCost is num) {
      parsedCost = rawCost.toDouble();
    } else if (rawCost is String) {
      parsedCost = double.tryParse(rawCost) ?? 0.0;
    }

    double? parsedLat;
    final rawLat = json['latitude'];
    if (rawLat is num) {
      parsedLat = rawLat.toDouble();
    } else if (rawLat is String) {
      parsedLat = double.tryParse(rawLat);
    }

    double? parsedLng;
    final rawLng = json['longitude'];
    if (rawLng is num) {
      parsedLng = rawLng.toDouble();
    } else if (rawLng is String) {
      parsedLng = double.tryParse(rawLng);
    }

    return UniversityCareerModel(
      id: (json['id'] ?? json['careerId'] ?? '').toString(),
      name: (json['name'] ?? json['careerName'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      cost: parsedCost,
      location: json['location']?.toString(),
      modality: json['modality']?.toString(),
      scholarshipAvailable: json['scholarshipAvailable'] == true ||
          json['scholarship_available'] == true ||
          json['scholarshipAvailable']?.toString() == 'true',
      admissionDates: (json['admissionDates'] ?? json['admission_dates'])?.toString(),
      latitude: parsedLat,
      longitude: parsedLng,
      duration: json['duration']?.toString(),
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
