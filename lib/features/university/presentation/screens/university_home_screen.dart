import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../responsive.dart';
import '../providers/university_careers_provider.dart';
import '../providers/university_events_provider.dart';
import '../providers/university_alumni_provider.dart';
import '../components/university_bottom_navigation_bar.dart';
import '../components/university_home_app_bar.dart';
import '../components/university_institutional_header.dart';
import '../components/university_verification_banner.dart';
import '../components/university_section_header.dart';
import '../components/university_reach_summary.dart';
import '../components/university_alumni_carousel.dart';
import '../components/university_upcoming_event_card.dart';
import '../components/university_management_grid.dart';

import 'package:orientate/shared/theme/theme_provider.dart';

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
  State<UniversityHomeScreen> createState() => _UniversityHomeScreenState();
}

class _UniversityHomeScreenState extends State<UniversityHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UniversityCareersProvider>().fetchCareers();
        context.read<UniversityEventsProvider>().fetchEvents();
        context.read<UniversityAlumniProvider>().fetchAlumni();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final String universityName =
        (user?.universityName != null && user!.universityName!.isNotEmpty)
            ? user.universityName!
            : (user?.name ?? 'Universidad Registrada');
    final String status = user?.verificationStatus ?? 'UNVERIFIED';

    final careersProvider = context.watch<UniversityCareersProvider>();
    final eventsProvider = context.watch<UniversityEventsProvider>();
    final alumniProvider = context.watch<UniversityAlumniProvider>();

    final screenSize = context.screenSize;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF8F9FE),
      appBar: const UniversityHomeAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Widget content = switch (screenSize) {
              AppScreenSize.desktop => _DesktopLayout(
                  universityName: universityName,
                  status: status,
                  careersProvider: careersProvider,
                  eventsProvider: eventsProvider,
                  alumniProvider: alumniProvider,
                ),
              AppScreenSize.tablet => _TabletLayout(
                  universityName: universityName,
                  status: status,
                  careersProvider: careersProvider,
                  eventsProvider: eventsProvider,
                  alumniProvider: alumniProvider,
                ),
              AppScreenSize.mobile => _MobileLayout(
                  universityName: universityName,
                  status: status,
                  careersProvider: careersProvider,
                  eventsProvider: eventsProvider,
                  alumniProvider: alumniProvider,
                ),
            };

            if (screenSize == AppScreenSize.desktop) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: content,
                ),
              );
            }
            return content;
          },
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 0),
    );
  }
}

/// --- Mobile Layout ---
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.universityName,
    required this.status,
    required this.careersProvider,
    required this.eventsProvider,
    required this.alumniProvider,
  });

  final String universityName;
  final String status;
  final UniversityCareersProvider careersProvider;
  final UniversityEventsProvider eventsProvider;
  final UniversityAlumniProvider alumniProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UniversityInstitutionalHeader(
            universityName: universityName,
            status: status,
          ),
          if (status == 'UNVERIFIED') ...[
            SizedBox(height: 12.h),
            const UniversityVerificationBanner(),
          ],
          SizedBox(height: 20.h),
          const UniversitySectionHeader(title: 'Resumen de Alcance'),
          UniversityReachSummary(
            alumniCount: alumniProvider.alumni.length,
            careersCount: careersProvider.careers.length,
            eventsCount: eventsProvider.events.length,
          ),
          SizedBox(height: 20.h),
          UniversitySectionHeader(
            title: 'Egresados Destacados',
            actionLabel: 'Ver todos',
            onAction: () => context.push(AppRoutes.manageAlumni.path),
          ),
          UniversityAlumniCarousel(provider: alumniProvider),
          SizedBox(height: 20.h),
          const UniversitySectionHeader(title: 'Próximos Eventos'),
          UniversityUpcomingEventCard(provider: eventsProvider),
          SizedBox(height: 20.h),
          const UniversitySectionHeader(title: 'Gestión Institucional'),
          const UniversityManagementGrid(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

/// --- Tablet Layout ---
class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.universityName,
    required this.status,
    required this.careersProvider,
    required this.eventsProvider,
    required this.alumniProvider,
  });

  final String universityName;
  final String status;
  final UniversityCareersProvider careersProvider;
  final UniversityEventsProvider eventsProvider;
  final UniversityAlumniProvider alumniProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UniversityInstitutionalHeader(
            universityName: universityName,
            status: status,
          ),
          if (status == 'UNVERIFIED') ...[
            SizedBox(height: 16.h),
            const UniversityVerificationBanner(),
          ],
          SizedBox(height: 24.h),
          const UniversitySectionHeader(title: 'Resumen de Alcance'),
          UniversityReachSummary(
            alumniCount: alumniProvider.alumni.length,
            careersCount: careersProvider.careers.length,
            eventsCount: eventsProvider.events.length,
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    UniversitySectionHeader(
                      title: 'Egresados Destacados',
                      actionLabel: 'Ver todos',
                      onAction: () => context.push(AppRoutes.manageAlumni.path),
                    ),
                    UniversityAlumniCarousel(provider: alumniProvider),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  children: [
                    const UniversitySectionHeader(title: 'Próximos Eventos'),
                    UniversityUpcomingEventCard(provider: eventsProvider),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const UniversitySectionHeader(title: 'Gestión Institucional'),
          // En tablet, podríamos querer 3 columnas si el espacio lo permite, 
          // pero UniversityManagementGrid maneja su propia lógica interna ahora.
          const UniversityManagementGrid(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

/// --- Desktop Layout ---
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.universityName,
    required this.status,
    required this.careersProvider,
    required this.eventsProvider,
    required this.alumniProvider,
  });

  final String universityName;
  final String status;
  final UniversityCareersProvider careersProvider;
  final UniversityEventsProvider eventsProvider;
  final UniversityAlumniProvider alumniProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna Principal
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UniversityInstitutionalHeader(
                  universityName: universityName,
                  status: status,
                ),
                if (status == 'UNVERIFIED') ...[
                  SizedBox(height: 16.h),
                  const UniversityVerificationBanner(),
                ],
                SizedBox(height: 24.h),
                const UniversitySectionHeader(title: 'Resumen de Alcance'),
                UniversityReachSummary(
                  alumniCount: alumniProvider.alumni.length,
                  careersCount: careersProvider.careers.length,
                  eventsCount: eventsProvider.events.length,
                ),
                SizedBox(height: 32.h),
                const UniversitySectionHeader(title: 'Gestión Institucional'),
                const UniversityManagementGrid(),
              ],
            ),
          ),
          SizedBox(width: 32.w),
          // Columna Lateral
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UniversitySectionHeader(
                  title: 'Egresados Destacados',
                  actionLabel: 'Ver todos',
                  onAction: () => context.push(AppRoutes.manageAlumni.path),
                ),
                UniversityAlumniCarousel(provider: alumniProvider),
                SizedBox(height: 32.h),
                const UniversitySectionHeader(title: 'Próximos Eventos'),
                UniversityUpcomingEventCard(provider: eventsProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
