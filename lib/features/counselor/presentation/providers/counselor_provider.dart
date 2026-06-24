import 'package:flutter/material.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/respond_consultation_usecase.dart';

class CounselorProvider extends ChangeNotifier {
  final GetConsultationsUseCase _getConsultationsUseCase;
  final RespondConsultationUseCase _respondConsultationUseCase;

  List<StudentConsultationEntity> _consultations = [];
  bool _isLoading = false;

  CounselorProvider({
    required GetConsultationsUseCase getConsultationsUseCase,
    required RespondConsultationUseCase respondConsultationUseCase,
  })  : _getConsultationsUseCase = getConsultationsUseCase,
        _respondConsultationUseCase = respondConsultationUseCase;

  List<StudentConsultationEntity> get consultations => _consultations;
  bool get isLoading => _isLoading;

  Future<void> fetchConsultations() async {
    _isLoading = true;
    notifyListeners();
    try {
      _consultations = await _getConsultationsUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> respondToConsultation(String id, String response) async {
    await _respondConsultationUseCase(id, response);
    await fetchConsultations();
  }
}
