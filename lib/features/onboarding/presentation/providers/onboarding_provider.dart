import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/usecases/get_onboarding_data.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingData _getOnboardingData;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  List<OnboardingEntity> _items = [];
  int _currentIndex = 0;
  bool _isCompleted = false;

  OnboardingProvider({
    required GetOnboardingData getOnboardingData,
    required CompleteOnboardingUseCase completeOnboardingUseCase,
  })  : _getOnboardingData = getOnboardingData,
        _completeOnboardingUseCase = completeOnboardingUseCase;

  List<OnboardingEntity> get items {
    if (_items.isEmpty) {
      _items = _getOnboardingData();
    }
    return _items;
  }

  int get currentIndex => _currentIndex;

  bool get isCompleted => _isCompleted;

  bool get isLastPage => _currentIndex == items.length - 1;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _completeOnboardingUseCase();
    _isCompleted = true;
    notifyListeners();
  }
}