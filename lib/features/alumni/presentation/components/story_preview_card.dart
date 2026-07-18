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
  static const Color accentColor = Color(0xFF6A4CFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.remove_red_eye_outlined, color: Colors.grey, size: 16),
              SizedBox(width: 8.w),
              Text(
                'VISTA PREVIA EN TIEMPO REAL',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryColor, accentColor]),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Center(child: Icon(Icons.person, color: Colors.white, size: 20)),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  Text(
                    '$major • $year',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            title.isEmpty ? 'Tu Título' : title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            story.isEmpty 
              ? 'El contenido de tu historia aparecerá aquí...' 
              : story,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13.sp,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
