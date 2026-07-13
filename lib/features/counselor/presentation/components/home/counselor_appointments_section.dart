import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../student/domain/entities/appointment_entity.dart';

class CounselorAppointmentsSection extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final VoidCallback onSeeAll;

  const CounselorAppointmentsSection({
    super.key,
    required this.appointments,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    
    // Sort and filter upcoming appointments
    final upcoming = appointments
        .where((a) => a.sessionDate.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
        .toList()
      ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Próximas Citas',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1D1B4B),
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'Ver Agenda',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (upcoming.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey[300], size: 32.sp),
                SizedBox(height: 10.h),
                Text(
                  'No hay citas próximas agendadas',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                ),
              ],
            ),
          )
        else
          ...upcoming.take(3).map((apt) => _buildAppointmentItem(apt, primaryColor)),
      ],
    );
  }

  Widget _buildAppointmentItem(AppointmentEntity apt, Color primaryColor) {
    final dateStr = DateFormat('MMM d, hh:mm a').format(apt.sessionDate);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.event_available, color: primaryColor, size: 20.sp),
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
                    color: const Color(0xFF1D1B4B),
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[300], size: 20.sp),
        ],
      ),
    );
  }
}
