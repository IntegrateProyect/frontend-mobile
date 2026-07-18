import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlumniStoryCard extends StatelessWidget {
  final Map<String, String> story;
  final VoidCallback? onTap;

  const AlumniStoryCard({
    super.key,
    required this.story,
    this.onTap,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF6A4CFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryColor, accentColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            story['name'] != null && story['name']!.isNotEmpty 
                                ? story['name']![0].toUpperCase() 
                                : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story['name'] ?? 'Egresado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: const Color(0xFF1D1B4B),
                              ),
                            ),
                            Text(
                              '${story['major'] ?? ''} • Clase ${story['year'] ?? ''}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.format_quote_rounded, 
                        color: primaryColor.withOpacity(0.1), 
                        size: 40.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    story['title'] ?? 'Historia de Éxito',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    story['story'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
