import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VocationalClarityCard extends StatelessWidget {
  final int clarity;

  const VocationalClarityCard({
    super.key,
    required this.clarity,
  });

  int get safeClarity {
    return clarity.clamp(1, 10).toInt();
  }

  String get label {
    if (safeClarity >= 7) return 'Alta';
    if (safeClarity >= 4) return 'Media';

    return 'Baja';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1A47),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Claridad vocacional',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: safeClarity / 10,
              minHeight: 12.h,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '$safeClarity / 10',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}