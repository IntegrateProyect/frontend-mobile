class ScholarshipEntity {
  final String id;
  final String title;
  final String provider;
  final String description;
  final double? amount;

  const ScholarshipEntity({
    required this.id,
    required this.title,
    required this.provider,
    required this.description,
    this.amount,
  });
}
