class UniversityEventEntity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? careerId;
  final String? imageUrl;
  final String? universityName;

  UniversityEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.careerId,
    this.imageUrl,
    this.universityName,
  });
}
