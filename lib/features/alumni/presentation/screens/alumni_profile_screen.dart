import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/alumni_header.dart';
import '../components/alumni_info_tile.dart';
import '../providers/alumni_home_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/shared/theme/theme_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class AlumniProfileScreen extends StatelessWidget {
  const AlumniProfileScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniHomeProvider>();
    final profile = provider.profile;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    final String displayName = (profile?.name != null && profile!.name.trim().isNotEmpty)
        ? profile.name
        : (user?.name ?? 'Egresado');

    final String displayDegree = (profile?.degree != null && profile!.degree.trim().isNotEmpty)
        ? profile.degree
        : 'Carrera';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF8F9FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          AlumniHeader(
            name: displayName,
            subtitle: '$displayDegree • Egresado',
            isVerified: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  _buildStatsRow(isDark),
                  SizedBox(height: 28.h),
                  _buildProfileCard(profile, user, isDark),
                  SizedBox(height: 32.h),
                  _buildActions(context, themeProvider, isDark),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? const Color(0xFF303149) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('12', 'Historias', isDark),
          _buildDivider(isDark),
          _buildStatItem('4.5k', 'Vistas', isDark),
          _buildDivider(isDark),
          _buildStatItem('156', 'Impacto', isDark),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) => Container(width: 1, height: 30.h, color: isDark ? const Color(0xFF303149) : const Color(0xFFF1F5F9));

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: isDark ? const Color(0xFFB59AFF) : _primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[400], fontWeight: FontWeight.w800, letterSpacing: 1.0),
        ),
      ],
    );
  }

  Widget _buildProfileCard(dynamic profile, dynamic user, bool isDark) {
    final String currentJobValue = (profile?.degree != null && profile!.degree.trim().isNotEmpty)
        ? 'Egresado de ${profile.degree}'
        : 'Egresado';

    final String companyValue = (profile?.company != null && profile!.company.trim().isNotEmpty)
        ? profile.company
        : 'No especificada';

    final String gradYearValue = (profile?.graduationYear != null && profile!.graduationYear > 0)
        ? profile.graduationYear.toString()
        : 'No especificado';

    final String emailValue = (profile?.email != null && profile!.email.trim().isNotEmpty)
        ? profile.email
        : (user?.email ?? 'No especificado');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: isDark ? const Color(0xFF303149) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Profesional',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : _accentColor,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 20.h),
          AlumniInfoTile(
            icon: Icons.work_outline_rounded,
            label: 'Puesto Actual',
            value: currentJobValue,
          ),
          _buildItemDivider(isDark),
          AlumniInfoTile(
            icon: Icons.business_outlined,
            label: 'Empresa',
            value: companyValue,
          ),
          _buildItemDivider(isDark),
          AlumniInfoTile(
            icon: Icons.history_edu_rounded,
            label: 'Año de Graduación',
            value: gradYearValue,
          ),
          _buildItemDivider(isDark),
          AlumniInfoTile(
            icon: Icons.email_outlined,
            label: 'Contacto Institucional',
            value: emailValue,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDivider(bool isDark) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Divider(color: isDark ? const Color(0xFF303149) : const Color(0xFFF8FAFF), thickness: 1.5),
  );

  Widget _buildActions(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 24.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1B2E) : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark ? const Color(0xFF303149) : const Color(0xFFECECF3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? Colors.amberAccent : const Color(0xFF311B92),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modo Oscuro',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      isDark ? 'Tema oscuro activado' : 'Tema claro activado',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                onChanged: themeProvider.setDarkMode,
                activeColor: Colors.amberAccent,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(color: _primaryColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => context.push(AppRoutes.alumniProfileForm.path),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size.fromHeight(56.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              elevation: 0,
            ),
            child: Text('Editar mi Perfil', 
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp, letterSpacing: 0.2)),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
            if (context.mounted) context.go('/login');
          },
          child: Text(
            'Cerrar Sesión',
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
