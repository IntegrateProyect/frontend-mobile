import '../../../domain/entities/recommendation_entity.dart';

class RecommendationItemModel extends RecommendationItemEntity {
  const RecommendationItemModel({
    required super.careerId,
    required super.careerName,
    required super.score,
    super.universityName,
    super.clusterId,
  });

  factory RecommendationItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RecommendationItemModel(
      careerId: (json['careerId'] ?? '').toString(),
      careerName: (json['careerName'] ?? '').toString(),
      score: _toDouble(json['score']),
      universityName: _optionalString(
        json['universityName'],
      ),
      clusterId: _toNullableInt(json['clusterId']),
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

class RecommendationResponseModel
    extends RecommendationResponseEntity {
  const RecommendationResponseModel({
    required super.studentId,
    required super.recommendations,
    required super.generatedAt,
    required super.mode,
    required super.diversified,
  });

  factory RecommendationResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic rawRecommendations =
    json['recommendations'];

    final recommendations =
    rawRecommendations is List
        ? rawRecommendations
        .whereType<Map>()
        .map(
          (item) =>
          RecommendationItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
    )
        .toList()
        : <RecommendationItemModel>[];

    return RecommendationResponseModel(
      studentId: (json['studentId'] ?? '').toString(),
      recommendations: recommendations,
      generatedAt: DateTime.tryParse(
        (json['generatedAt'] ?? '').toString(),
      ),
      mode: (json['mode'] ?? 'ranking_normal')
          .toString(),
      diversified: _toBool(json['diversified']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    return value?.toString().toLowerCase() == 'true';
  }
}