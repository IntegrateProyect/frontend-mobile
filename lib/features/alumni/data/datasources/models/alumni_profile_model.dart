import '../../../domain/entities/alumni_profile_entity.dart';

class AlumniProfileModel extends AlumniProfileEntity {
  AlumniProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.career,
    required super.university,
    required super.currentJob,
    super.bio,
    super.profileImageUrl,
  });

  factory AlumniProfileModel.fromJson(Map<String, dynamic> json) {
    return AlumniProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      career: json['career'] ?? '',
      university: json['university'] ?? '',
      currentJob: json['currentJob'] ?? '',
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'career': career,
      'university': university,
      'currentJob': currentJob,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
}
