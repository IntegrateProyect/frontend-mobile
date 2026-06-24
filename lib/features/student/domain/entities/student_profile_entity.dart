class StudentProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImageUrl;

  StudentProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImageUrl,
  });
}
