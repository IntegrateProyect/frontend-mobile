import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../counselor/domain/entities/appointment_entity.dart';
import '../common/student_ui_colors.dart';

class StudentAppointmentsSection extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final VoidCallback onRefresh;

  const StudentAppointmentsSection({
    super.key,
    required this.appointments,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis citas',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : StudentUiColors.darkText,
          ),
        ),
        SizedBox(height: 12.h),

        if (appointments.isEmpty)
          _buildEmptyAppointments(context)
        else
          ...appointments
              .take(3)
              .map(
                (appointment) => _buildAppointmentCard(context, appointment),
          ),
      ],
    );
  }

  Widget _buildEmptyAppointments(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 22.w,
        vertical: 22.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECEEF4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: isDark ? StudentUiColors.primary.withOpacity(0.18) : StudentUiColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary.withOpacity(0.55),
              size: 29.sp,
            ),
          ),
          SizedBox(height: 13.h),
          Text(
            'Aquí aparecerán las citas con tu orientador',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : StudentUiColors.darkText,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Por ahora no tienes ninguna.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentEntity appointment) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String dateText = DateFormat(
      'EEEE d MMMM',
      'es',
    ).format(appointment.sessionDate);

    final String timeText = DateFormat(
      'hh:mm a',
      'es',
    ).format(appointment.sessionDate);

    final Color statusColor = _getStatusColor(
      appointment.status,
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECEEF4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              color: isDark ? StudentUiColors.primary.withOpacity(0.18) : StudentUiColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.event_outlined,
              color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
              size: 23.sp,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5.sp,
                    color: isDark ? Colors.white : StudentUiColors.darkText,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14.sp,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '$dateText • $timeText',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(isDark ? 0.20 : 0.10),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _getStatusLabel(appointment.status),
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'SCHEDULED':
        return Colors.blue;

      case 'COMPLETED':
        return Colors.green;

      case 'CANCELLED':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'SCHEDULED':
        return 'PENDIENTE';

      case 'COMPLETED':
        return 'COMPLETADA';

      case 'CANCELLED':
        return 'CANCELADA';

      default:
        return status.toUpperCase();
    }
  }
}