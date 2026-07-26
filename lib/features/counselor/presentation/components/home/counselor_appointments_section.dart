import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/appointment_entity.dart';

class CounselorAppointmentsSection
    extends StatelessWidget {
  static const Color _primaryColor =
  Color(0xFF311B92);

  static const Color _darkText =
  Color(0xFF1D1B4B);

  final List<AppointmentEntity> appointments;
  final VoidCallback onSeeAll;
  final VoidCallback? onSchedule;

  const CounselorAppointmentsSection({
    super.key,
    required this.appointments,
    required this.onSeeAll,
    this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    final List<AppointmentEntity> upcoming =
    appointments.where((appointment) {
      final String status =
      appointment.status.toUpperCase();

      return appointment.sessionDate
          .toLocal()
          .isAfter(
        now.subtract(
          const Duration(minutes: 30),
        ),
      ) &&
          status != 'CANCELLED';
    }).toList()
      ..sort((first, second) {
        return first.sessionDate.compareTo(
          second.sessionDate,
        );
      });

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Próximas citas',
                style: TextStyle(
                  color: _darkText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'Ver agenda',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (upcoming.isEmpty)
          _buildEmptyState()
        else
          ...upcoming.take(3).map(
            _buildAppointmentCard,
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              color: _primaryColor,
              size: 27.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'No hay citas próximas',
            style: TextStyle(
              color: _darkText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Tu agenda se encuentra disponible.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11.sp,
            ),
          ),
          if (onSchedule != null) ...[
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: onSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(13.r),
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Programar cita',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
      AppointmentEntity appointment,
      ) {
    final DateTime localDate =
    appointment.sessionDate.toLocal();

    final String date =
    DateFormat(
      "EEEE d 'de' MMMM · hh:mm a",
      'es_MX',
    ).format(localDate);

    final String status =
    appointment.status.toUpperCase();

    final bool confirmed =
        status == 'CONFIRMED' ||
            status == 'COMPLETED';

    final Color statusColor = confirmed
        ? const Color(0xFF159947)
        : const Color(0xFFF59E0B);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
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
              color: _primaryColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(15.r),
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
                  appointment.motive.trim().isEmpty
                      ? 'Sesión de orientación'
                      : appointment.motive,
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
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius:
                    BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
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
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'CONFIRMED':
        return 'Confirmada';

      case 'COMPLETED':
        return 'Completada';

      case 'CANCELLED':
        return 'Cancelada';

      case 'SCHEDULED':
      default:
        return 'Programada';
    }
  }
}