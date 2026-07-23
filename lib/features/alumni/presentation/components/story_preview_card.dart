import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryPreviewCard extends StatelessWidget {
  final String name;
  final String major;
  final String year;
  final String title;
  final String story;

  const StoryPreviewCard({
    super.key,
    required this.name,
    required this.major,
    required this.year,
    required this.title,
    required this.story,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de Vista Previa
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_red_eye_rounded, color: primaryColor.withOpacity(0.5), size: 14.sp),
                SizedBox(width: 8.w),
                Text(
                  'VISTA PREVIA EN TIEMPO REAL',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    color: primaryColor.withOpacity(0.6),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar con Gradiente
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryColor, accentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.w900, 
                              fontSize: 15.sp, 
                              color: const Color(0xFF1D1B4B),
                              letterSpacing: -0.4
                            ),
                          ),
                          Text(
                            '$major • Clase $year',
                            style: TextStyle(
                              color: Colors.grey[400], 
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.1
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.format_quote_rounded, color: primaryColor.withOpacity(0.06), size: 32.sp),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  title.isEmpty ? 'Tu Título aparecerá aquí' : title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5.sp,
                    color: primaryColor,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  story.isEmpty 
                    ? 'El contenido de tu historia aparecerá aquí mientras escribes...' 
                    : story,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.5.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
