import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';
import '../components/profile/avatar_picker_sheet.dart';
import '../components/profile/profile_avatar_header.dart';
import '../components/profile/profile_chip_section.dart';
import '../components/profile/profile_preferences_row.dart';
import '../components/profile/student_profile_empty_state.dart';
import '../components/profile/vocational_clarity_card.dart';
import 'package:orientate/shared/theme/theme_provider.dart';
import '../providers/student_profile_provider.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() {
    return _StudentProfileScreenState();
  }
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context
          .read<StudentProfileProvider>()
          .fetchProfile();
    });
  }

  void _goToStudentHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.go(AppRoutes.home.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final profileProvider =
    context.watch<StudentProfileProvider>();

    final authProvider = context.watch<AuthProvider>();
    final profile = profileProvider.profile;

    final String? avatarUrl =
        authProvider.user?.avatarUrl ??
            profile?.profileImageUrl;

    return PopScope(
      /*
       * Perfil es una ruta principal abierta con context.go().
       * Por eso no debemos ejecutar context.pop(), porque puede no
       * existir una página anterior en la pila.
       */
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _goToStudentHome();
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Regresar al inicio',
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
            onPressed: _goToStudentHome,
          ),
          title: Text(
            'Perfil Vocacional',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(
          profileProvider: profileProvider,
          authProvider: authProvider,
          themeProvider: themeProvider,
          avatarUrl: avatarUrl,
        ),
        bottomNavigationBar:
        const StudentBottomNavigationBar(
          currentIndex: 4,
        ),
      ),
    );
  }

  Widget _buildBody({
    required StudentProfileProvider profileProvider,
    required AuthProvider authProvider,
    required ThemeProvider themeProvider,
    required String? avatarUrl,
  }) {
    final profile = profileProvider.profile;

    if (profileProvider.isLoading && profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    if (profile == null) {
      return StudentProfileEmptyState(
        onRetry: profileProvider.fetchProfile,
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: StudentUiColors.primary,
          onRefresh: profileProvider.fetchProfile,
          child: ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              24.w,
              10.h,
              24.w,
              40.h,
            ),
            children: [
              ProfileAvatarHeader(
                avatarUrl: avatarUrl,
                name: profile.name,
                subtitle: _buildProfileSubtitle(
                  profile.groupName,
                ),
                onAvatarTap: () {
                  showAvatarPickerSheet(
                    context: context,
                    authProvider:
                    context.read<AuthProvider>(),
                    profileProvider: context
                        .read<StudentProfileProvider>(),
                  );
                },
              ),
              SizedBox(height: 32.h),
              ProfileChipSection(
                icon: Icons.book_outlined,
                title: 'Materias favoritas',
                items: profile.subjectsLiked,
                backgroundColor:
                const Color(0xFFE3F2FD),
                textColor: Colors.blue,
                emptyText:
                'Sin materias favoritas registradas',
              ),
              SizedBox(height: 24.h),
              ProfileChipSection(
                icon: Icons.block_outlined,
                title: 'Materias que no te gustan',
                items: profile.subjectsDisliked,
                backgroundColor:
                const Color(0xFFFFEBEE),
                textColor: Colors.redAccent,
                emptyText:
                'Sin materias registradas',
              ),
              SizedBox(height: 24.h),
              ProfileChipSection(
                icon: Icons.favorite_border,
                title: 'Intereses',
                items: profile.interests,
                backgroundColor:
                const Color(0xFFF3E5F5),
                textColor: Colors.purple,
                emptyText:
                'Sin intereses registrados',
              ),
              SizedBox(height: 24.h),
              ProfileChipSection(
                icon: Icons.lightbulb_outline,
                title: 'Habilidades',
                items: profile.skills,
                backgroundColor:
                const Color(0xFFE8F5E9),
                textColor: Colors.green,
                emptyText:
                'Sin habilidades registradas',
              ),
              SizedBox(height: 32.h),
              ProfilePreferencesRow(
                needsScholarship:
                profile.needsScholarship,
                studyAbroad: profile.studyAbroad,
              ),
              SizedBox(height: 32.h),
              VocationalClarityCard(
                clarity: profile.vocationalClarity,
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode ? const Color(0xFF1E1F38) : const Color(0xFFF5F6FC),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: themeProvider.isDarkMode ? const Color(0xFF2E305C) : const Color(0xFFECECF3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: themeProvider.isDarkMode ? Colors.amberAccent : const Color(0xFF311B92),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo Oscuro',
                            style: TextStyle(
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            themeProvider.isDarkMode ? 'Tema oscuro activado' : 'Tema claro activado',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: themeProvider.setDarkMode,
                      activeColor: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
              if (profileProvider.errorMessage != null) ...[
                SizedBox(height: 20.h),
                _ProfileErrorMessage(
                  message:
                  profileProvider.errorMessage!,
                ),
              ],
            ],
          ),
        ),
        if (authProvider.isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _buildProfileSubtitle(String? groupName) {
    final cleanGroupName = groupName?.trim();

    if (cleanGroupName != null &&
        cleanGroupName.isNotEmpty) {
      return 'Estudiante • $cleanGroupName';
    }

    return 'Estudiante • Sin grupo asignado';
  }
}

class _ProfileErrorMessage extends StatelessWidget {
  final String message;

  const _ProfileErrorMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.red.shade100,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}