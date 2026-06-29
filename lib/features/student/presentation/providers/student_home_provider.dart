import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';
import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';

class StudentHomeProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final GetVocationalResultsUseCase _getResultsUseCase;
  final GetAvailableGamesUseCase _getGamesUseCase;
  final UserService _userService;
  final IApi _api;

  StudentHomeProvider({
    required GetStudentProfileUseCase getProfileUseCase,
    required GetVocationalResultsUseCase getResultsUseCase,
    required GetAvailableGamesUseCase getGamesUseCase,
    required UserService userService,
    required IApi api,
  })  : _getProfileUseCase = getProfileUseCase,
        _getResultsUseCase = getResultsUseCase,
        _getGamesUseCase = getGamesUseCase,
        _userService = userService,
        _api = api;

  StudentProfileEntity? _profile;
  List<VocationalResultEntity> _results = [];
  List<dynamic> _availableGames = [];
  List<dynamic> _studentGroups = [];

  bool _isLoading = false;
  String? _errorMessage;

  StudentProfileEntity? get profile => _profile;
  List<VocationalResultEntity> get results => _results;
  List<dynamic> get availableGames => _availableGames;
  List<dynamic> get studentGroups => _studentGroups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasGroup => _studentGroups.isNotEmpty;

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) return null;
    final raw = _studentGroups.first;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  String get currentGroupName {
    final group = currentGroup;
    return group?['name']?.toString() ??
        group?['groupName']?.toString() ??
        'Grupo asignado';
  }

  String get currentGroupCode {
    final group = currentGroup;
    return group?['accessCode']?.toString() ??
        group?['access_code']?.toString() ??
        group?['code']?.toString() ??
        'Sin código';
  }

  String get firstName {
    final name = _profile?.name.trim();

    if (name != null && name.isNotEmpty) {
      return name.split(' ').first;
    }

    return 'Estudiante';
  }

  String get groupDescription {
    if (!hasGroup) {
      return 'Aún no perteneces a un grupo. Ingresa el código que te dio tu orientador.';
    }

    return 'Grupo: $currentGroupName\nCódigo: $currentGroupCode';
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final remoteProfile = await _safeLoadProfile();
      if (remoteProfile != null) {
        _profile = remoteProfile;
      }

      final groups = await _safeLoadStudentGroups();
      _studentGroups = groups ?? [];

      final results = await _safeLoadResults();
      if (results != null) {
        _results = results;
      }

      final games = await _safeLoadGames();
      if (games != null) {
        _availableGames = games;
      }
    } catch (e) {
      debugPrint('XXX Error StudentHomeProvider: $e');
      _errorMessage = 'No se pudo cargar la información del alumno.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroupByCode(String accessCode) async {
    final code = accessCode.trim();

    if (code.isEmpty) {
      _errorMessage = 'Ingresa el código del grupo';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No hay sesión activa');
      }

      await _api.joinGroup(token, code);

      _studentGroups = await _api.getStudentGroups(token);

      return true;
    } catch (e) {
      final message = e.toString();

      if (message.contains('Ya eres miembro')) {
        final token = await _userService.getToken();

        if (token != null && token.isNotEmpty) {
          _studentGroups = await _api.getStudentGroups(token);
        }

        return true;
      }

      debugPrint('XXX ERROR JOIN GROUP: $e');
      _errorMessage = message.replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final localUser = await _userService.getUser();

      if (localUser != null && _profile == null) {
        _profile = StudentProfileEntity(
          id: localUser.id,
          name: localUser.name ?? 'Estudiante',
          email: localUser.email,
        );
      }
    } catch (e) {
      debugPrint('XXX Usuario local no cargado: $e');
    }
  }

  Future<StudentProfileEntity?> _safeLoadProfile() async {
    try {
      return await _getProfileUseCase.call();
    } catch (e) {
      debugPrint('XXX Perfil remoto no cargado: $e');
      return null;
    }
  }

  Future<List<dynamic>?> _safeLoadStudentGroups() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        return [];
      }

      return await _api.getStudentGroups(token);
    } catch (e) {
      debugPrint('XXX Grupos del alumno no cargados: $e');
      return [];
    }
  }

  Future<List<VocationalResultEntity>?> _safeLoadResults() async {
    try {
      return await _getResultsUseCase.call();
    } catch (e) {
      debugPrint('XXX Resultados no cargados: $e');
      return null;
    }
  }

  Future<List<dynamic>?> _safeLoadGames() async {
    try {
      return await _getGamesUseCase.call();
    } catch (e) {
      debugPrint('XXX Juegos no cargados: $e');
      return null;
    }
  }
}