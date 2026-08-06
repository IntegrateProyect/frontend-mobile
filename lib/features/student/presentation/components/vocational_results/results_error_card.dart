import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultsErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ResultsErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A2026) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF74343F) : Colors.red.shade100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isDark ? Colors.red.shade200 : Colors.red.shade700,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            label: const Text('Reintentar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
