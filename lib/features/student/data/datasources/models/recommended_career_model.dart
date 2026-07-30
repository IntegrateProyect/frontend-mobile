import '../../../domain/entities/career_entity.dart';

class RecommendedCareerModel extends CareerEntity {
  const RecommendedCareerModel({
    required super.id,
    required super.name,
    required super.score,
    super.universityName,
    super.clusterId,
    super.description,
    super.fields,
  });

  factory RecommendedCareerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final universityName = _optionalString(
      json['universityName'] ??
          json['university_name'] ??
          json['university'],
    );

    return RecommendedCareerModel(
      id: (json['careerId'] ??
          json['career_id'] ??
          json['id'] ??
          '')
          .toString(),
      name: (json['careerName'] ??
          json['career_name'] ??
          json['name'] ??
          '')
          .toString(),
      description:
      _optionalString(json['description']) ?? '',
      fields: _toStringList(json['fields']),
      score: _normalizeScore(
        json['compatibilityScore'] ??
            json['compatibility_score'] ??
            json['score'] ??
            json['similarityScore'] ??
            json['similarity_score'],
      ),
      universityName: universityName,
      clusterId: _toNullableInt(
        json['clusterId'] ?? json['cluster_id'],
      ),
    );
  }

  static double _normalizeScore(dynamic value) {
    final raw = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;

    if (raw > 1 && raw <= 100) {
      return (raw / 100)
          .clamp(0.0, 1.0)
          .toDouble();
    }

    return raw.clamp(0.0, 1.0).toDouble();
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _optionalString(dynamic value) {
    final text = value?.toString().trim() ?? '';

    if (text.isEmpty ||
        text.toLowerCase() == 'null' ||
        text.toLowerCase() == 'undefined') {
      return null;
    }

    return text;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
