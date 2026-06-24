import 'package:orientate/core/di/AppContainer.dart';
import 'package:orientate/features/auth/data/remote/auth_remote_datasource.dart';
import 'package:orientate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:orientate/features/auth/domain/repositories/auth_repository.dart';
import 'package:orientate/features/auth/domain/usecases/login_usecase.dart';
import 'package:orientate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:orientate/features/auth/domain/usecases/register_usecase.dart';

class AuthModule {
  final AppContainer container;

  AuthModule(this.container);

  AuthRemoteDataSource provideRemoteDataSource() {
    return AuthRemoteDataSourceImpl();
  }

  AuthRepository provideAuthRepository() {
    return AuthRepositoryImpl(
      remoteDataSource: provideRemoteDataSource(),
    );
  }

  LoginUseCase provideLoginUseCase() {
    return LoginUseCase(provideAuthRepository());
  }

  RegisterUseCase provideRegisterUseCase() {
    return RegisterUseCase(provideAuthRepository());
  }

  LogoutUseCase provideLogoutUseCase() {
    return LogoutUseCase(provideAuthRepository());
  }
}
