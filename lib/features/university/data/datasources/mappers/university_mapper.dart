import '../../../domain/entities/university_profile_entity.dart';
import '../../../domain/entities/university_career_entity.dart';
import '../models/university_profile_model.dart';
import '../models/university_career_model.dart';

class UniversityMapper {
  static UniversityProfileEntity toProfileEntity(UniversityProfileModel model) {
    return UniversityProfileEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      location: model.location,
      logoUrl: model.logoUrl,
      website: model.website,
    );
  }

  static UniversityCareerEntity toCareerEntity(UniversityCareerModel model) {
    return UniversityCareerEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      duration: model.duration,
      cost: model.cost,
    );
  }

  static UniversityCareerModel fromCareerEntity(UniversityCareerEntity entity) {
    return UniversityCareerModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      duration: entity.duration,
      cost: entity.cost,
    );
  }
}
