import '../../../domain/entities/vocational_result_entity.dart';

class VocationalResultModel extends VocationalResultEntity {
  VocationalResultModel({
    required super.id,
    required super.date,
    required super.topCareer,
    required super.scores,
  });

  factory VocationalResultModel.fromJson(Map<String, dynamic> json) {
    // Manejo robusto de los puntajes para asegurar que sean double
    final Map<String, dynamic> rawScores = json['scores'] ?? {};
    final Map<String, double> processedScores = rawScores.map(
      (key, value) => MapEntry(key, (value is num) ? value.toDouble() : 0.0),
    );

    return VocationalResultModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      topCareer: json['topCareer'] ?? '',
      scores: processedScores,
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
