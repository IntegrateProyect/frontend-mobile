import 'package:flutter/material.dart';
import '../../domain/entities/student_counselor_entity.dart';
import '../../domain/usecases/get_student_groups_usecase.dart';
import '../../domain/usecases/get_student_counselor_usecase.dart';
import '../../domain/usecases/join_group_usecase.dart';

class StudentGroupProvider extends ChangeNotifier {
  final GetStudentGroupsUseCase _getGroupsUseCase;
  final GetStudentCounselorUseCase _getCounselorUseCase;
  final JoinGroupUseCase _joinGroupUseCase;

  StudentGroupProvider({
    required GetStudentGroupsUseCase getGroupsUseCase,
    required GetStudentCounselorUseCase getCounselorUseCase,
    required JoinGroupUseCase joinGroupUseCase,
  })  : _getGroupsUseCase = getGroupsUseCase,
        _getCounselorUseCase = getCounselorUseCase,
        _joinGroupUseCase = joinGroupUseCase;

  List<dynamic> _studentGroups = [];
  StudentCounselorEntity? _counselor;
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get studentGroups => List.unmodifiable(_studentGroups);
  StudentCounselorEntity? get counselor => _counselor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasGroup => _studentGroups.isNotEmpty;

  bool get hasCounselor {
    final counselorName = _counselor?.name.trim() ?? '';
    return counselorName.isNotEmpty &&
        counselorName.toLowerCase() != 'por asignar' &&
        counselorName.toLowerCase() != 'null';
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) return null;
    final firstGroup = _studentGroups.first;
    if (firstGroup is Map<String, dynamic>) return firstGroup;
    if (firstGroup is Map) return Map<String, dynamic>.from(firstGroup);
    return null;
  }

  String get currentGroupName {
    final group = currentGroup;
    if (group != null) {
      final possibleNames = [
        group['name'],
        group['groupName'],
        group['group_name'],
        group['nombre'],
      ];
      for (final value in possibleNames) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }
    return 'Sin grupo asignado';
  }

  String get currentGroupCode {
    final group = currentGroup;
    if (group != null) {
      final possibleCodes = [
        group['accessCode'],
        group['access_code'],
        group['code'],
        group['groupCode'],
      ];
      for (final value in possibleCodes) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }
    return 'Sin código';
  }

  String? get currentCounselorName {
    final endpointName = _cleanOptionalValue(_counselor?.name);
    if (endpointName != null && endpointName.toLowerCase() != 'por asignar') {
      return endpointName;
    }
    return _getCounselorNameFromGroup();
  }

  Future<void> loadGroupData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _studentGroups = await _getGroupsUseCase();
      if (hasGroup) {
        _counselor = await _getCounselorUseCase();
      } else {
        _counselor = null;
      }
    } catch (e) {
      _errorMessage = 'Error al cargar datos del grupo';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroupByCode(String accessCode) async {
    final cleanCode = accessCode.trim();
    if (cleanCode.isEmpty) {
      _errorMessage = 'Escribe el código del grupo.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _joinGroupUseCase(cleanCode);
      await loadGroupData();
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _getCounselorNameFromGroup() {
    final group = currentGroup;
    if (group == null) return null;
    final counselorData = group['counselor'];
    if (counselorData is Map) {
      final possibleNames = [
        counselorData['name'],
        counselorData['fullName'],
        counselorData['nombre'],
      ];
      for (final value in possibleNames) {
        final text = _cleanOptionalValue(value);
        if (text != null) return text;
      }
    }
    return null;
  }

  String? _cleanOptionalValue(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text.toLowerCase() == 'null' ? null : text;
  }
}
