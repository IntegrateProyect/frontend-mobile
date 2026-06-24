import 'package:flutter/material.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/usecases/get_admin_stats_usecase.dart';
import '../../domain/usecases/manage_users_usecase.dart';

class AdminProvider extends ChangeNotifier {
  final GetAdminStatsUseCase _getStatsUseCase;
  final ManageUsersUseCase _manageUsersUseCase;

  AdminStatsEntity? _stats;
  List<AppUserEntity> _users = [];
  bool _isLoading = false;

  AdminProvider({
    required GetAdminStatsUseCase getStatsUseCase,
    required ManageUsersUseCase manageUsersUseCase,
  })  : _getStatsUseCase = getStatsUseCase,
        _manageUsersUseCase = manageUsersUseCase;

  AdminStatsEntity? get stats => _stats;
  List<AppUserEntity> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stats = await _getStatsUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _manageUsersUseCase.getUsers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
