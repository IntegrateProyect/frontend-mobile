import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/student_consultation_entity.dart';
import '../../providers/counselor_provider.dart';
import 'counselor_home_shared_widgets.dart';

class CounselorHomeTabView extends StatelessWidget {
  final CounselorProvider provider;
  final AppointmentEntity? nextAppointment;
  final List<StudentConsultationEntity> pendingConsultations;
  final String nextAppointmentStudentName;
  final int todayAppointmentsCount;
  final VoidCallback onNewGroup;
  final VoidCallback onNewAppointment;
  final VoidCallback onEditAvailability;
  final VoidCallback onNotificationsPressed;
  final VoidCallback onViewAgenda;
  final VoidCallback onViewGroups;
  final VoidCallback onViewStudents;
  final Function(String studentId, String studentName) onStudentFileTap;

  const CounselorHomeTabView({
    super.key,
    required this.provider,
    required this.nextAppointment,
    required this.pendingConsultations,
    required this.nextAppointmentStudentName,
    required this.todayAppointmentsCount,
    required this.onNewGroup,
    required this.onNewAppointment,
    required this.onEditAvailability,
    required this.onNotificationsPressed,
    required this.onViewAgenda,
    required this.onViewGroups,
    required this.onViewStudents,
    required this.onStudentFileTap,
  });

  static const _primary = Color(0xFF311B92);
  static const _secondary = Color(0xFF6847D6);
  static const _dark = Color(0xFF17164A);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-home-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 32.h),
        children: [
          _hero(),
          SizedBox(height: 18.h),
          _quickActions(),
          SizedBox(height: 25.h),
          const CounselorSectionHeader(
            title: 'Resumen',
            subtitle: 'Actividad de tus grupos',
          ),
          SizedBox(height: 12.h),
          _metrics(),
          SizedBox(height: 25.h),
          CounselorSectionHeader(
            title: 'Tu día',
            subtitle: DateFormat(
              "EEEE d 'de' MMMM",
              'es_MX',
            ).format(DateTime.now()),
          ),
          SizedBox(height: 12.h),
          _nextAppointmentWidget(),
          SizedBox(height: 25.h),
          CounselorSectionHeader(
            title: 'Seguimiento prioritario',
            subtitle: pendingConsultations.isEmpty
                ? 'No hay casos pendientes'
                : '${pendingConsultations.length} ${pendingConsultations.length == 1 ? 'alumno requiere' : 'alumnos requieren'} atención',
          ),
          SizedBox(height: 12.h),
          _priorityList(),
        ],
      ),
    );
  }

  Widget _hero() {
    final name = provider.profile?.name.trim() ?? '';
    final firstName =
    name.isEmpty ? 'orientador' : name.split(RegExp(r'\s+')).first;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primary, _secondary],
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(.22),
            blurRadius: 24,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $firstName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Acompaña, organiza y da seguimiento a tus estudiantes.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.82),
                    fontSize: 11.5.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.groups_2_outlined,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${provider.totalStudentsCount} alumnos activos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(23.r),
              border: Border.all(
                color: Colors.white.withOpacity(.18),
              ),
            ),
            child: Icon(
              Icons.assignment_turned_in_rounded,
              color: Colors.white,
              size: 39.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.add_rounded,
            label: 'Nuevo grupo',
            color: _primary,
            onTap: onNewGroup,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _actionButton(
            icon: Icons.event_available_rounded,
            label: 'Nueva cita',
            color: const Color(0xFF1597D4),
            onTap: onNewAppointment,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _actionButton(
            icon: Icons.schedule_rounded,
            label: 'Horario',
            color: const Color(0xFF159947),
            onTap: onEditAvailability,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(color: color.withOpacity(.1)),
          ),
          child: Column(
            children: [
              Container(
                width: 37.w,
                height: 37.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 21.sp),
              ),
              SizedBox(height: 7.h),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: _dark,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metrics() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Row(
        children: [
          _metric(
            value: provider.totalStudentsCount,
            label: 'Alumnos',
            icon: Icons.people_alt_outlined,
            color: const Color(0xFF1597D4),
            onTap: onViewStudents,
          ),
          _metricDivider(),
          _metric(
            value: provider.groupsCount,
            label: 'Grupos',
            icon: Icons.groups_2_outlined,
            color: const Color(0xFF9C27B0),
            onTap: onViewGroups,
          ),
          _metricDivider(),
          _metric(
            value: todayAppointmentsCount,
            label: 'Citas hoy',
            icon: Icons.event_outlined,
            color: _primary,
            onTap: onViewAgenda,
          ),
          _metricDivider(),
          _metric(
            value: pendingConsultations.length,
            label: 'Pendientes',
            icon: Icons.notifications_active_outlined,
            color: const Color(0xFFF59E0B),
            onTap: onNotificationsPressed,
          ),
        ],
      ),
    );
  }

  Widget _metric({
    required int value,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: [
                Icon(icon, color: color, size: 21.sp),
                SizedBox(height: 5.h),
                Text(
                  '$value',
                  style: TextStyle(
                    color: _dark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 8.5.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricDivider() => Container(
    width: 1,
    height: 53.h,
    color: const Color(0xFFECECF3),
  );

  Widget _nextAppointmentWidget() {
    if (nextAppointment == null) {
      return CounselorEmptyFocusCard(
        icon: Icons.edit_calendar_outlined,
        color: _primary,
        title: 'Tu agenda está libre',
        subtitle: 'Programa una sesión con uno de tus alumnos.',
        button: 'Agendar cita',
        onTap: onNewAppointment,
      );
    }

    final date = DateFormat(
      "EEEE d 'de' MMMM · hh:mm a",
      'es_MX',
    ).format(nextAppointment!.sessionDate.toLocal());

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: _primary.withOpacity(.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: _primary.withOpacity(.09),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: _primary,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima cita',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  nextAppointmentStudentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _dark,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  nextAppointment!.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onViewAgenda,
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }

  Widget _priorityList() {
    if (pendingConsultations.isEmpty) {
      return const CounselorEmptyFocusCard(
        icon: Icons.verified_rounded,
        color: Color(0xFF159947),
        title: 'Todo está al día',
        subtitle: 'No hay alumnos que requieran atención inmediata.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Column(
        children: List.generate(
          pendingConsultations.take(3).length,
              (index) {
            final item = pendingConsultations[index];
            final name = _getConsultationName(item);
            return Column(
              children: [
                ListTile(
                  onTap: () => onStudentFileTap(item.studentId, name),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFF4E5),
                    child: Icon(
                      Icons.priority_high_rounded,
                      color: Color(0xFFE18400),
                    ),
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _dark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                if (index < pendingConsultations.take(3).length - 1)
                  const Divider(height: 1, indent: 70),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getConsultationName(StudentConsultationEntity item) {
    if (item.studentName.trim().isNotEmpty) return item.studentName.trim();
    for (final student in provider.students) {
      if (student.id == item.studentId) {
        return student.name.trim().isEmpty ? 'Alumno' : student.name.trim();
      }
    }
    return 'Alumno';
  }
}