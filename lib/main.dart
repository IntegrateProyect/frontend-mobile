import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:orientate/app.dart';
import 'package:orientate/core/di/injection_container.dart' as di;
import 'package:orientate/core/security/security_service.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/counselor/presentation/providers/counselor_provider.dart';
import 'features/student/presentation/providers/student_home_provider.dart';
import 'features/student/presentation/providers/student_profile_provider.dart';
import 'features/student/presentation/providers/student_results_provider.dart';
import 'features/vocational_games/presentation/providers/games_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (_) {}

  final isSecure = await SecurityService.isSecureEnvironment();

  if (!isSecure) {
    runApp(const UnsafeEnvironmentApp());
    return;
  }

  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CounselorProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentHomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentProfileProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentResultsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<GamesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class UnsafeEnvironmentApp extends StatelessWidget {
  const UnsafeEnvironmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'La app no puede ejecutarse en un entorno inseguro.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}