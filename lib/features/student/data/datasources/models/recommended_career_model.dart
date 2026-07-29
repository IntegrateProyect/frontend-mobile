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
          json['university_name'],
    );

    return RecommendedCareerModel(
      id: (
          json['careerId'] ??
              json['career_id'] ??
              json['id'] ??
              ''
      ).toString(),
      name: (
          json['careerName'] ??
              json['career_name'] ??
              json['name'] ??
              ''
      ).toString(),
      description: universityName == null
          ? ''
          : 'Universidad: $universityName',
      fields: const [],
      score: _toDouble(json['score']),
      universityName: universityName,
      clusterId: _toNullableInt(
        json['clusterId'] ??
            json['cluster_id'],
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

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
}