import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../common/student_ui_colors.dart';
import 'appointment_booking_sheet.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mis Citas',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: StudentUiColors.darkText,
              ),
            ),
            TextButton.icon(
              onPressed: () => showAppointmentBookingSheet(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agendar'),
              style: TextButton.styleFrom(foregroundColor: StudentUiColors.primary),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (appointments.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey[300], size: 40.sp),
                SizedBox(height: 8.h),
                Text(
                  'No tienes citas programadas',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
                ),
              ],
            ),
          )
        else
          ...appointments.take(2).map((apt) => _buildAppointmentCard(apt)),
      ],
    );
  }

  Widget _buildAppointmentCard(AppointmentEntity apt) {
    final dateStr = DateFormat('EEEE d MMMM', 'es').format(apt.sessionDate);
    final timeStr = DateFormat('hh:mm a').format(apt.sessionDate);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: StudentUiColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.event, color: StudentUiColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apt.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: StudentUiColors.darkText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$dateStr • $timeStr',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getStatusColor(apt.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _getStatusLabel(apt.status),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(apt.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SCHEDULED': return Colors.blue;
      case 'COMPLETED': return Colors.green;
      case 'CANCELLED': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'SCHEDULED': return 'PENDIENTE';
      case 'COMPLETED': return 'COMPLETADA';
      case 'CANCELLED': return 'CANCELADA';
      default: return status;
    }
  }
}
