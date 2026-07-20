import '../../domain/entities/university_alumni_entity.dart';

class UniversityAlumniModel extends UniversityAlumniEntity {
  UniversityAlumniModel({
    required super.id,
    required super.name,
    required super.email,
    required super.careerId,
    super.careerName,
    required super.graduationYear,
    required super.currentJob,
    required super.company,
    super.experienceSummary,
    super.linkedinUrl,
  });

  factory UniversityAlumniModel.fromJson(Map<String, dynamic> json) {
    return UniversityAlumniModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      careerId: json['careerId']?.toString() ?? '',
      careerName: json['careerName']?.toString(),
      graduationYear: (json['graduationYear'] as num?)?.toInt() ?? 0,
      currentJob: json['currentJob']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      experienceSummary: json['experienceSummary']?.toString(),
      linkedinUrl: json['linkedinUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'careerId': careerId,
      'graduationYear': graduationYear,
      'currentJob': currentJob,
      'company': company,
      'experienceSummary': experienceSummary,
      'linkedinUrl': linkedinUrl,
    };
  }
}
