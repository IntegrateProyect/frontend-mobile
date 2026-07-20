import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversityReachSummary extends StatelessWidget {
  final int alumniCount;
  final int careersCount;
  final int eventsCount;

  const UniversityReachSummary({
    super.key,
    required this.alumniCount,
    required this.careersCount,
    required this.eventsCount,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);

    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            alumniCount.toString(),
            'Egresados',
            Icons.people_alt_rounded,
            const Color(0xFF8B5CF6),
            accentColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildKpiCard(
            careersCount.toString(),
            'Carreras',
            Icons.school_rounded,
            const Color(0xFF3B82F6),
            accentColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildKpiCard(
            eventsCount.toString(),
            'Eventos',
            Icons.event_available_rounded,
            const Color(0xFF10B981),
            accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    String value,
    String label,
    IconData icon,
    Color color,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: accentColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
