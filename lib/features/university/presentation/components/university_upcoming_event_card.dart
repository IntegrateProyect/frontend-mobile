import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../providers/university_events_provider.dart';

class UniversityUpcomingEventCard extends StatelessWidget {
  final UniversityEventsProvider provider;

  const UniversityUpcomingEventCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    if (provider.isLoading) {
      return SizedBox(
        height: 60.h,
        child: const Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    final events = provider.events;

    if (events.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_busy_rounded, color: Colors.grey, size: 24),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sin eventos programados',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp)),
                  Text('Publica ferias para conectar.',
                      style: TextStyle(color: Colors.grey, fontSize: 9.5.sp)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.manageEvents.path),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
              child: Text('Crear',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }

    final upcomingEvent = events.first;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12.r)),
            child: const Icon(Icons.event_note_rounded,
                color: Color(0xFF16A34A), size: 20),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upcomingEvent.title,
                  style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 1.1),
                ),
                SizedBox(height: 2.h),
                Text(
                  DateFormat("d 'de' MMMM, y — h:mm a", 'es')
                      .format(upcomingEvent.date),
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_available_outlined,
                          size: 10, color: Color(0xFF16A34A)),
                      SizedBox(width: 4.w),
                      Text(
                        'Evento Publicado',
                        style: TextStyle(
                            fontSize: 8.5.sp,
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
