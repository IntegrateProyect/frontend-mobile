import '../../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  AdminStatsModel({
    required super.totalStudents,
    required super.totalCounselors,
    required super.totalUniversities,
    required super.totalAlumni,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalStudents: json['totalStudents'] ?? 0,
      totalCounselors: json['totalCounselors'] ?? 0,
      totalUniversities: json['totalUniversities'] ?? 0,
      totalAlumni: json['totalAlumni'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStudents': totalStudents,
      'totalCounselors': totalCounselors,
      'totalUniversities': totalUniversities,
      'totalAlumni': totalAlumni,
    };
  }
}
