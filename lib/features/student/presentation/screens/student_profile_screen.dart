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
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Regresar al inicio',
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: _goToStudentHome,
          ),
          title: const Text(
            'Perfil Vocacional',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(
          profileProvider: profileProvider,
          authProvider: authProvider,
          avatarUrl: avatarUrl,
        ),
        bottomNavigationBar:
        const StudentBottomNavigationBar(
          currentIndex: 3,
        ),
      ),
    );
  }

  Widget _buildBody({
    required StudentProfileProvider profileProvider,
    required AuthProvider authProvider,
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