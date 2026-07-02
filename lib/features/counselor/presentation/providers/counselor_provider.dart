import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/entities/student_file_entity.dart';
import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/create_group_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/usecases/get_group_details_usecase.dart';
import '../../domain/usecases/register_session_usecase.dart';
import '../../domain/usecases/assign_task_usecase.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/get_counselor_profile_usecase.dart';
import '../../domain/usecases/get_counselor_stats_usecase.dart';
import '../../domain/usecases/get_counselor_students_usecase.dart';
import '../../domain/usecases/get_student_file_usecase.dart';

class CounselorProvider extends ChangeNotifier {
  final GetGroupsUseCase _getGroupsUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final GetGroupDetailsUseCase _getGroupDetailsUseCase;
  final RegisterSessionUseCase _registerSessionUseCase;
  final AssignTaskUseCase _assignTaskUseCase;
  final GetConsultationsUseCase _getConsultationsUseCase;
  final GetCounselorProfileUseCase _getCounselorProfileUseCase;
  final GetCounselorStatsUseCase _getCounselStatsUseCase;
  final GetCounselorStudentsUseCase _getStudentsUseCase;
  final GetStudentFileUseCase _getStudentFileUseCase;

  CounselorProfileEntity? _profile;
  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  Map<String, dynamic> _stats = {};

  // Student File State
  StudentFileEntity? _currentStudentFile;
  bool _isLoadingFile = false;

  bool _isLoading = false;
  String? _errorMessage;

  CounselorProvider({
    required GetGroupsUseCase getGroupsUseCase,
    required CreateGroupUseCase createGroupUseCase,
    required UpdateGroupUseCase updateGroupUseCase,
    required GetGroupDetailsUseCase getGroupDetailsUseCase,
    required RegisterSessionUseCase registerSessionUseCase,
    required AssignTaskUseCase assignTaskUseCase,
    required GetConsultationsUseCase getConsultationsUseCase,
    required GetCounselorProfileUseCase getCounselorProfileUseCase,
    required GetCounselorStatsUseCase getCounselorStatsUseCase,
    required GetCounselorStudentsUseCase getStudentsUseCase,
    required GetStudentFileUseCase getStudentFileUseCase,
  })  : _getGroupsUseCase = getGroupsUseCase,
        _createGroupUseCase = createGroupUseCase,
        _updateGroupUseCase = updateGroupUseCase,
        _getGroupDetailsUseCase = getGroupDetailsUseCase,
        _registerSessionUseCase = registerSessionUseCase,
        _assignTaskUseCase = assignTaskUseCase,
        _getConsultationsUseCase = getConsultationsUseCase,
        _getCounselorProfileUseCase = getCounselorProfileUseCase,
        _getCounselStatsUseCase = getCounselorStatsUseCase,
        _getStudentsUseCase = getStudentsUseCase,
        _getStudentFileUseCase = getStudentFileUseCase;

  CounselorProfileEntity? get profile => _profile;
  List<dynamic> get groups => _groups;
  List<StudentProfileEntity> get students => _students;
  List<StudentConsultationEntity> get consultations => _consultations;
  StudentFileEntity? get currentStudentFile => _currentStudentFile;
  bool get isLoading => _isLoading;
  bool get isLoadingFile => _isLoadingFile;
  String? get errorMessage => _errorMessage;

  // Getters para las tarjetas de la imagen
  int get totalStudentsCount => (_stats['totalStudents'] ?? 0) as int;
  int get activeStudentsCount => (_stats['activeStudents'] ?? 0) as int;
  int get lowProgressCount => (_stats['lowProgress'] ?? 0) as int;
  int get highIndecisionCount => (_stats['highIndecision'] ?? 0) as int;
  
  // Getters para la barra mini
  int get solicitudesCount => (_stats['requests'] ?? 0) as int;
  int get groupsCount => _groups.length;
  int get reportesCount => (_stats['reports'] ?? 0) as int;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final results = await Future.wait([
        _getGroupsUseCase().catchError((e) => []),
        _getConsultationsUseCase().catchError((e) => []),
        _getCounselorProfileUseCase().catchError((e) => null),
        _getCounselStatsUseCase().catchError((e) => {}),
        _getStudentsUseCase().catchError((e) => []),
      ]);
      
      _groups = results[0] as List<dynamic>;
      _consultations = results[1] as List<StudentConsultationEntity>;
      _profile = results[2] as CounselorProfileEntity?;
      _stats = results[3] as Map<String, dynamic>;
      _students = results[4] as List<StudentProfileEntity>;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStudentFile(String studentId) async {
    _isLoadingFile = true;
    _errorMessage = null;
    _currentStudentFile = null;
    notifyListeners();

    try {
      _currentStudentFile = await _getStudentFileUseCase(studentId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingFile = false;
      notifyListeners();
    }
  }

  Future<bool> createGroup(String name, String accessCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _createGroupUseCase(name, accessCode);
      await loadDashboardData();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getGroupDetails(String groupId) async {
    try {
      return await _getGroupDetailsUseCase(groupId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    }
  }

  Future<bool> updateGroup(String groupId, {String? name, String? accessCode}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _updateGroupUseCase(groupId, name: name, accessCode: accessCode);
      await loadDashboardData();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
