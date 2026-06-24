
import '../../../domain/entities/vocational_result_entity.dart';

class VocationalResultModel extends VocationalResultEntity {
  VocationalResultModel({
    required super.id,
    required super.date,
    required super.topCareer,
    required super.scores,
  });

  factory VocationalResultModel.fromJson(Map<String, dynamic> json) {
    return VocationalResultModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      topCareer: json['topCareer'] ?? '',
      scores: Map<String, double>.from(json['scores'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'topCareer': topCareer,
      'scores': scores,
    };
  }
}
