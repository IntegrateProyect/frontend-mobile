import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:orientate/app.dart';
import 'package:orientate/core/di/injection_container.dart' as di;
import 'package:orientate/shared/theme/theme_provider.dart';

// AUTH
import 'features/auth/presentation/providers/auth_provider.dart';

// COUNSELOR
import 'features/counselor/presentation/providers/counselor_provider.dart';

// STUDENT
import 'features/student/presentation/providers/careers_provider.dart';
import 'features/student/presentation/providers/student_home_provider.dart';
import 'features/student/presentation/providers/student_profile_provider.dart';
import 'features/student/presentation/providers/student_results_provider.dart';
import 'features/student/presentation/providers/favorites_provider.dart';
import 'features/student/presentation/providers/student_group_provider.dart';
import 'features/student/presentation/providers/student_appointments_provider.dart';
import 'features/student/presentation/providers/student_announcements_provider.dart';
import 'features/student/presentation/providers/student_progress_provider.dart';
import 'features/student/presentation/providers/student_events_provider.dart';

// UNIVERSITY
import 'features/university/presentation/providers/universities_provider.dart';
import 'features/university/presentation/providers/university_alumni_provider.dart';
import 'features/university/presentation/providers/university_announcements_provider.dart';
import 'features/university/presentation/providers/university_careers_provider.dart';
import 'features/university/presentation/providers/university_events_provider.dart';
import 'features/university/presentation/providers/university_profile_provider.dart';

// ALUMNI
import 'features/alumni/presentation/providers/alumni_home_provider.dart';
import 'features/alumni/presentation/providers/alumni_profile_form_provider.dart';
import 'features/alumni/presentation/providers/alumni_provider.dart';
import 'features/alumni/presentation/providers/success_stories_provider.dart';
import 'features/alumni/presentation/providers/write_story_provider.dart';

// VOCATIONAL GAMES
import 'features/vocational_games/presentation/providers/games_provider.dart';
import 'features/vocational_games/presentation/providers/game_play_provider.dart';
import 'features/vocational_games/presentation/providers/game_persistence_provider.dart';

// CHAT
import 'features/chat/presentation/providers/chat_provider.dart';

// CHATBOT
import 'features/chatbot/presentation/providers/chat_provider.dart' as chatbot;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa los formatos de fecha en español.
  await initializeDateFormatting('es', null);

  // Carga las variables de entorno.
  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (error, stackTrace) {
    debugPrint('No se pudo cargar assets/.env: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Inicializa GetIt y todas las dependencias.
  await di.init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          // ====================================================
          // TEMA
          // ====================================================
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),

          // ====================================================
          // AUTENTICACIÓN
          // ====================================================
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => di.sl<AuthProvider>(),
          ),

          // ====================================================
          // ORIENTADOR
          // ====================================================
          ChangeNotifierProvider<CounselorProvider>(
            create: (_) => di.sl<CounselorProvider>(),
          ),

          // ====================================================
          // ESTUDIANTE (Providers Especializados)
          // ====================================================
          ChangeNotifierProvider<StudentHomeProvider>(
            create: (_) => di.sl<StudentHomeProvider>(),
          ),
          ChangeNotifierProvider<StudentGroupProvider>(
            create: (_) => di.sl<StudentGroupProvider>(),
          ),
          ChangeNotifierProvider<StudentAppointmentsProvider>(
            create: (_) => di.sl<StudentAppointmentsProvider>(),
          ),
          ChangeNotifierProvider<StudentAnnouncementsProvider>(
            create: (_) => di.sl<StudentAnnouncementsProvider>(),
          ),
          ChangeNotifierProvider<StudentProgressProvider>(
            create: (_) => di.sl<StudentProgressProvider>(),
          ),
          ChangeNotifierProvider<StudentEventsProvider>(
            create: (_) => di.sl<StudentEventsProvider>(),
          ),
          ChangeNotifierProvider<StudentProfileProvider>(
            create: (_) => di.sl<StudentProfileProvider>(),
          ),
          ChangeNotifierProvider<StudentResultsProvider>(
            create: (_) => di.sl<StudentResultsProvider>(),
          ),
          ChangeNotifierProvider<CareersProvider>(
            create: (_) => di.sl<CareersProvider>(),
          ),
          ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => di.sl<FavoritesProvider>(),
          ),

          // ====================================================
          // CATÁLOGO DE UNIVERSIDADES
          // ====================================================
          ChangeNotifierProvider<UniversitiesProvider>(
            create: (_) => di.sl<UniversitiesProvider>(),
          ),

          // ====================================================
          // UNIVERSIDAD
          // ====================================================
          ChangeNotifierProvider<UniversityProfileProvider>(
            create: (_) => di.sl<UniversityProfileProvider>(),
          ),
          ChangeNotifierProvider<UniversityCareersProvider>(
            create: (_) => di.sl<UniversityCareersProvider>(),
          ),
          ChangeNotifierProvider<UniversityEventsProvider>(
            create: (_) => di.sl<UniversityEventsProvider>(),
          ),
          ChangeNotifierProvider<UniversityAnnouncementsProvider>(
            create: (_) => di.sl<UniversityAnnouncementsProvider>(),
          ),
          ChangeNotifierProvider<UniversityAlumniProvider>(
            create: (_) => di.sl<UniversityAlumniProvider>(),
          ),

          // ====================================================
          // EGRESADOS
          // ====================================================
          ChangeNotifierProvider<AlumniHomeProvider>(
            create: (_) => di.sl<AlumniHomeProvider>(),
          ),
          ChangeNotifierProvider<AlumniProvider>(
            create: (_) => di.sl<AlumniProvider>(),
          ),
          ChangeNotifierProvider<SuccessStoriesProvider>(
            create: (_) => di.sl<SuccessStoriesProvider>(),
          ),
          ChangeNotifierProvider<AlumniProfileFormProvider>(
            create: (_) => di.sl<AlumniProfileFormProvider>(),
          ),
          ChangeNotifierProvider<WriteStoryProvider>(
            create: (_) => di.sl<WriteStoryProvider>(),
          ),

          // ====================================================
          // MINIJUEGOS
          // ====================================================
          ChangeNotifierProvider<GamesProvider>(
            create: (_) => di.sl<GamesProvider>(),
          ),
          ChangeNotifierProvider<GamePlayProvider>(
            create: (_) => di.sl<GamePlayProvider>(),
          ),
          ChangeNotifierProvider<GamePersistenceProvider>(
            create: (_) => di.sl<GamePersistenceProvider>(),
          ),

          // ====================================================
          // CHAT
          // ====================================================
          ChangeNotifierProvider<ChatProvider>(
            create: (_) => di.sl<ChatProvider>(),
          ),

          // ====================================================
          // CHATBOT
          // ====================================================
          ChangeNotifierProvider<chatbot.ChatbotProvider>(
            create: (_) => di.sl<chatbot.ChatbotProvider>(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
