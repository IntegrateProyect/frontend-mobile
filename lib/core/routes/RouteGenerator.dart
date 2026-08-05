import 'package:flutter/material.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

// Entidad requerida para enviar la universidad.
import 'package:orientate/features/university/domain/entities/university_entity.dart';

// Onboarding y autenticación
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

// Universidad (Ubicaciones corregidas)
import 'package:orientate/features/university/presentation/screens/universities_screen.dart';
import 'package:orientate/features/university/presentation/screens/university_detail_screen.dart';
import 'package:orientate/features/university/presentation/screens/scholarships_screen.dart';
import 'package:orientate/features/university/presentation/screens/university_home_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_careers_screen.dart';

// Chatbot y chat
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

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? name = settings.name;

    // =========================================================
    // ONBOARDING Y AUTENTICACIÓN
    // =========================================================

    if (name == AppRoutes.splash.path) {
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.onboarding.path) {
      return MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.login.path) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.register.path) {
      return MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.roleSelection.path) {
      return MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // ESTUDIANTE
    // =========================================================

    if (name == AppRoutes.studentProfileSetup.path) {
      return MaterialPageRoute(
        builder: (_) => const StudentProfileSetupScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.home.path) {
      return MaterialPageRoute(
        builder: (_) => const StudentHomeScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.studentProfile.path) {
      return MaterialPageRoute(
        builder: (_) => const StudentProfileScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.vocationalResults.path) {
      return MaterialPageRoute(
        builder: (_) => const VocationalResultsScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.careers.path) {
      return MaterialPageRoute(
        builder: (_) => const CareersScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.careerDetail.path) {
      return MaterialPageRoute(
        builder: (_) => const CareerDetailScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.careerCompare.path) {
      return MaterialPageRoute(
        builder: (_) => const CareerCompareScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.universities.path) {
      return MaterialPageRoute(
        builder: (_) => const UniversitiesScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // DETALLE DE UNIVERSIDAD
    // =========================================================

    if (name == AppRoutes.universityDetail.path) {
      final Object? arguments = settings.arguments;

      if (arguments is! UniversityEntity) {
        return _errorRoute(
          message: 'No se recibió la información de la universidad.',
        );
      }

      return MaterialPageRoute(
        builder: (_) => UniversityDetailScreen(
          university: arguments,
        ),
        settings: settings,
      );
    }

    if (name == AppRoutes.scholarships.path) {
      return MaterialPageRoute(
        builder: (_) => const ScholarshipsScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.events.path) {
      return MaterialPageRoute(
        builder: (_) => const EventsScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.alumniList.path) {
      return MaterialPageRoute(
        builder: (_) => const AlumniListScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.favorites.path) {
      return MaterialPageRoute(
        builder: (_) => const FavoritesScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.requestSupport.path) {
      return MaterialPageRoute(
        builder: (_) => const RequestSupportScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.vocationalRoute.path) {
      return MaterialPageRoute(
        builder: (_) => const VocationalRouteScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // CHAT
    // =========================================================

    if (name == AppRoutes.chat.path) {
      return MaterialPageRoute(
        builder: (_) => const ChatScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.chatContacts.path) {
      return MaterialPageRoute(
        builder: (_) => const ChatContactsScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.realChat.path) {
      final Object? arguments = settings.arguments;

      if (arguments is! Map<String, dynamic>) {
        return _errorRoute(
          message: 'No se recibió la información del contacto.',
        );
      }

      return MaterialPageRoute(
        builder: (_) => RealChatScreen(
          contactId: arguments['contactId']?.toString() ?? '',
          contactName: arguments['contactName']?.toString() ?? 'Contacto',
        ),
        settings: settings,
      );
    }

    // =========================================================
    // MINIJUEGOS
    // =========================================================

    if (name == AppRoutes.games.path) {
      return MaterialPageRoute(
        builder: (_) => const GamesListScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.gameDetail.path) {
      return _errorRoute(
        message: 'El detalle del minijuego todavía no está configurado.',
      );
    }

    // =========================================================
    // ORIENTADOR
    // =========================================================

    if (name == AppRoutes.counselorHome.path) {
      return MaterialPageRoute(
        builder: (_) => const CounselorHomeScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.counselorProfile.path) {
      return MaterialPageRoute(
        builder: (_) => const CounselorProfileScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // UNIVERSIDAD
    // =========================================================

    if (name == AppRoutes.universityHome.path) {
      return MaterialPageRoute(
        builder: (_) => const UniversityHomeScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.manageCareers.path) {
      return MaterialPageRoute(
        builder: (_) => const ManageCareersScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // ALUMNI
    // =========================================================

    if (name == AppRoutes.alumniHome.path) {
      return MaterialPageRoute(
        builder: (_) => const AlumniHomeScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.alumniProfile.path) {
      return MaterialPageRoute(
        builder: (_) => const AlumniProfileScreen(),
        settings: settings,
      );
    }

    // =========================================================
    // ADMINISTRADOR
    // =========================================================

    if (name == AppRoutes.adminHome.path) {
      return MaterialPageRoute(
        builder: (_) => const AdminHomeScreen(),
        settings: settings,
      );
    }

    if (name == AppRoutes.adminUsers.path) {
      return MaterialPageRoute(
        builder: (_) => const UserManagementScreen(),
        settings: settings,
      );
    }

    return _errorRoute();
  }

  static Route<dynamic> _errorRoute({
    String message = 'Página no encontrada',
  }) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
