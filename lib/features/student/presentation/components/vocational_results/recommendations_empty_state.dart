import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationsEmptyState extends StatelessWidget {
  final VoidCallback onGenerate;

  const RecommendationsEmptyState({
    super.key,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 42.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 10.h),
            Text(
              'Todavía no hay recomendaciones disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 10.h),
            TextButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar recomendaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
