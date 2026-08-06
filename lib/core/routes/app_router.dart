import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

// Entidades
import 'package:orientate/features/university/domain/entities/university_entity.dart';

// Screens
import 'package:orientate/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:orientate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:orientate/features/auth/presentation/screens/login_screen.dart';
import 'package:orientate/features/auth/presentation/screens/register_screen.dart';
import 'package:orientate/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:orientate/features/auth/presentation/screens/student_profile_setup_screen.dart';

// Estudiante
import 'package:orientate/features/student/presentation/screens/student_home_screen.dart';
import 'package:orientate/features/student/presentation/screens/student_profile_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_results_screen.dart';
import 'package:orientate/features/student/presentation/screens/CareersScreen.dart';
import 'package:orientate/features/student/presentation/screens/career_detail_screen.dart';
import 'package:orientate/features/student/presentation/screens/career_compare_screen.dart';
import 'package:orientate/features/student/presentation/screens/events_screen.dart';
import 'package:orientate/features/student/presentation/screens/alumni_list_screen.dart';
import 'package:orientate/features/student/presentation/screens/favorites_screen.dart';
import 'package:orientate/features/student/presentation/screens/request_support_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_route_screen.dart';
import 'package:orientate/features/student/presentation/screens/student_agenda_screen.dart';

// Universidad
import 'package:orientate/features/university/presentation/screens/universities_screen.dart';
import 'package:orientate/features/university/presentation/screens/university_detail_screen.dart';
import 'package:orientate/features/university/presentation/screens/scholarships_screen.dart';
import 'package:orientate/features/university/presentation/screens/university_home_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_careers_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_alumni_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_announcements_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_events_screen.dart';

// Chat y Chatbot
import 'package:orientate/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:orientate/features/chat/presentation/screens/chat_contacts_screen.dart';
import 'package:orientate/features/chat/presentation/screens/real_chat_screen.dart';

// Minijuegos
import 'package:orientate/features/vocational_games/presentation/screens/games_list_screen.dart';

// Orientador
import 'package:orientate/features/counselor/presentation/screens/counselor_home_screen.dart';
import 'package:orientate/features/counselor/presentation/screens/counselor_profile_screen.dart';

// Alumni
import 'package:orientate/features/alumni/presentation/screens/alumni_home_screen.dart';
import 'package:orientate/features/alumni/presentation/screens/alumni_profile_screen.dart';

// Administrador
import 'package:orientate/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:orientate/features/admin/presentation/screens/user_management_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash.path,
  debugLogDiagnostics: true,
  routes: [
    // Auth & Onboarding
    GoRoute(
      path: AppRoutes.splash.path,
      name: AppRoutes.splash.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding.path,
      name: AppRoutes.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login.path,
      name: AppRoutes.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register.path,
      name: AppRoutes.register.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection.path,
      name: AppRoutes.roleSelection.name,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentProfileSetup.path,
      name: AppRoutes.studentProfileSetup.name,
      builder: (context, state) => const StudentProfileSetupScreen(),
    ),

    // Student
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const StudentHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentProfile.path,
      name: AppRoutes.studentProfile.name,
      builder: (context, state) => const StudentProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalResults.path,
      name: AppRoutes.vocationalResults.name,
      builder: (context, state) => const VocationalResultsScreen(),
    ),
    GoRoute(
      path: AppRoutes.careers.path,
      name: AppRoutes.careers.name,
      builder: (context, state) => const CareersScreen(),
    ),
    GoRoute(
      path: AppRoutes.careerDetail.path,
      name: AppRoutes.careerDetail.name,
      builder: (context, state) => const CareerDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.careerCompare.path,
      name: AppRoutes.careerCompare.name,
      builder: (context, state) => const CareerCompareScreen(),
    ),
    GoRoute(
      path: AppRoutes.universities.path,
      name: AppRoutes.universities.name,
      builder: (context, state) => const UniversitiesScreen(),
    ),
    GoRoute(
      path: AppRoutes.universityDetail.path,
      name: AppRoutes.universityDetail.name,
      builder: (context, state) {
        final university = state.extra as UniversityEntity;
        return UniversityDetailScreen(university: university);
      },
    ),
    GoRoute(
      path: AppRoutes.scholarships.path,
      name: AppRoutes.scholarships.name,
      builder: (context, state) => const ScholarshipsScreen(),
    ),
    GoRoute(
      path: AppRoutes.events.path,
      name: AppRoutes.events.name,
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.alumniList.path,
      name: AppRoutes.alumniList.name,
      builder: (context, state) => const AlumniListScreen(),
    ),
    GoRoute(
      path: AppRoutes.favorites.path,
      name: AppRoutes.favorites.name,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: AppRoutes.requestSupport.path,
      name: AppRoutes.requestSupport.name,
      builder: (context, state) => const RequestSupportScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalRoute.path,
      name: AppRoutes.vocationalRoute.name,
      builder: (context, state) => const VocationalRouteScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentAgenda.path,
      name: AppRoutes.studentAgenda.name,
      builder: (context, state) => const StudentAgendaScreen(),
    ),

    // Chat
    GoRoute(
      path: AppRoutes.chat.path,
      name: AppRoutes.chat.name,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatContacts.path,
      name: AppRoutes.chatContacts.name,
      builder: (context, state) => const ChatContactsScreen(),
    ),
    GoRoute(
      path: AppRoutes.realChat.path,
      name: AppRoutes.realChat.name,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return RealChatScreen(
          contactId: extras['contactId']?.toString() ?? '',
          contactName: extras['contactName']?.toString() ?? 'Contacto',
        );
      },
    ),

    // Games
    GoRoute(
      path: AppRoutes.games.path,
      name: AppRoutes.games.name,
      builder: (context, state) => const GamesListScreen(),
    ),

    // Counselor
    GoRoute(
      path: AppRoutes.counselorHome.path,
      name: AppRoutes.counselorHome.name,
      builder: (context, state) => const CounselorHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.counselorProfile.path,
      name: AppRoutes.counselorProfile.name,
      builder: (context, state) => const CounselorProfileScreen(),
    ),

    // University Admin
    GoRoute(
      path: AppRoutes.universityHome.path,
      name: AppRoutes.universityHome.name,
      builder: (context, state) => const UniversityHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageCareers.path,
      name: AppRoutes.manageCareers.name,
      builder: (context, state) => const ManageCareersScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageAlumni.path,
      name: AppRoutes.manageAlumni.name,
      builder: (context, state) => const ManageAlumniScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageAnnouncements.path,
      name: AppRoutes.manageAnnouncements.name,
      builder: (context, state) => const ManageAnnouncementsScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageEvents.path,
      name: AppRoutes.manageEvents.name,
      builder: (context, state) => const ManageEventsScreen(),
    ),

    // Alumni Feature
    GoRoute(
      path: AppRoutes.alumniHome.path,
      name: AppRoutes.alumniHome.name,
      builder: (context, state) => const AlumniHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.alumniProfile.path,
      name: AppRoutes.alumniProfile.name,
      builder: (context, state) => const AlumniProfileScreen(),
    ),

    // Admin
    GoRoute(
      path: AppRoutes.adminHome.path,
      name: AppRoutes.adminHome.name,
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminUsers.path,
      name: AppRoutes.adminUsers.name,
      builder: (context, state) => const UserManagementScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Página no encontrada: ${state.error}'),
    ),
  ),
);
