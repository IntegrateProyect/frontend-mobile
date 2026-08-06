import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../responsive.dart';

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
            context,
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
            context,
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
            context,
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
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
    Color accentColor,
  ) {
    // Tamaños ajustados para evitar el sobre-escalado y desbordamiento
    final double iconSize = context.responsiveValue(mobile: 14.sp, tablet: 16.sp, desktop: 18.sp);
    final double valueSize = context.responsiveValue(mobile: 14.sp, tablet: 16.sp, desktop: 18.sp);
    final double labelSize = context.responsiveValue(mobile: 8.5.sp, tablet: 9.5.sp, desktop: 10.5.sp);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: iconSize,
          ),
          SizedBox(height: 6.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.w900,
                color: accentColor,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: labelSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
