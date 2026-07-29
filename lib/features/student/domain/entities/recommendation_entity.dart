class RecommendationItemEntity {
  final String careerId;
  final String careerName;
  final double score;
  final String? universityName;
  final int? clusterId;

  const RecommendationItemEntity({
    required this.careerId,
    required this.careerName,
    required this.score,
    this.universityName,
    this.clusterId,
  });

  int get percentage {
    return (score.clamp(0.0, 1.0) * 100).round();
  }
}

class RecommendationResponseEntity {
  final String studentId;
  final List<RecommendationItemEntity> recommendations;
  final DateTime? generatedAt;
  final String mode;
  final bool diversified;

  const RecommendationResponseEntity({
    required this.studentId,
    required this.recommendations,
    required this.generatedAt,
    required this.mode,
    required this.diversified,
  });

  bool get isEmpty => recommendations.isEmpty;
  bool get isNotEmpty => recommendations.isNotEmpty;
}