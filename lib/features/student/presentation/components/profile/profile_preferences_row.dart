import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class ProfilePreferencesRow extends StatelessWidget {
  final bool needsScholarship;
  final bool studyAbroad;

  const ProfilePreferencesRow({
    super.key,
    required this.needsScholarship,
    required this.studyAbroad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PreferenceCard(
            icon: Icons.school_outlined,
            label: 'BECA',
            value: needsScholarship ? 'Sí necesita' : 'No necesita',
            color: Colors.purple,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _PreferenceCard(
            icon: Icons.flight_takeoff,
            label: 'EXTRANJERO',
            value: studyAbroad ? 'Le interesa' : 'No indicado',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _PreferenceCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 22.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}