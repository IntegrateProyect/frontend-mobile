class UniversityCareerEntity {
  final String id;
  final String name;
  final String description;
  final double cost;
  final String? location;
  final String? modality;
  final bool? scholarshipAvailable;
  final String? admissionDates;
  final double? latitude;
  final double? longitude;
  final String? duration;

  UniversityCareerEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    this.location,
    this.modality,
    this.scholarshipAvailable,
    this.admissionDates,
    this.latitude,
    this.longitude,
    this.duration,
  });
}
