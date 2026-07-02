import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'AppRoutes.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/student/presentation/screens/student_home_screen.dart';
import '../../features/student/presentation/screens/student_profile_screen.dart';
import '../../features/student/presentation/screens/vocational_results_screen.dart';
import '../../features/vocational_games/presentation/screens/games_list_screen.dart';
import '../../features/counselor/presentation/screens/counselor_home_screen.dart';
import '../../features/counselor/presentation/screens/vocational_map_screen.dart';
import '../../features/counselor/presentation/screens/student_file_screen.dart';
import '../../features/admin/presentation/screens/admin_home_screen.dart';
import '../../features/alumni/presentation/screens/alumni_home_screen.dart';
import '../../features/university/presentation/screens/university_home_screen.dart';
import '../../features/chat/presentation/screens/chat_contacts_screen.dart';
import '../../features/chat/presentation/screens/real_chat_screen.dart';
import '../../features/chatbot/presentation/screens/chat_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final role = state.extra as String? ?? 'estudiante';
        return RegisterScreen(role: role);
      },
    ),
    
    // Rutas de Student
    GoRoute(path: '/home', builder: (context, state) => const StudentHomeScreen()),
    GoRoute(path: '/student-profile', builder: (context, state) => const StudentProfileScreen()),
    GoRoute(path: '/vocational-results', builder: (context, state) => const VocationalResultsScreen()),
    GoRoute(path: '/games', builder: (context, state) => const GamesListScreen()),

    // Rutas de Chat
    GoRoute(path: '/chat-contacts', builder: (context, state) => const ChatContactsScreen()),
    GoRoute(
      path: '/real-chat',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return RealChatScreen(
          contactId: args['contactId'],
          contactName: args['contactName'],
        );
      },
    ),

    // Rutas de Counselor
    GoRoute(path: '/counselor-home', builder: (context, state) => const CounselorHomeScreen()),
    GoRoute(path: AppRoutes.vocationalMap.path, builder: (context, state) => const VocationalMapScreen()),
    GoRoute(
      path: '/student-file',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return StudentFileScreen(
          studentId: args['studentId'],
          studentName: args['studentName'],
        );
      },
    ),

    // Rutas de otros roles
    GoRoute(path: '/admin-home', builder: (context, state) => const AdminHomeScreen()),
    GoRoute(path: '/alumni-home', builder: (context, state) => const AlumniHomeScreen()),
    GoRoute(path: '/university-home', builder: (context, state) => const UniversityHomeScreen()),
    GoRoute(path: AppRoutes.chat.path, builder: (context, state) => const ChatScreen()),
  ],
);
