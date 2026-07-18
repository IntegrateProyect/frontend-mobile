import '../../../domain/entities/success_story_entity.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  SuccessStoryModel({
    required super.id,
    required super.alumniName,
    required super.career,
    required super.graduationYear,
    required super.story,
    required super.createdAt,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] ?? '',
      alumniName: json['alumniName'] ?? '',
      career: json['career'] ?? '',
      graduationYear: json['graduationYear'] is int
          ? json['graduationYear']
          : int.tryParse(json['graduationYear']?.toString() ?? '0') ?? 0,
      story: json['story'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumniName': alumniName,
      'career': career,
      'graduationYear': graduationYear,
      'story': story,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
