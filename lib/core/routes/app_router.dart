import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/counselor/presentation/screens/counselor_profile_screen.dart';
import '../../features/student/presentation/screens/CareersScreen.dart';
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
  initialLocation: AppRoutes.splash.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding.path,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection.path,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.register.path,
      builder: (context, state) {
        final role = state.extra as String? ?? 'estudiante';
        return RegisterScreen(role: role);
      },
    ),

    // Student
    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) => const StudentHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentProfile.path,
      builder: (context, state) => const StudentProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalResults.path,
      builder: (context, state) => const VocationalResultsScreen(),
    ),
    GoRoute(
      path: AppRoutes.careers.path,
      builder: (context, state) => const CareersScreen(),
    ),

    // Games
    GoRoute(
      path: AppRoutes.games.path,
      builder: (context, state) => const GamesListScreen(),
    ),

    // Chat
    GoRoute(
      path: AppRoutes.chat.path,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatContacts.path,
      builder: (context, state) => const ChatContactsScreen(),
    ),
    GoRoute(
      path: AppRoutes.realChat.path,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return RealChatScreen(
          contactId: args['contactId'],
          contactName: args['contactName'],
        );
      },
    ),

    // Counselor
    GoRoute(
      path: AppRoutes.counselorHome.path,
      builder: (context, state) => const CounselorHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalMap.path,
      builder: (context, state) => const VocationalMapScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentFile.path,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return StudentFileScreen(
          studentId: args['studentId'],
          studentName: args['studentName'],
        );
      },
    ),

    // Otros roles
    GoRoute(
      path: AppRoutes.counselorProfile.path,
      builder: (context, state) => const CounselorProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminHome.path,
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.alumniHome.path,
      builder: (context, state) => const AlumniHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.universityHome.path,
      builder: (context, state) => const UniversityHomeScreen(),
    ),
  ],
);