class VocationalResultEntity {
  final String id;
  final String date;
  final String topCareer;
  final Map<String, double> scores;

  VocationalResultEntity({
    required this.id,
    required this.date,
    required this.topCareer,
    required this.scores,
  });
}
