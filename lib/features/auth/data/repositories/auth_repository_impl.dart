import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mappers/auth_mapper.dart';
import '../remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return AuthMapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Map<String, dynamic>? additionalData,
  }) async {
    final userModel = await remoteDataSource.register(
      email,
      password,
      name,
      role,
      privacyAccepted: privacyAccepted,
      additionalData: additionalData,
    );
    return AuthMapper.toEntity(userModel);
  }

  @override
  Future<void> logout() async {
    return await remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((model) => model != null ? AuthMapper.toEntity(model) : null);
  }
}
