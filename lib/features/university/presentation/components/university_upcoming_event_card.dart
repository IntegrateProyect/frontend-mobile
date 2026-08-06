import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../responsive.dart';
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
      return Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: const Center(child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2)),
      );
    }

    final events = provider.events;

    if (events.isEmpty) {
      return Container(
        // Padding horizontal mínimo para evitar desbordamiento por redondeo de píxeles
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_busy_rounded, color: Colors.grey, size: 14.sp),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sin eventos programados',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 9.sp,
                        color: accentColor,
                        height: 1.1,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Publica ferias para conectar.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            TextButton(
              onPressed: () => context.push(AppRoutes.manageEvents.path),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                backgroundColor: primaryColor.withValues(alpha: 0.05),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
              ),
              child: Text(
                'Crear',
                style: TextStyle(fontSize: 8.5.sp, fontWeight: FontWeight.w900),
              ),
            )
          ],
        ),
      );
    }

    final upcomingEvent = events.first;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.event_note_rounded,
                    color: const Color(0xFF16A34A), size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        upcomingEvent.title,
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                            height: 1.1),
                      ),
                    ),
                    Text(
                      DateFormat("d 'de' MMMM, y — h:mm a", 'es')
                          .format(upcomingEvent.date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 8.5.sp,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 8.sp, color: const Color(0xFF16A34A)),
                    SizedBox(width: 4.w),
                    Text(
                      'ACTIVO',
                      style: TextStyle(
                          fontSize: 7.5.sp,
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.manageEvents.path),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Ver Detalles',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
