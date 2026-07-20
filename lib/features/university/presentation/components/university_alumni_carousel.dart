import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/university_alumni_provider.dart';

class UniversityAlumniCarousel extends StatelessWidget {
  final UniversityAlumniProvider provider;

  const UniversityAlumniCarousel({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    if (provider.isLoading) {
      return SizedBox(
        height: 100.h,
        child: const Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    final alumniList = provider.alumni;

    if (alumniList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Icon(Icons.badge_outlined, color: Colors.purple.shade200, size: 24),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sin egresados registrados',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp)),
                  Text('Registra a tus egresados destacados.',
                      style: TextStyle(color: Colors.grey, fontSize: 9.5.sp)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: alumniList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final alumni = alumniList[index];
          final String name = alumni.name.isNotEmpty ? alumni.name : 'Egresado';
          final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'E';

          return Container(
            width: 190.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: primaryColor.withOpacity(0.08),
                      child: Text(initial,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp)),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w900,
                                  color: accentColor,
                                  height: 1.1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text('Clase ${alumni.graduationYear}',
                              style: TextStyle(
                                  fontSize: 8.5.sp,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  alumni.currentJob,
                  style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: accentColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  alumni.company,
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
