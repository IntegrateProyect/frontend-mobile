import 'package:go_router/go_router.dart';

import 'AppRoutes.dart';

// =========================================================
// ONBOARDING
// =========================================================

import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

// =========================================================
// AUTENTICACIÓN
// =========================================================

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/student_profile_setup_screen.dart';

// =========================================================
// ESTUDIANTE
// =========================================================

import '../../features/student/presentation/screens/student_home_screen.dart';
import '../../features/student/presentation/screens/student_profile_screen.dart';
import '../../features/student/presentation/screens/vocational_results_screen.dart';
import '../../features/student/presentation/screens/CareersScreen.dart';
import '../../features/student/presentation/screens/universities_screen.dart';
import '../../features/student/presentation/screens/student_agenda_screen.dart';

// =========================================================
// MINIJUEGOS
// =========================================================

import '../../features/vocational_games/presentation/screens/games_list_screen.dart';

// =========================================================
// CHAT
// =========================================================

import '../../features/chat/presentation/screens/chat_contacts_screen.dart';
import '../../features/chat/presentation/screens/real_chat_screen.dart';
import '../../features/chatbot/presentation/screens/chat_screen.dart';

// =========================================================
// ORIENTADOR
// =========================================================

import '../../features/counselor/presentation/screens/counselor_home_screen.dart';
import '../../features/counselor/presentation/screens/counselor_profile_screen.dart';
import '../../features/counselor/presentation/screens/vocational_map_screen.dart';
import '../../features/counselor/presentation/screens/student_file_screen.dart';
import '../../features/counselor/presentation/screens/group_students_screen.dart';

// =========================================================
// OTROS ROLES
// =========================================================

import '../../features/admin/presentation/screens/admin_home_screen.dart';
import '../../features/alumni/presentation/screens/alumni_home_screen.dart';
import '../../features/alumni/presentation/screens/success_stories_screen.dart';
import '../../features/alumni/presentation/screens/alumni_profile_form_screen.dart';
import '../../features/alumni/presentation/screens/write_story_screen.dart';
import '../../features/university/presentation/screens/university_home_screen.dart';
import '../../features/university/presentation/screens/manage_careers_screen.dart';
import '../../features/university/presentation/screens/university_verification_screen.dart';
import '../../features/university/presentation/screens/manage_events_screen.dart';
import '../../features/university/presentation/screens/manage_announcements_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash.path,
  debugLogDiagnostics: true,
  routes: [
    // =========================================================
    // ONBOARDING
    // =========================================================

    GoRoute(
      path: AppRoutes.splash.path,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.onboarding.path,
      builder: (context, state) {
        return const OnboardingScreen();
      },
    ),

    // =========================================================
    // AUTENTICACIÓN
    // =========================================================

    GoRoute(
      path: AppRoutes.login.path,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.roleSelection.path,
      builder: (context, state) {
        return const RoleSelectionScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.register.path,
      builder: (context, state) {
        final role = state.extra as String? ?? 'estudiante';

        return RegisterScreen(
          role: role,
        );
      },
    ),

    // =========================================================
    // ESTUDIANTE
    // =========================================================

    GoRoute(
      path: AppRoutes.studentProfileSetup.path,
      builder: (context, state) {
        return const StudentProfileSetupScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) {
        return const StudentHomeScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.studentProfile.path,
      builder: (context, state) {
        return const StudentProfileScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.vocationalResults.path,
      builder: (context, state) {
        return const VocationalResultsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.careers.path,
      builder: (context, state) {
        return const CareersScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.universities.path,
      builder: (context, state) {
        return const UniversitiesScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.studentAgenda.path,
      builder: (context, state) {
        return const StudentAgendaScreen();
      },
    ),

    // =========================================================
    // MINIJUEGOS
    // =========================================================

    GoRoute(
      path: AppRoutes.games.path,
      builder: (context, state) {
        return const GamesListScreen();
      },
    ),

    // =========================================================
    // CHAT
    // =========================================================

    GoRoute(
      path: AppRoutes.chat.path,
      builder: (context, state) {
        return const ChatScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.chatContacts.path,
      builder: (context, state) {
        return const ChatContactsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.realChat.path,
      builder: (context, state) {
        final args =
            state.extra as Map<String, dynamic>? ?? {};

        return RealChatScreen(
          contactId:
          args['contactId']?.toString() ?? '',
          contactName:
          args['contactName']?.toString() ??
              'Contacto',
        );
      },
    ),

    // =========================================================
    // ORIENTADOR
    // =========================================================

    GoRoute(
      path: AppRoutes.counselorHome.path,
      builder: (context, state) {
        return const CounselorHomeScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.counselorProfile.path,
      builder: (context, state) {
        return const CounselorProfileScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.vocationalMap.path,
      builder: (context, state) {
        return const VocationalMapScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.studentFile.path,
      builder: (context, state) {
        final args =
            state.extra as Map<String, dynamic>? ?? {};

        return StudentFileScreen(
          studentId:
          args['studentId']?.toString() ?? '',
          studentName:
          args['studentName']?.toString() ??
              'Estudiante',
        );
      },
    ),

    GoRoute(
      path: AppRoutes.groupStudents.path,
      builder: (context, state) {
        final args =
            state.extra as Map<String, dynamic>? ?? {};

        return GroupStudentsScreen(
          groupId:
          args['groupId']?.toString() ?? '',
          groupName:
          args['groupName']?.toString() ??
              'Grupo',
        );
      },
    ),

    // =========================================================
    // ADMINISTRADOR
    // =========================================================

    GoRoute(
      path: AppRoutes.adminHome.path,
      builder: (context, state) {
        return const AdminHomeScreen();
      },
    ),

    // =========================================================
    // ALUMNI
    // =========================================================

    GoRoute(
      path: AppRoutes.alumniHome.path,
      builder: (context, state) {
        return const AlumniHomeScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.successStories.path,
      builder: (context, state) {
        return const SuccessStoriesScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.alumniProfileForm.path,
      builder: (context, state) {
        return const AlumniProfileFormScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.writeStory.path,
      builder: (context, state) {
        return const WriteStoryScreen();
      },
    ),

    // =========================================================
    // UNIVERSIDAD
    // =========================================================

    GoRoute(
      path: AppRoutes.universityHome.path,
      builder: (context, state) {
        return const UniversityHomeScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.manageCareers.path,
      builder: (context, state) {
        return const ManageCareersScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.universityVerification.path,
      builder: (context, state) {
        return const UniversityVerificationScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.manageEvents.path,
      builder: (context, state) {
        return const ManageEventsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.manageAnnouncements.path,
      builder: (context, state) {
        return const ManageAnnouncementsScreen();
      },
    ),
  ],
);