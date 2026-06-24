class UniversityProfileEntity {
  final String id;
  final String name;
  final String description;
  final String location;
  final String? logoUrl;
  final String? website;

  UniversityProfileEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.logoUrl,
    this.website,
  });
}
