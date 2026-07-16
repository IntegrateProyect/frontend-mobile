import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../providers/counselor_provider.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({
    super.key,
  });

  @override
  State<CounselorHomeScreen> createState() {
    return _CounselorHomeScreenState();
  }
}

class _CounselorHomeScreenState
    extends State<CounselorHomeScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF17164A);
  static const Color _backgroundColor = Color(0xFFF8F9FE);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CounselorProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(provider),
      body: _buildBody(provider),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(
      CounselorProvider provider,
      ) {
    final int notificationCount = provider.consultations
        .where(
          (consultation) =>
      consultation.status.trim().toLowerCase() !=
          'responded',
    )
        .length;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 68.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Oriéntate+',
        style: TextStyle(
          color: _primaryColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 14.w),
          child: IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {
              _showNotificationsSheet(provider);
            },
            icon: Badge(
              isLabelVisible: notificationCount > 0,
              backgroundColor: Colors.redAccent,
              label: Text(
                notificationCount > 99
                    ? '99+'
                    : notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: Colors.grey.shade800,
                size: 27.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      CounselorProvider provider,
      ) {
    if (provider.isLoading &&
        provider.groups.isEmpty &&
        provider.appointments.isEmpty &&
        provider.consultations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: _primaryColor,
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab(provider);

      case 1:
        return _buildGroupsTab(provider);

      case 2:
        return _buildAgendaTab(provider);

      default:
        return _buildHomeTab(provider);
    }
  }

  // =========================================================
  // HOME
  // =========================================================

  Widget _buildHomeTab(
      CounselorProvider provider,
      ) {
    final upcomingAppointments = _getUpcomingAppointments(
      provider.appointments,
    );

    final AppointmentEntity? nextAppointment =
    upcomingAppointments.isNotEmpty
        ? upcomingAppointments.first
        : null;

    final pendingConsultations = provider.consultations
        .where(
          (consultation) =>
      consultation.status.trim().toLowerCase() !=
          'responded',
    )
        .toList();

    final StudentConsultationEntity? firstConsultation =
    pendingConsultations.isNotEmpty
        ? pendingConsultations.first
        : null;

    final int appointmentsToday = _appointmentsTodayCount(
      provider.appointments,
    );

    final int pendingCount =
        pendingConsultations.length +
            provider.lowProgressCount +
            provider.highIndecisionCount;

    final int resultsPending = provider.reportesCount;

    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: provider.loadDashboardData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              18.w,
              18.h,
              18.w,
              32.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildGreetingCard(),

                  SizedBox(height: 24.h),

                  _buildSectionTitle(
                    'Resumen general',
                  ),

                  SizedBox(height: 13.h),

                  _buildStatsGrid(
                    students: provider.totalStudentsCount,
                    groups: provider.groupsCount,
                    appointmentsToday: appointmentsToday,
                    pending: pendingCount,
                  ),

                  SizedBox(height: 26.h),

                  _buildSectionTitle('Hoy'),

                  SizedBox(height: 13.h),

                  _buildNextAppointmentCard(
                    provider: provider,
                    appointment: nextAppointment,
                  ),

                  SizedBox(height: 12.h),

                  _buildFollowUpCard(
                    provider: provider,
                    consultation: firstConsultation,
                    pendingCount: pendingConsultations.length,
                  ),

                  SizedBox(height: 26.h),

                  _buildSectionTitle(
                    'Pendientes de hoy',
                  ),

                  SizedBox(height: 13.h),

                  _buildPendingActionCard(
                    title: 'Expedientes por revisar',
                    subtitle: pendingConsultations.isNotEmpty
                        ? '${pendingConsultations.length} alumnos con alertas recientes'
                        : 'No hay alertas recientes',
                    value: pendingConsultations.length,
                    icon: Icons.manage_search_rounded,
                    mainColor: const Color(0xFF1687E8),
                    backgroundColor: const Color(0xFFEAF4FF),
                    onTap: () {
                      _showNotificationsSheet(provider);
                    },
                  ),

                  SizedBox(height: 12.h),

                  _buildPendingActionCard(
                    title: 'Resultados por revisar',
                    subtitle: resultsPending > 0
                        ? '$resultsPending resultados pendientes'
                        : 'Sin resultados pendientes',
                    value: resultsPending,
                    icon: Icons.bar_chart_rounded,
                    mainColor: const Color(0xFF159947),
                    backgroundColor: const Color(0xFFEAF8ED),
                    onTap: () {
                      _showResultsMessage(
                        resultsPending,
                      );
                    },
                  ),

                  SizedBox(height: 26.h),

                  _buildSectionTitle(
                    'Seguimiento prioritario',
                  ),

                  SizedBox(height: 13.h),

                  _buildPrioritySection(
                    provider,
                    pendingConsultations,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 17.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF6F4FF),
            Color(0xFFFCFBFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(23.r),
        border: Border.all(
          color: const Color(0xFFE7E1FF),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, orientador 👋',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Revisa lo más importante de hoy.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.assignment_turned_in_rounded,
              color: _primaryColor,
              size: 31.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid({
    required int students,
    required int groups,
    required int appointmentsToday,
    required int pending,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Alumnos',
                value: students,
                icon: Icons.people_outline_rounded,
                iconColor: const Color(0xFF168ED4),
                iconBackground: const Color(0xFFEAF6FD),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: _buildStatCard(
                title: 'Grupos',
                value: groups,
                icon: Icons.groups_rounded,
                iconColor: const Color(0xFF8D1BB3),
                iconBackground: const Color(0xFFF5EAFB),
              ),
            ),
          ],
        ),
        SizedBox(height: 11.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Citas hoy',
                value: appointmentsToday,
                icon: Icons.event_available_rounded,
                iconColor: const Color(0xFF7418B8),
                iconBackground: const Color(0xFFF2EAFB),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: _buildStatCard(
                title: 'Pendientes',
                value: pending,
                icon: Icons.pending_actions_rounded,
                iconColor: const Color(0xFFE38900),
                iconBackground: const Color(0xFFFFF3DC),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      height: 88.h,
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 10.8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard({
    required CounselorProvider provider,
    required AppointmentEntity? appointment,
  }) {
    final bool hasAppointment = appointment != null;

    final String studentName = hasAppointment
        ? _getStudentName(
      provider,
      appointment.studentId,
    )
        : '';

    final bool hasRealName = studentName.isNotEmpty &&
        studentName.toLowerCase() != 'alumno';

    final String title = hasAppointment
        ? hasRealName
        ? studentName
        : appointment.motive
        : 'Sin citas próximas';

    final String subtitle = hasAppointment
        ? hasRealName
        ? appointment.motive
        : 'Alumno por identificar'
        : 'No tienes citas programadas';

    final String date = hasAppointment
        ? DateFormat(
      'dd/MM/yyyy · hh:mm a',
    ).format(
      appointment.sessionDate,
    )
        : 'Tu agenda está disponible';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F6FF),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFFD9CFFF),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  color: _primaryColor,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próxima cita',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10.8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpCard({
    required CounselorProvider provider,
    required StudentConsultationEntity? consultation,
    required int pendingCount,
  }) {
    final bool hasConsultation = consultation != null;

    final String studentName = hasConsultation
        ? _resolveConsultationStudentName(
      provider,
      consultation,
    )
        : '';

    final String title = hasConsultation
        ? studentName.isNotEmpty &&
        studentName.toLowerCase() != 'alumno'
        ? studentName
        : 'Seguimiento requerido'
        : 'Todo está en orden';

    final String subtitle = hasConsultation
        ? consultation.message
        : 'No hay seguimientos pendientes';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasConsultation
            ? () {
          _openConsultationStudent(
            consultation,
          );
        }
            : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: hasConsultation
                ? const Color(0xFFFFFAF1)
                : const Color(0xFFF5FBF7),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: hasConsultation
                  ? const Color(0xFFF5D79B)
                  : const Color(0xFFCFE8D7),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: hasConsultation
                      ? const Color(0xFFFFF0D4)
                      : const Color(0xFFE6F6EB),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  hasConsultation
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: hasConsultation
                      ? const Color(0xFFE88A00)
                      : const Color(0xFF159947),
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hasConsultation
                                ? 'Seguimiento requerido'
                                : 'Seguimiento',
                            style: TextStyle(
                              color: hasConsultation
                                  ? const Color(0xFFE47F00)
                                  : const Color(0xFF159947),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (pendingCount > 0)
                          Container(
                            height: 25.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 25.w,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE9C0),
                              borderRadius:
                              BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              pendingCount.toString(),
                              style: TextStyle(
                                color: const Color(0xFFD87400),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10.5.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasConsultation) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 24.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingActionCard({
    required String title,
    required String subtitle,
    required int value,
    required IconData icon,
    required Color mainColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19.r),
            border: Border.all(
              color: mainColor.withOpacity(0.18),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 47.w,
                height: 47.w,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  icon,
                  color: mainColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10.5.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 9.w,
                ),
                constraints: BoxConstraints(
                  minWidth: 28.w,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 23.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySection(
      CounselorProvider provider,
      List<StudentConsultationEntity> consultations,
      ) {
    if (consultations.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21.r),
          border: Border.all(
            color: const Color(0xFFECECF3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8ED),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: const Color(0xFF159947),
                size: 26.sp,
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todo está en orden',
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'No hay alumnos que requieran atención inmediata.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10.8.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final visibleConsultations =
    consultations.take(3).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Column(
        children: List.generate(
          visibleConsultations.length,
              (index) {
            final consultation =
            visibleConsultations[index];

            final String studentName =
            _resolveConsultationStudentName(
              provider,
              consultation,
            );

            return Column(
              children: [
                _buildPriorityStudentRow(
                  studentName: studentName,
                  reason: consultation.message,
                  onTap: () {
                    _openConsultationStudent(
                      consultation,
                    );
                  },
                ),
                if (index !=
                    visibleConsultations.length - 1)
                  Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriorityStudentRow({
    required String studentName,
    required String reason,
    required VoidCallback onTap,
  }) {
    final String cleanName =
    studentName.trim().isNotEmpty
        ? studentName.trim()
        : 'Alumno';

    final String initial = cleanName
        .substring(0, 1)
        .toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor:
                _primaryColor.withOpacity(0.09),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10.5.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: _primaryColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // GRUPOS
  // =========================================================

  Widget _buildGroupsTab(
      CounselorProvider provider,
      ) {
    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: provider.loadDashboardData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              18.w,
              18.h,
              18.w,
              28.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Mis grupos',
                          style: TextStyle(
                            color: _darkText,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showCreateGroupDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14.r),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_rounded,
                        ),
                        label: const Text(
                          'Nuevo grupo',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  if (provider.groups.isEmpty)
                    _buildEmptyGroups()
                  else
                    ...provider.groups.map(
                          (rawGroup) {
                        if (rawGroup is! Map) {
                          return const SizedBox.shrink();
                        }

                        return _buildGroupCard(
                          Map<String, dynamic>.from(
                            rawGroup,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGroups() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 42.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes grupos creados',
            style: TextStyle(
              color: _darkText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Crea un grupo para comenzar a dar seguimiento a tus alumnos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
      Map<String, dynamic> group,
      ) {
    final String groupId =
    (group['id'] ?? '').toString();

    final String groupName =
    (group['name'] ?? 'Grupo sin nombre')
        .toString();

    final String accessCode =
    (group['accessCode'] ??
        group['access_code'] ??
        group['code'] ??
        '---')
        .toString();

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: groupId.isEmpty
              ? null
              : () {
            context.push(
              AppRoutes.groupStudents.path,
              extra: {
                'groupId': groupId,
                'groupName': groupName,
              },
            );
          },
          borderRadius: BorderRadius.circular(21.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color:
                    _primaryColor.withOpacity(0.09),
                    borderRadius:
                    BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.groups_rounded,
                    color: _primaryColor,
                    size: 27.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Código: $accessCode',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // AGENDA
  // =========================================================

  Widget _buildAgendaTab(
      CounselorProvider provider,
      ) {
    final appointments =
    List<AppointmentEntity>.from(
      provider.appointments,
    );

    appointments.sort(
          (a, b) => a.sessionDate.compareTo(
        b.sessionDate,
      ),
    );

    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: provider.loadDashboardData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              18.w,
              18.h,
              18.w,
              28.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'Agenda',
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  if (appointments.isEmpty)
                    _buildEmptyAgenda()
                  else
                    ...appointments.map(
                          (appointment) =>
                          _buildAppointmentCard(
                            provider,
                            appointment,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAgenda() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 42.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes citas programadas',
            style: TextStyle(
              color: _darkText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
      CounselorProvider provider,
      AppointmentEntity appointment,
      ) {
    final String studentName = _getStudentName(
      provider,
      appointment.studentId,
    );

    final String date = DateFormat(
      'dd/MM/yyyy · hh:mm a',
    ).format(
      appointment.sessionDate,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 13.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: _primaryColor,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  appointment.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // NAVEGACIÓN
  // =========================================================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey.shade400,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
      onTap: (index) {
        if (index == 3) {
          context.push(
            AppRoutes.chatContacts.path,
          );
          return;
        }

        if (index == 4) {
          context.push(
            AppRoutes.counselorProfile.path,
          );
          return;
        }

        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Grupos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
          ),
          label: 'Mensajes',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }

  // =========================================================
  // NOTIFICACIONES
  // =========================================================

  void _showNotificationsSheet(
      CounselorProvider provider,
      ) {
    final consultations = provider.consultations
        .where(
          (consultation) =>
      consultation.status.trim().toLowerCase() !=
          'responded',
    )
        .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (
          BuildContext bottomSheetContext,
          ) {
        return SizedBox(
          height: 0.72.sh,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20.w,
              18.h,
              20.w,
              24.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28.r),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                      BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Notificaciones',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: consultations.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons
                              .notifications_off_outlined,
                          color: Colors.grey.shade300,
                          size: 48.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No hay notificaciones pendientes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                            Colors.grey.shade600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    itemCount: consultations.length,
                    separatorBuilder: (_, __) {
                      return SizedBox(height: 10.h);
                    },
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final consultation =
                      consultations[index];

                      final String studentName =
                      consultation.studentName
                          .trim()
                          .isNotEmpty
                          ? consultation.studentName
                          .trim()
                          : 'Alumno';

                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          tileColor: const Color(
                            0xFFF8F7FD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              16.r,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                            _primaryColor
                                .withOpacity(0.1),
                            child: const Icon(
                              Icons
                                  .notification_important_outlined,
                              color: _primaryColor,
                            ),
                          ),
                          title: Text(
                            studentName,
                            style: const TextStyle(
                              color: _darkText,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            consultation.message,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                          ),
                          onTap: () {
                            Navigator.pop(
                              bottomSheetContext,
                            );

                            _openConsultationStudent(
                              consultation,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // CREAR GRUPO
  // =========================================================

  Future<void> _showCreateGroupDialog() async {
    final nameController = TextEditingController();
    final codeController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (
          BuildContext dialogContext,
          ) {
        bool submitting = false;

        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title: const Text(
                'Crear grupo',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del grupo',
                      prefixIcon: Icon(Icons.groups),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: codeController,
                    textCapitalization:
                    TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Código opcional',
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancelar',
                  ),
                ),
                ElevatedButton(
                  onPressed: submitting
                      ? null
                      : () async {
                    final String name =
                    nameController.text.trim();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ingresa el nombre del grupo.',
                          ),
                        ),
                      );
                      return;
                    }

                    setDialogState(() {
                      submitting = true;
                    });

                    final bool created = await context
                        .read<CounselorProvider>()
                        .createGroup(
                      name,
                      codeController.text,
                    );

                    if (!dialogContext.mounted) {
                      return;
                    }

                    if (created) {
                      Navigator.pop(dialogContext);
                    } else {
                      setDialogState(() {
                        submitting = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: submitting
                      ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child:
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    codeController.dispose();
  }

  // =========================================================
  // HELPERS
  // =========================================================

  Widget _buildSectionTitle(
      String title,
      ) {
    return Text(
      title,
      style: TextStyle(
        color: _darkText,
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
      ),
    );
  }

  List<AppointmentEntity> _getUpcomingAppointments(
      List<AppointmentEntity> appointments,
      ) {
    final DateTime now = DateTime.now();

    final upcoming = appointments
        .where(
          (appointment) =>
          appointment.sessionDate.isAfter(
            now.subtract(
              const Duration(minutes: 30),
            ),
          ),
    )
        .toList();

    upcoming.sort(
          (a, b) => a.sessionDate.compareTo(
        b.sessionDate,
      ),
    );

    return upcoming;
  }

  int _appointmentsTodayCount(
      List<AppointmentEntity> appointments,
      ) {
    final DateTime now = DateTime.now();

    return appointments.where(
          (appointment) {
        final date = appointment.sessionDate;

        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      },
    ).length;
  }

  String _getStudentName(
      CounselorProvider provider,
      String studentId,
      ) {
    for (final student in provider.students) {
      if (student.id.trim() == studentId.trim()) {
        final String name = student.name.trim();

        if (name.isNotEmpty &&
            name.toLowerCase() !=
                'alumno sin nombre' &&
            name.toLowerCase() != 'alumno') {
          return name;
        }
      }
    }

    return '';
  }

  String _resolveConsultationStudentName(
      CounselorProvider provider,
      StudentConsultationEntity consultation,
      ) {
    final String consultationName =
    consultation.studentName.trim();

    if (consultationName.isNotEmpty &&
        consultationName.toLowerCase() !=
            'alumno sin nombre' &&
        consultationName.toLowerCase() != 'alumno') {
      return consultationName;
    }

    return _getStudentName(
      provider,
      consultation.studentId,
    );
  }

  void _openConsultationStudent(
      StudentConsultationEntity consultation,
      ) {
    final String studentId =
    consultation.studentId.trim();

    if (studentId.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'La alerta no contiene un alumno válido.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    final String studentName =
    consultation.studentName.trim().isNotEmpty
        ? consultation.studentName.trim()
        : 'Alumno';

    context.push(
      AppRoutes.studentFile.path,
      extra: {
        'studentId': studentId,
        'studentName': studentName,
      },
    );
  }

  void _showResultsMessage(
      int resultsPending,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            resultsPending > 0
                ? 'Tienes $resultsPending resultados pendientes por revisar.'
                : 'No hay resultados pendientes.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}