import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:orientate/app.dart';
import 'package:orientate/core/di/injection_container.dart' as di;

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/chatbot/presentation/providers/chat_provider.dart';
import 'features/counselor/presentation/providers/counselor_provider.dart';
import 'features/student/presentation/providers/student_home_provider.dart';
import 'features/student/presentation/providers/student_profile_provider.dart';
import 'features/student/presentation/providers/student_results_provider.dart';
import 'features/student/presentation/providers/universities_provider.dart';
import 'features/university/presentation/providers/universities_provider.dart';
import 'features/university/presentation/providers/university_provider.dart';
import 'features/vocational_games/presentation/providers/games_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar localización para español
  await initializeDateFormatting('es', null);

  try {
    await dotenv.load(
      fileName: 'assets/.env',
    );
  } catch (error) {
    debugPrint(
      'No se pudo cargar assets/.env: $error',
    );
  }

  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => di.sl<AuthProvider>(),
        ),
        ChangeNotifierProvider<CounselorProvider>(
          create: (_) => di.sl<CounselorProvider>(),
        ),
        ChangeNotifierProvider<StudentHomeProvider>(
          create: (_) => di.sl<StudentHomeProvider>(),
        ),
        ChangeNotifierProvider<StudentProfileProvider>(
          create: (_) => di.sl<StudentProfileProvider>(),
        ),
        ChangeNotifierProvider<StudentResultsProvider>(
          create: (_) => di.sl<StudentResultsProvider>(),
        ),
        ChangeNotifierProvider<UniversitiesProvider>(
          create: (_) => di.sl<UniversitiesProvider>(),
        ),
        ChangeNotifierProvider<UniversityProvider>(
          create: (_) => di.sl<UniversityProvider>(),
        ),
        ChangeNotifierProvider<GamesProvider>(
          create: (_) => di.sl<GamesProvider>(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => di.sl<ChatProvider>(),
        ),
        ChangeNotifierProvider<ChatbotProvider>(
          create: (_) => di.sl<ChatbotProvider>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
