import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  List<OnboardingEntity> getOnboardingData();
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}
