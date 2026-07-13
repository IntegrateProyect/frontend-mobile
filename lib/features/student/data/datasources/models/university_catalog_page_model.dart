import '../../../domain/entities/university_catalog_page_entity.dart';
import 'university_model.dart';

class UniversityCatalogPageModel
    extends UniversityCatalogPageEntity {
  const UniversityCatalogPageModel({
    required super.universities,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory UniversityCatalogPageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawUniversities = json['data'];

    final universities =
    rawUniversities is List
        ? rawUniversities
        .whereType<Map>()
        .map(
          (item) =>
          UniversityModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
    )
        .toList()
        : <UniversityModel>[];

    final pagination =
    _asMap(json['pagination']);

    return UniversityCatalogPageModel(
      universities: universities,
      total: _toInt(
        pagination['total'],
      ),
      page: _toInt(
        pagination['page'],
        fallback: 1,
      ),
      limit: _toInt(
        pagination['limit'],
        fallback: 20,
      ),
      totalPages: _toInt(
        pagination['totalPages'],
        fallback: 1,
      ),
    );
  }

  static Map<String, dynamic> _asMap(
      dynamic value,
      ) {
    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return {};
  }

  static int _toInt(
      dynamic value, {
        int fallback = 0,
      }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        fallback;
  }
}