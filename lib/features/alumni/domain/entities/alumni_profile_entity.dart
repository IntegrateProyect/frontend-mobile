class AlumniProfileEntity {
  final String id;
  final String name;
  final String email;
  final String career;
  final String university;
  final String currentJob;
  final String? bio;
  final String? profileImageUrl;

  AlumniProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.career,
    required this.university,
    required this.currentJob,
    this.bio,
    this.profileImageUrl,
  });
}
