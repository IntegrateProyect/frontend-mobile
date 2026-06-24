import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orientate/app.dart';
import 'package:orientate/core/di/AppContainer.dart';
import 'package:orientate/features/auth/di/AuthModule.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env"); // Descomentar si usas variables de entorno

  final appContainer = AppContainer();
  final authModule = AuthModule(appContainer);

  runApp(
    MultiProvider(
      providers: [
        // ───────────────── AUTH ─────────────────
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: authModule.provideLoginUseCase(),
            registerUseCase: authModule.provideRegisterUseCase(),
            logoutUseCase: authModule.provideLogoutUseCase(),
          ),
        ),
        
        // Agrega aquí otros módulos según sea necesario (Student, Counselor, etc.)
      ],
      child: const MyApp(),
    ),
  );
}
