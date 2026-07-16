
import '../../../domain/entities/university_catalog_page_entity.dart';
import 'university_model.dart';

class UniversityCatalogPageModel extends UniversityCatalogPageEntity {
  const UniversityCatalogPageModel({
    required super.universities,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory UniversityCatalogPageModel.fromJson(Map<String, dynamic> json) {
    final rawUniversities = json['data'];
    final universities = rawUniversities is List
        ? rawUniversities
            .whereType<Map>()
            .map((item) => UniversityModel.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : <UniversityModel>[];

    final pagination = json['pagination'] ?? {};

    return UniversityCatalogPageModel(
      universities: universities,
      total: pagination['total'] ?? 0,
      page: pagination['page'] ?? 1,
      limit: pagination['limit'] ?? 20,
      totalPages: pagination['totalPages'] ?? 1,
    );
  }
}
