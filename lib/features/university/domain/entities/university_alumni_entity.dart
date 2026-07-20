class UniversityAlumniEntity {
  final String id;
  final String name;
  final String email;
  final String careerId;
  final String? careerName;
  final int graduationYear;
  final String currentJob;
  final String company;
  final String? experienceSummary;
  final String? linkedinUrl;

  UniversityAlumniEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.careerId,
    this.careerName,
    required this.graduationYear,
    required this.currentJob,
    required this.company,
    this.experienceSummary,
    this.linkedinUrl,
  });
}
