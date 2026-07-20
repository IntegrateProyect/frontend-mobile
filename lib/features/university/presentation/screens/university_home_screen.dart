import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
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
    
    final String universityName = (user?.universityName != null && user!.universityName!.isNotEmpty)
        ? user.universityName!
        : (user?.name ?? 'Universidad Registrada');
    final String status = user?.verificationStatus ?? 'UNVERIFIED';

    final careersProvider = context.watch<UniversityCareersProvider>();
    final eventsProvider = context.watch<UniversityEventsProvider>();
    final alumniProvider = context.watch<UniversityAlumniProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: const UniversityHomeAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UniversityInstitutionalHeader(
              universityName: universityName,
              status: status,
            ),
            if (status == 'UNVERIFIED') ...[
              SizedBox(height: 4.h),
              const UniversityVerificationBanner(),
            ],
            SizedBox(height: 8.h),
            const UniversitySectionHeader(title: 'Resumen de Alcance'),
            UniversityReachSummary(
              alumniCount: alumniProvider.alumni.length,
              careersCount: careersProvider.careers.length,
              eventsCount: eventsProvider.events.length,
            ),
            SizedBox(height: 8.h),
            UniversitySectionHeader(
              title: 'Egresados Destacados',
              actionLabel: 'Ver todos',
              onAction: () => context.push(AppRoutes.manageAlumni.path),
            ),
            UniversityAlumniCarousel(provider: alumniProvider),
            SizedBox(height: 8.h),
            const UniversitySectionHeader(title: 'Próximos Eventos'),
            UniversityUpcomingEventCard(provider: eventsProvider),
            SizedBox(height: 8.h),
            const UniversitySectionHeader(title: 'Gestión Institucional'),
            const UniversityManagementGrid(),
            SizedBox(height: 8.h),
          ],
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 0),
    );
  }
}
