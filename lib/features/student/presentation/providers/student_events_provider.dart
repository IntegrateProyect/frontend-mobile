import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events_usecase.dart';

class StudentEventsProvider extends ChangeNotifier {
  final GetEventsUseCase _getEventsUseCase;

  StudentEventsProvider({
    required GetEventsUseCase getEventsUseCase,
  }) : _getEventsUseCase = getEventsUseCase;

  List<EventEntity> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  List<EventEntity> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      _events = await _getEventsUseCase();
    } catch (e) {
      _errorMessage = 'Error al cargar eventos';
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }
}
