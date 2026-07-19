import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversityHomeHeader extends StatelessWidget {
  final String? name;
  final String? description;
  final int careersCount;
  final int eventsCount;

  const UniversityHomeHeader({
    super.key,
    this.name,
    this.description,
    required this.careersCount,
    required this.eventsCount,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_rounded, size: 48.sp, color: primaryColor),
            ),
            SizedBox(height: 20.h),
            Text(
              name ?? 'Cargando universidad...',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description ?? 'Portal Institucional',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Carreras', '$careersCount'),
                  Container(width: 1, height: 30.h, color: Colors.grey[300]),
                  _buildStat('Eventos', '$eventsCount'),
                  Container(width: 1, height: 30.h, color: Colors.grey[300]),
                  _buildStat('Estatus', 'VINCULADO'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: Colors.grey[500],
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
