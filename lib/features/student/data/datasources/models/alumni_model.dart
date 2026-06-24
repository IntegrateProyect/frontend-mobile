
import '../../../domain/entities/alumni_entity.dart';

class AlumniModel extends AlumniEntity {
  AlumniModel({
    required super.id,
    required super.name,
    required super.career,
    required super.university,
    required super.currentJob,
    super.profileImageUrl,
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    return AlumniModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      career: json['career'] ?? '',
      university: json['university'] ?? '',
      currentJob: json['currentJob'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'career': career,
      'university': university,
      'currentJob': currentJob,
      'profileImageUrl': profileImageUrl,
    };
  }
}
