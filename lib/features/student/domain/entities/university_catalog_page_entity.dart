import 'university_entity.dart';

class UniversityCatalogPageEntity {
  final List<UniversityEntity> universities;

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const UniversityCatalogPageEntity({
    required this.universities,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasMorePages {
    return page < totalPages;
  }
}