import '../../../domain/entities/alumni_profile_entity.dart';

class AlumniProfileModel extends AlumniProfileEntity {
  AlumniProfileModel({
    required super.name,
    required super.email,
    required super.graduationYear,
    required super.degree,
    required super.company,
  });

  factory AlumniProfileModel.fromJson(Map<String, dynamic> json) {
    return AlumniProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      graduationYear: json['graduationYear'] is int
          ? json['graduationYear']
          : int.tryParse(json['graduationYear']?.toString() ?? '0') ?? 0,
      degree: json['degree'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'graduationYear': graduationYear,
      'degree': degree,
      'company': company,
    };
  }
}
