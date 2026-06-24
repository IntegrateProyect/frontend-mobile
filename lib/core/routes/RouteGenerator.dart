import 'package:flutter/material.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

// Onboarding & Auth
import 'package:orientate/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:orientate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:orientate/features/auth/presentation/screens/login_screen.dart';
import 'package:orientate/features/auth/presentation/screens/register_screen.dart';
import 'package:orientate/features/auth/presentation/screens/role_selection_screen.dart';

// Student
import 'package:orientate/features/student/presentation/screens/student_home_screen.dart';
import 'package:orientate/features/student/presentation/screens/student_profile_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_results_screen.dart';
import 'package:orientate/features/student/presentation/screens/careers_screen.dart';
import 'package:orientate/features/student/presentation/screens/career_detail_screen.dart';
import 'package:orientate/features/student/presentation/screens/career_compare_screen.dart';
import 'package:orientate/features/student/presentation/screens/universities_screen.dart';
import 'package:orientate/features/student/presentation/screens/university_detail_screen.dart';
import 'package:orientate/features/student/presentation/screens/scholarships_screen.dart';
import 'package:orientate/features/student/presentation/screens/events_screen.dart';
import 'package:orientate/features/student/presentation/screens/alumni_list_screen.dart';
import 'package:orientate/features/student/presentation/screens/favorites_screen.dart';
import 'package:orientate/features/student/presentation/screens/request_support_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_route_screen.dart';

// Chatbot
import 'package:orientate/features/chatbot/presentation/screens/chat_screen.dart';

// Games
import 'package:orientate/features/vocational_games/presentation/screens/games_list_screen.dart';
import 'package:orientate/features/vocational_games/presentation/screens/game_detail_screen.dart';

// Counselor
import 'package:orientate/features/counselor/presentation/screens/counselor_home_screen.dart';
import 'package:orientate/features/counselor/presentation/screens/counselor_profile_screen.dart';

// University Institution
import 'package:orientate/features/university/presentation/screens/university_home_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_careers_screen.dart';

// Alumni
import 'package:orientate/features/alumni/presentation/screens/alumni_home_screen.dart';
import 'package:orientate/features/alumni/presentation/screens/alumni_profile_screen.dart';

// Admin
import 'package:orientate/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:orientate/features/admin/presentation/screens/user_management_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == AppRoutes.splash.path) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (name == AppRoutes.onboarding.path) {
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    } else if (name == AppRoutes.login.path) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    } else if (name == AppRoutes.register.path) {
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    } else if (name == AppRoutes.roleSelection.path) {
      return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
    }
    
    // Student Routes
    else if (name == AppRoutes.home.path) {
      return MaterialPageRoute(builder: (_) => const StudentHomeScreen());
    } else if (name == AppRoutes.studentProfile.path) {
      return MaterialPageRoute(builder: (_) => const StudentProfileScreen());
    } else if (name == AppRoutes.vocationalResults.path) {
      return MaterialPageRoute(builder: (_) => const VocationalResultsScreen());
    } else if (name == AppRoutes.careers.path) {
      return MaterialPageRoute(builder: (_) => const CareersScreen());
    } else if (name == AppRoutes.careerDetail.path) {
      return MaterialPageRoute(builder: (_) => const CareerDetailScreen());
    } else if (name == AppRoutes.careerCompare.path) {
      return MaterialPageRoute(builder: (_) => const CareerCompareScreen());
    } else if (name == AppRoutes.universities.path) {
      return MaterialPageRoute(builder: (_) => const UniversitiesScreen());
    } else if (name == AppRoutes.universityDetail.path) {
      return MaterialPageRoute(builder: (_) => const UniversityDetailScreen());
    } else if (name == AppRoutes.scholarships.path) {
      return MaterialPageRoute(builder: (_) => const ScholarshipsScreen());
    } else if (name == AppRoutes.events.path) {
      return MaterialPageRoute(builder: (_) => const EventsScreen());
    } else if (name == AppRoutes.alumniList.path) {
      return MaterialPageRoute(builder: (_) => const AlumniListScreen());
    } else if (name == AppRoutes.favorites.path) {
      return MaterialPageRoute(builder: (_) => const FavoritesScreen());
    } else if (name == AppRoutes.requestSupport.path) {
      return MaterialPageRoute(builder: (_) => const RequestSupportScreen());
    } else if (name == AppRoutes.vocationalRoute.path) {
      return MaterialPageRoute(builder: (_) => const VocationalRouteScreen());
    }

    // Chatbot
    else if (name == AppRoutes.chat.path) {
      return MaterialPageRoute(builder: (_) => const ChatScreen());
    }

    // Games
    else if (name == AppRoutes.games.path) {
      return MaterialPageRoute(builder: (_) => const GamesListScreen());
    } else if (name == AppRoutes.gameDetail.path) {
      return MaterialPageRoute(builder: (_) => const GameDetailScreen());
    }

    // Counselor
    else if (name == AppRoutes.counselorHome.path) {
      return MaterialPageRoute(builder: (_) => const CounselorHomeScreen());
    } else if (name == AppRoutes.counselorProfile.path) {
      return MaterialPageRoute(builder: (_) => const CounselorProfileScreen());
    }

    // University Institution
    else if (name == AppRoutes.universityHome.path) {
      return MaterialPageRoute(builder: (_) => const UniversityHomeScreen());
    } else if (name == AppRoutes.manageCareers.path) {
      return MaterialPageRoute(builder: (_) => const ManageCareersScreen());
    }

    // Alumni
    else if (name == AppRoutes.alumniHome.path) {
      return MaterialPageRoute(builder: (_) => const AlumniHomeScreen());
    } else if (name == AppRoutes.alumniProfile.path) {
      return MaterialPageRoute(builder: (_) => const AlumniProfileScreen());
    }

    // Admin
    else if (name == AppRoutes.adminHome.path) {
      return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
    } else if (name == AppRoutes.adminUsers.path) {
      return MaterialPageRoute(builder: (_) => const UserManagementScreen());
    }

    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Página no encontrada')),
      );
    });
  }
}
