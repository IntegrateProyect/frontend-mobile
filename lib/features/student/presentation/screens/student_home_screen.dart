import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_group_required_dialog.dart';
import '../components/common/student_ui_colors.dart';
import '../components/home/career_recommendations_carousel.dart';
import '../components/home/quick_access_grid.dart'
as quick_access;
import '../components/home/student_account_sheet.dart'
as account_sheet;
import '../components/home/student_appointments_section.dart';
import '../components/home/student_greeting.dart';
import '../components/home/student_home_app_bar.dart';
import '../components/home/student_recommendations_card.dart';
import '../components/home/vocational_route_card.dart';
import '../providers/student_home_provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({
    super.key,
  });

  @override
  State<StudentHomeScreen> createState() {
    return _StudentHomeScreenState();
  }
}

class _StudentHomeScreenState
    extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context
          .read<StudentHomeProvider>()
          .loadHomeData();
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

  /// Comprueba si el estudiante pertenece a un grupo.
  ///
  /// Si no pertenece, muestra el diálogo para ingresar
  /// el código del grupo.
  Future<bool> _validateStudentGroup() async {
    final bool canContinue =
    await requireStudentGroup(
      context: context,
    );

    return canContinue && mounted;
  }

  Future<void> _openVocationalGames() async {
    final bool canContinue =
    await _validateStudentGroup();

    if (!canContinue || !mounted) return;

    context.push(
      AppRoutes.games.path,
    );
  }

  Future<void> _openChatbot() async {
    final bool canContinue =
    await _validateStudentGroup();

    if (!canContinue || !mounted) return;

    final StudentHomeProvider provider =
    context.read<StudentHomeProvider>();

    // Guarda que este estudiante ya utilizó el chatbot.
    await provider.markChatbotInteraction();

    if (!mounted) return;

    context.push(
      AppRoutes.chat.path,
    );
  }

  Future<void> _openResults() async {
    final bool canContinue =
    await _validateStudentGroup();

    if (!canContinue || !mounted) return;

    final StudentHomeProvider provider =
    context.read<StudentHomeProvider>();

    if (provider.hasVocationalResults) {
      context.push(
        AppRoutes.vocationalResults.path,
      );
      return;
    }

    await _showResultsInformation();
  }

  Future<void> _openMessages() async {
    final bool canContinue =
    await _validateStudentGroup();

    if (!canContinue || !mounted) return;

    context.push(
      AppRoutes.chatContacts.path,
    );
  }

  Future<void> _showResultsInformation() async {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: isDark
          ? const Color(0xFF1A1B2E)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      builder: (bottomSheetContext) {
        final Color titleColor = isDark
            ? Colors.white
            : StudentUiColors.darkText;

        final Color secondaryColor = isDark
            ? Colors.grey.shade400
            : Colors.grey.shade600;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            4.h,
            24.w,
            28.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF282443)
                      : const Color(0xFFF0EEFA),
                  borderRadius:
                  BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: isDark
                      ? const Color(0xFFB59AFF)
                      : const Color(0xFF756EB2),
                  size: 40.sp,
                ),
              ),

              SizedBox(height: 18.h),

              Text(
                'Resultados vocacionales',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                'Tus resultados se desbloquearán cuando '
                    'completes todos los minijuegos vocacionales.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 22.h),

              _buildResultInfoItem(
                context: bottomSheetContext,
                number: '1',
                text:
                'Completa todos los minijuegos disponibles.',
              ),

              SizedBox(height: 10.h),

              _buildResultInfoItem(
                context: bottomSheetContext,
                number: '2',
                text:
                'Obtendrás tus áreas de afinidad y carreras sugeridas.',
              ),

              SizedBox(height: 22.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    StudentUiColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize:
                    Size.fromHeight(52.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16.r),
                    ),
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultInfoItem({
    required BuildContext context,
    required String number,
    required String text,
  }) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF242539)
            : const Color(0xFFF8F8FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13.r,
            backgroundColor: isDark
                ? const Color(0xFF34304E)
                : const Color(0xFFEDEDF3),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 10.sp,
                color: isDark
                    ? Colors.white
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : StudentUiColors.darkText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StudentHomeProvider provider =
    context.watch<StudentHomeProvider>();

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1020)
          : StudentUiColors.background,

      appBar: StudentHomeAppBar(
        onNotificationsPressed: () {
          _showMessage(
            'Notificaciones próximamente',
          );
        },
        onAccountPressed: () {
          account_sheet.showStudentAccountSheet(
            context: context,
            homeProvider: provider,
            authProvider:
            context.read<AuthProvider>(),
          );
        },
      ),

      body: _buildBody(
        provider: provider,
      ),

      floatingActionButton:
      FloatingActionButton(
        backgroundColor: StudentUiColors.teal,
        foregroundColor: Colors.white,
        elevation: 8,
        onPressed: _openChatbot,
        child: const Icon(
          Icons.smart_toy_rounded,
        ),
      ),

      bottomNavigationBar:
      const StudentBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildBody({
    required StudentHomeProvider provider,
  }) {
    if (provider.isLoading &&
        provider.profile == null) {
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
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          30.h,
        ),
        children: [
          StudentGreeting(
            name: provider.firstName,
            groupName: provider.hasGroup
                ? provider.currentGroupName
                : null,
            counselorName:
            provider.hasGroup
                ? provider.currentCounselorName
                : null,
          ),

          SizedBox(height: 18.h),

          VocationalRouteCard(
            hasGroup: provider.hasGroup,
            gamesStarted:
            provider.hasStartedGames,
            gamesCompleted:
            provider.hasCompletedGames,
            chatbotCompleted:
            provider.hasChatbotInteraction,
            resultsCompleted:
            provider.hasVocationalResults,
            onGamesTap: _openVocationalGames,
            onChatTap: _openChatbot,
            onResultsTap: _openResults,
          ),

          SizedBox(height: 20.h),

          StudentRecommendationsCard(
            onUniversitiesTap: () {
              context.push(
                AppRoutes.universities.path,
              );
            },
          ),

          SizedBox(height: 20.h),

          StudentAppointmentsSection(
            appointments: provider.hasGroup
                ? provider.appointments
                : const [],
            onRefresh: provider.loadHomeData,
          ),

          SizedBox(height: 20.h),

          const CareerRecommendationsCarousel(),

          SizedBox(height: 20.h),

          quick_access.QuickAccessGrid(
            onMessagesTap: _openMessages,
            onCareersTap: () {
              context.push(
                AppRoutes.careers.path,
              );
            },
            onUniversitiesTap: () {
              context.push(
                AppRoutes.universities.path,
              );
            },
            onEventsTap: () {
              context.push(
                AppRoutes.events.path,
              );
            },
          ),

          if (provider.errorMessage != null) ...[
            SizedBox(height: 20.h),
            _HomeErrorMessage(
              message: provider.errorMessage!,
              onRetry: provider.loadHomeData,
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeErrorMessage extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _HomeErrorMessage({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF3A2026)
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF74343F)
              : Colors.red.shade100,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark
                    ? Colors.red.shade200
                    : Colors.red.shade700,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          IconButton(
            tooltip: 'Reintentar',
            onPressed: () {
              onRetry();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}