import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_story_card.dart';
import '../providers/alumni_home_provider.dart';

class AlumniHomeScreen extends StatelessWidget {
  const AlumniHomeScreen({super.key});

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniHomeProvider>();

    // Disparamos la carga de datos si el perfil es nulo y no estamos cargando
    if (provider.profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadHomeData());
    }

    // Manejo de redirección si el perfil no existe
    if (provider.errorMessage == 'PROFILE_NOT_FOUND') {
      Future.microtask(() => context.push(AppRoutes.alumniProfileForm.path));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Portal Alumni',
          style: TextStyle(
            color: const Color(0xFF1D1B4B),
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: primaryColor),
            onPressed: () => context.push(AppRoutes.alumniProfile.path),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: () => provider.loadHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeader(provider.profile?.name ?? 'Egresado'),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(context, 'Historias Recientes'),
                    SizedBox(height: 16.h),
                    if (provider.recentStories.isEmpty)
                      _buildEmptyState()
                    else
                      ...provider.recentStories.take(3).map((story) => AlumniStoryCard(
                            story: {
                              'name': story.alumniName,
                              'major': story.career,
                              'year': story.graduationYear.toString(),
                              'title': 'Historia de éxito',
                              'story': story.story,
                            },
                          )),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.writeStory.path),
        backgroundColor: primaryColor,
        label: Text('Compartir Historia', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.white)),
        icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF6A4CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Hola, $name! 🚀',
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tu experiencia es la guía para los estudiantes que hoy inician su camino.',
            style: TextStyle(color: Colors.white70, fontSize: 13.sp, height: 1.4),
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
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B)),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.successStories.path),
          child: const Text('Ver todas', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          'No hay historias recientes aún.',
          style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
        ),
      ),
    );
  }
}
