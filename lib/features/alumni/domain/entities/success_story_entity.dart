class SuccessStoryEntity {
  final String id;
  final String alumniName;
  final String title;
  final String story;
  final String? imageUrl;
  final DateTime createdAt;

  SuccessStoryEntity({
    required this.id,
    required this.alumniName,
    required this.title,
    required this.story,
    this.imageUrl,
    required this.createdAt,
  });
}
