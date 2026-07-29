class CareerEntity {
  final String id;
  final String name;
  final String description;
  final List<String> fields;
  final double score;
  final String? universityName;
  final int? clusterId;

  const CareerEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.fields = const [],
    this.score = 0,
    this.universityName,
    this.clusterId,
  });

  int get compatibilityPercentage {
    return (score.clamp(0.0, 1.0) * 100).round();
  }
}