import 'package:get_it/get_it.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Registers the network layer in the global GetIt instance.
class NetworkModule {
  static void init() {
    final getIt = GetIt.instance;

    // Register interceptors (optional as singletons for testing)
    getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor());
    getIt.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());

    // Register ApiClient – it will internally add the interceptors
    getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  }
}
