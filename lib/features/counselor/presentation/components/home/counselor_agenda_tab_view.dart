import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../providers/counselor_provider.dart';
import 'counselor_weekly_calendar.dart';

class CounselorAgendaTabView extends StatelessWidget {
  final CounselorProvider provider;
  final VoidCallback onNewAppointment;
  final VoidCallback onEditAvailability;
  final String Function(String studentId) getStudentName;

  const CounselorAgendaTabView({
    super.key,
    required this.provider,
    required this.onNewAppointment,
    required this.onEditAvailability,
    required this.getStudentName,
  });

  static const _primary = Color(0xFF311B92);
  static const _dark = Color(0xFF17164A);

  @override
  Widget build(BuildContext context) {
    final appointments = List<AppointmentEntity>.from(provider.appointments)
      ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));

    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-agenda-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 30.h),
        children: [
          _pageHeader(
            'Agenda',
            '${appointments.length} citas registradas',
            'Nueva cita',
            Icons.add_rounded,
            onNewAppointment,
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            onPressed: onEditAvailability,
            icon: const Icon(Icons.schedule_rounded),
            label: Text(
              provider.availability.isEmpty
                  ? 'Configurar disponibilidad'
                  : '${provider.availability.length} bloques disponibles',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primary,
              minimumSize: Size.fromHeight(48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          CounselorWeeklyCalendar(
            appointments: appointments,
            availability: provider.availability,
            studentName: getStudentName,
            onSchedule: onNewAppointment,
          ),
        ],
      ),
    );
  }

  Widget _pageHeader(
    String title,
    String subtitle,
    String button,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _dark,
            fontSize: 23.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10.5.sp,
          ),
        ),
        SizedBox(height: 13.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            icon: Icon(icon),
            label: Text(
              button,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
