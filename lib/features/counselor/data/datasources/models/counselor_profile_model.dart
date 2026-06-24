import '../../../domain/entities/counselor_profile_entity.dart';

class CounselorProfileModel extends CounselorProfileEntity {
  CounselorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.institution,
    super.profileImageUrl,
  });

  factory CounselorProfileModel.fromJson(Map<String, dynamic> json) {
    return CounselorProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      institution: json['institution'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'institution': institution,
      'profileImageUrl': profileImageUrl,
    };
  }
}
