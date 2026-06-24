class AlumniEntity {
  final String id;
  final String name;
  final String career;
  final String university;
  final String currentJob;
  final String? profileImageUrl;

  AlumniEntity({
    required this.id,
    required this.name,
    required this.career,
    required this.university,
    required this.currentJob,
    this.profileImageUrl,
  });
}
