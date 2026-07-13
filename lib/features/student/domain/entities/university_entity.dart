class UniversityEntity {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final List<String> availableCareers;

  final String? representativeUserId;
  final bool isRegistered;

  const UniversityEntity({
    required this.id,
    required this.name,
    this.location = 'Catálogo nacional RENOES',
    this.logoUrl,
    this.availableCareers = const [],
    this.representativeUserId,
    this.isRegistered = false,
  });
}