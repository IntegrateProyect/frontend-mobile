import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingEntity> getOnboardingData() {
    return [
      OnboardingEntity(
        title: 'Chatbot Vocacional',
        description:
        'Resuelve tus dudas sobre carreras, becas y universidades con ayuda inmediata y personalizada.',
        image: 'assets/images/onboarding1.png',
      ),
      OnboardingEntity(
        title: 'Carreras y Universidades',
        description:
        'Recibe recomendaciones según tus intereses y descubre opciones que sí van contigo.',
        image: 'assets/images/onboarding2.png',
      ),
      OnboardingEntity(
        title: 'Acompañamiento del Orientador',
        description:
        'No estás solo: recibe apoyo y seguimiento durante todo tu proceso vocacional.',
        image: 'assets/images/onboarding3.png',
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return false;
  }

  @override
  Future<void> setOnboardingCompleted() async {}
}