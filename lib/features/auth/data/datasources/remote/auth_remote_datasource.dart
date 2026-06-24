import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement remote login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    // TODO: Implement remote register
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement remote logout
    throw UnimplementedError();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // TODO: Implement auth state changes
    throw UnimplementedError();
  }
}
