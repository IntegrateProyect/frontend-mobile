class UniversityAnnouncementEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? universityName;
  final String? imageUrl;

  UniversityAnnouncementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.universityName,
    this.imageUrl,
  });
}
