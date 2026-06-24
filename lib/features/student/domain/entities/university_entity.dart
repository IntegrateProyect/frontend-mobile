class UniversityEntity {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final List<String> availableCareers;

  UniversityEntity({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    required this.availableCareers,
  });
}
