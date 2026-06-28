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

  bool _isLoading = false;
  String? _errorMessage;

  String? _cachedGroupCode;

  StudentProfileEntity? get profile => _profile;
  List<VocationalResultEntity> get results => _results;
  List<dynamic> get availableGames => _availableGames;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasGroup {
    final groupName = _profile?.groupName?.trim();
    final groupCode = _profile?.groupCode?.trim() ?? _cachedGroupCode?.trim();

    return (groupName != null && groupName.isNotEmpty) ||
        (groupCode != null && groupCode.isNotEmpty);
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

    final groupName = _profile?.groupName?.trim();
    final groupCode = _profile?.groupCode?.trim() ?? _cachedGroupCode?.trim();

    if (groupName != null && groupName.isNotEmpty) {
      if (groupCode != null && groupCode.isNotEmpty) {
        return 'Grupo: $groupName\nCódigo: $groupCode';
      }
      return 'Grupo: $groupName';
    }

    return 'Código: $groupCode';
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

        if (_cachedGroupCode != null &&
            (_profile!.groupCode == null || _profile!.groupCode!.isEmpty)) {
          _profile = _profile!.copyWith(
            groupCode: _cachedGroupCode,
            groupName: _profile!.groupName ?? 'Grupo asignado',
          );
        }
      }

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
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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

      debugPrint('XXX UNIENDO AL GRUPO: $code');

      final response = await _api.joinGroup(token, code);

      debugPrint('XXX JOIN GROUP RESPONSE: $response');

      _cachedGroupCode = code;

      if (_profile != null) {
        _profile = _profile!.copyWith(
          groupCode: code,
          groupName: _profile!.groupName ?? 'Grupo asignado',
        );
      }

      await loadHomeData();

      return true;
    } catch (e) {
      final message = e.toString();

      if (message.contains('Ya eres miembro')) {
        debugPrint('XXX Ya eres miembro del grupo. Mostrando grupo localmente...');

        _cachedGroupCode = code;

        if (_profile != null) {
          _profile = _profile!.copyWith(
            groupCode: code,
            groupName: _profile!.groupName ?? 'Grupo asignado',
          );
        }

        await loadHomeData();

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
          groupCode: _cachedGroupCode,
          groupName: _cachedGroupCode != null ? 'Grupo asignado' : null,
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