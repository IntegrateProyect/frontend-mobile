
import '../../../domain/entities/onboarding_entity.dart';
import '../models/onboarding_model.dart';

class OnboardingMapper {
  static OnboardingEntity toEntity(OnboardingModel model) {
    return OnboardingEntity(
      title: model.title,
      description: model.description,
      image: model.image,
    );
  }

  static OnboardingModel toModel(OnboardingEntity entity) {
    return OnboardingModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
    );
  }
}
