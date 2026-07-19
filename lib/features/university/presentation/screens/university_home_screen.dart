import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/university_provider.dart';
import '../components/university_home_header.dart';
import '../components/university_action_tile.dart';
import '../components/university_bottom_navigation_bar.dart';

class UniversityHomeScreen extends StatelessWidget {
  const UniversityHomeScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityProvider>();
    final profile = provider.profile;

    // Manejo de errores globales (Rate Limit, etc)
    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        provider.clearError();
      });
    }

    // Trigger data fetching if not already loaded or loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profile == null && !provider.isLoading && provider.errorMessage == null) {
        final up = context.read<UniversityProvider>();
        up.fetchProfile();
        up.fetchCareers();
        up.fetchEvents();
        up.fetchAnnouncements();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Portal Universidad',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : RefreshIndicator(
              onRefresh: () async {
                final up = context.read<UniversityProvider>();
                await up.fetchProfile();
                await up.fetchCareers();
                await up.fetchEvents();
                await up.fetchAnnouncements();
              },
              child: ListView(
                padding: EdgeInsets.all(24.w),
                children: [
                  UniversityHomeHeader(
                    name: profile?.name,
                    description: profile?.description,
                    careersCount: provider.careers.length,
                    eventsCount: provider.events.length,
                  ),
                  if (provider.errorMessage != null && profile == null) 
                    _buildErrorState(context, provider),
                  SizedBox(height: 32.h),
                  Text(
                    'Gestión Institucional',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: _accentColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  UniversityActionTile(
                    icon: Icons.school_rounded,
                    title: 'Oferta Académica',
                    subtitle: 'Administra tus carreras y facultades',
                    onTap: () => context.push(AppRoutes.manageCareers.path),
                  ),
                  UniversityActionTile(
                    icon: Icons.event_available_rounded,
                    title: 'Calendario de Eventos',
                    subtitle: 'Publica ferias y charlas vocacionales',
                    onTap: () => context.push(AppRoutes.manageEvents.path),
                  ),
                  UniversityActionTile(
                    icon: Icons.campaign_rounded,
                    title: 'Anuncios y Becas',
                    subtitle: 'Gestiona comunicados oficiales',
                    onTap: () => context.push(AppRoutes.manageAnnouncements.path),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildErrorState(BuildContext context, UniversityProvider provider) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'No se pudo cargar la información completa.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              provider.fetchProfile();
              provider.fetchCareers();
            },
            child: const Text('Reintentar'),
          )
        ],
      ),
    );
  }
}
