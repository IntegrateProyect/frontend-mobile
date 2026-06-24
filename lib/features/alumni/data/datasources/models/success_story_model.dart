import '../../../domain/entities/success_story_entity.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  SuccessStoryModel({
    required super.id,
    required super.alumniName,
    required super.title,
    required super.story,
    super.imageUrl,
    required super.createdAt,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] ?? '',
      alumniName: json['alumniName'] ?? '',
      title: json['title'] ?? '',
      story: json['story'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumniName': alumniName,
      'title': title,
      'story': story,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
