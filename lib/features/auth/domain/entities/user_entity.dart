class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl; // Keeping for backward compatibility
  final String? avatarUrl; // New field from API
  final String? role;
  final String? verificationStatus;
  final String? universityName;
  final bool isPremium;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.avatarUrl,
    this.role,
    this.verificationStatus,
    this.universityName,
    this.isPremium = false,
  });

  // Helper to get the best available image URL
  String? get effectivePhotoUrl => avatarUrl ?? photoUrl;
}
