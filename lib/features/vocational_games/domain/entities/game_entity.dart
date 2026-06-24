class GameEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String type; // e.g., 'quiz', 'simulation', 'puzzle'

  GameEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
  });
}
