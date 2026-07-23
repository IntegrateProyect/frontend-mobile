import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_story_card.dart';
import '../components/alumni_empty_state.dart';
import '../providers/alumni_home_provider.dart';

class AlumniHomeScreen extends StatelessWidget {
  const AlumniHomeScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniHomeProvider>();

    if (provider.profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadHomeData());
    }

    if (provider.errorMessage == 'PROFILE_NOT_FOUND') {
      Future.microtask(() => context.push(AppRoutes.alumniProfileForm.path));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 50.h,
        title: Text(
          'Portal Alumni',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline_rounded, color: _primaryColor, size: 18),
            ),
            onPressed: () => context.push(AppRoutes.alumniProfile.path),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : RefreshIndicator(
              onRefresh: () => provider.loadHomeData(),
              color: _primaryColor,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeader(provider.profile?.name ?? 'Egresado'),
                    SizedBox(height: 22.h),
                    _buildSectionHeader(context, 'Historias Recientes'),
                    SizedBox(height: 10.h),
                    if (provider.recentStories.isEmpty)
                      AlumniEmptyState(
                        title: 'Comienza tu legado',
                        description: 'Comparte tu trayectoria y ayuda a guiar a los estudiantes que hoy inician su camino profesional.',
                        imagePath: 'assets/images/literario.jpg',
                        actionLabel: 'Compartir Historia',
                        onAction: () => context.push(AppRoutes.writeStory.path),
                      )
                    else ...[
                      ...provider.recentStories.take(3).map((story) => AlumniStoryCard(
                            story: {
                              'name': story.alumniName,
                              'major': story.career,
                              'year': story.graduationYear.toString(),
                              'title': 'Camino al Éxito',
                              'story': story.story,
                            },
                          )),
                      SizedBox(height: 80.h), // Espacio para el botón flotante
                    ],
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: provider.recentStories.isNotEmpty 
          ? _buildPremiumFab(context)
          : null,
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '¡Hola, $name!',
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const Spacer(),
              const Icon(Icons.rocket_launch_rounded, color: Colors.white24, size: 24),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Tu experiencia es la brújula para los estudiantes que hoy inician su camino profesional.',
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5.sp, height: 1.4, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: _accentColor, letterSpacing: -0.4),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.successStories.path),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            foregroundColor: _primaryColor,
          ),
          child: Text('Ver todas', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp)),
        ),
      ],
    );
  }

  Widget _buildPremiumFab(BuildContext context) {
    return Container(
      height: 52.h,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF4527A0), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.push(AppRoutes.writeStory.path),
        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
        label: Text('Compartir Historia', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        ),
      ),
    );
  }
}
