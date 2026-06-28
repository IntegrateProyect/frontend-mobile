class StudentProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  final String? groupName;
  final String? groupCode;

  final List<String> subjectsLiked;
  final List<String> subjectsDisliked;
  final List<String> interests;
  final List<String> skills;

  final bool needsScholarship;
  final bool studyAbroad;
  final int vocationalClarity;

  StudentProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.groupName,
    this.groupCode,
    this.subjectsLiked = const [],
    this.subjectsDisliked = const [],
    this.interests = const [],
    this.skills = const [],
    this.needsScholarship = false,
    this.studyAbroad = false,
    this.vocationalClarity = 1,
  });

  StudentProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? groupName,
    String? groupCode,
    List<String>? subjectsLiked,
    List<String>? subjectsDisliked,
    List<String>? interests,
    List<String>? skills,
    bool? needsScholarship,
    bool? studyAbroad,
    int? vocationalClarity,
  }) {
    return StudentProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      groupName: groupName ?? this.groupName,
      groupCode: groupCode ?? this.groupCode,
      subjectsLiked: subjectsLiked ?? this.subjectsLiked,
      subjectsDisliked: subjectsDisliked ?? this.subjectsDisliked,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      needsScholarship: needsScholarship ?? this.needsScholarship,
      studyAbroad: studyAbroad ?? this.studyAbroad,
      vocationalClarity: vocationalClarity ?? this.vocationalClarity,
    );
  }
}