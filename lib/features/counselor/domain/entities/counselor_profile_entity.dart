class CounselorProfileEntity {
  final String id;
  final String name;
  final String email;
  final String institution;
  final String? profileImageUrl;

  CounselorProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.institution,
    this.profileImageUrl,
  });
}
