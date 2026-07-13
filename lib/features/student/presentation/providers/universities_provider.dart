import 'package:flutter/material.dart';

import '../../domain/entities/university_entity.dart';
import '../../domain/usecases/get_compatible_universities_usecase.dart';

class UniversitiesProvider
    extends ChangeNotifier {
  final GetCompatibleUniversitiesUseCase
  getCompatibleUniversitiesUseCase;

  UniversitiesProvider({
    required this
        .getCompatibleUniversitiesUseCase,
  });

  final List<UniversityEntity>
  _universities = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;

  String? _errorMessage;
  String _currentSearch = '';

  int _page = 1;
  int _limit = 20;
  int _total = 0;
  int _totalPages = 1;

  List<UniversityEntity> get universities {
    return List.unmodifiable(_universities);
  }

  bool get isLoading => _isLoading;

  bool get isLoadingMore =>
      _isLoadingMore;

  String? get errorMessage =>
      _errorMessage;

  String get currentSearch =>
      _currentSearch;

  int get total => _total;

  int get page => _page;

  int get totalPages => _totalPages;

  bool get hasMorePages {
    return _page < _totalPages;
  }

  Future<void> fetchUniversities({
    String search = '',
  }) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    _page = 1;
    _currentSearch = search.trim();

    notifyListeners();

    try {
      final response =
      await getCompatibleUniversitiesUseCase(
        page: 1,
        limit: _limit,
        search: _currentSearch,
      );

      _universities
        ..clear()
        ..addAll(response.universities);

      _page = response.page;
      _limit = response.limit;
      _total = response.total;
      _totalPages = response.totalPages;
    } catch (error) {
      debugPrint(
        'Error al cargar universidades: $error',
      );

      _universities.clear();

      _errorMessage = error
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading ||
        _isLoadingMore ||
        !hasMorePages) {
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final nextPage = _page + 1;

      final response =
      await getCompatibleUniversitiesUseCase(
        page: nextPage,
        limit: _limit,
        search: _currentSearch,
      );

      final currentIds = _universities
          .map((university) => university.id)
          .toSet();

      final newUniversities =
      response.universities.where(
            (university) {
          return !currentIds.contains(
            university.id,
          );
        },
      );

      _universities.addAll(
        newUniversities,
      );

      _page = response.page;
      _total = response.total;
      _totalPages = response.totalPages;
    } catch (error) {
      debugPrint(
        'Error al cargar más universidades: $error',
      );

      _errorMessage = error
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> searchUniversities(
      String search,
      ) {
    return fetchUniversities(
      search: search,
    );
  }

  Future<void> refreshUniversities() {
    return fetchUniversities(
      search: _currentSearch,
    );
  }
}