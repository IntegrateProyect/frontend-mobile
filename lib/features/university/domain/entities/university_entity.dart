class UniversityEntity {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;

  final List<String> availableCareers;
  final List<UniversityCareerEntity> careers;

  final String? representativeUserId;
  final bool isRegistered;
  final double? latitude;
  final double? longitude;
  final String? duration;

  const UniversityEntity({
    required this.id,
    required this.name,
    this.location = 'Catálogo nacional RENOES',
    this.logoUrl,
    this.availableCareers = const [],
    this.careers = const [],
    this.representativeUserId,
    this.isRegistered = false,
    this.latitude,
    this.longitude,
    this.duration,
  });
}

class UniversityCareerEntity {
  final String careerId;
  final String name;
  final String description;
  final String location;
  final String modality;
  final double? costApprox;
  final bool scholarshipAvailable;
  final String admissionDates;
  final double? latitude;
  final double? longitude;
  final String duration;

  const UniversityCareerEntity({
    required this.careerId,
    required this.name,
    this.description = '',
    this.location = '',
    this.modality = '',
    this.costApprox,
    this.scholarshipAvailable = false,
    this.admissionDates = '',
    this.latitude,
    this.longitude,
    this.duration = '',
  });
}