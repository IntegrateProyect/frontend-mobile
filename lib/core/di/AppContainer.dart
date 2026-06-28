import '../api/API.dart';
import '../api/IApi.dart';
import '../utils/StorageService.dart';
import '../utils/UserService.dart';
import '../../features/auth/data/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class AppContainer {
  static final AppContainer _instance = AppContainer._internal();
  factory AppContainer() => _instance;
  AppContainer._internal();

  // Core Services
  static final IApi _api = API();
  static final StorageService _storage = StorageService();
  static final UserService _userService = UserService(_storage);

  // Data Sources
  static final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl(
    api: _api,
    userService: _userService,
  );

  // Repositories
  static final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(
    remoteDataSource: _authRemoteDataSource,
  );

  // Getters
  IApi get api => _api;
  UserService get userService => _userService;
  AuthRepositoryImpl get authRepository => _authRepository;
}
