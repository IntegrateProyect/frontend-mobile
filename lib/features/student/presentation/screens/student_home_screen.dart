import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';
import '../components/home/career_recommendations_carousel.dart';
import '../components/home/expo_universities_card.dart';
import '../components/home/student_appointments_section.dart';
import '../components/home/student_greeting.dart';
import '../components/home/student_home_app_bar.dart';
import '../components/home/student_recommendations_card.dart';

import '../components/home/quick_access_grid.dart' as quick_access;
import '../components/home/student_account_sheet.dart' as account_sheet;

import '../providers/student_home_provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<StudentHomeProvider>().loadHomeData();
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();

    return Scaffold(
      backgroundColor: StudentUiColors.background,
      appBar: StudentHomeAppBar(
        onNotificationsPressed: () {
          _showMessage('Notificaciones próximamente');
        },
        onAccountPressed: () {
          account_sheet.showStudentAccountSheet(
            context: context,
            homeProvider: provider,
            authProvider: context.read<AuthProvider>(),
          );
        },
      ),
      body: _buildBody(provider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: StudentUiColors.teal,
        elevation: 8,
        onPressed: () => context.push(AppRoutes.chat.path),
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: const StudentBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    if (provider.isLoading && provider.profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: provider.loadHomeData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          18.w,
          16.h,
          18.w,
          26.h,
        ),
        children: [
          // SALUDO
          StudentGreeting(
            name: provider.firstName,
          ),

          SizedBox(height: 18.h),

          // EXPO UNIVERSIDADES
          ExpoUniversitiesCard(
            onTap: () {
              context.push(AppRoutes.universities.path);
            },
          ),

          SizedBox(height: 16.h),

          // RECOMENDACIONES PARA TI
          StudentRecommendationsCard(
            onCareersTap: () {
              context.push(AppRoutes.careers.path);
            },
            onUniversitiesTap: () {
              context.push(AppRoutes.universities.path);
            },
          ),

          SizedBox(height: 18.h),

          // CITAS, AHORA DEBAJO DE RECOMENDACIONES
          StudentAppointmentsSection(
            appointments: provider.appointments,
            onRefresh: provider.loadHomeData,
          ),

          SizedBox(height: 18.h),

          // CARRERAS RECOMENDADAS
          const CareerRecommendationsCarousel(),

          SizedBox(height: 18.h),

          // ACCESOS RÁPIDOS
          quick_access.QuickAccessGrid(
            onMessagesTap: () {
              context.push(AppRoutes.chatContacts.path);
            },
            onCareersTap: () {
              context.push(AppRoutes.careers.path);
            },
            onUniversitiesTap: () {
              context.push(AppRoutes.universities.path);
            },
            onEventsTap: () {
              _showMessage('Eventos próximamente');
            },
          ),
        ],
      ),
    );
  }
}