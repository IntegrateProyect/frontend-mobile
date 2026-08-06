import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../responsive.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoading) {
      return SizedBox(
        height: 80.h,
        child: const Center(child: CircularProgressIndicator(color: primaryColor, strokeWidth: 1.5)),
      );
    }

    final alumniList = provider.alumni;

    if (alumniList.isEmpty) {
      return Container(
        height: 60.h,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F38) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFF1F5F9)),
        ),
        child: Center(
          child: Text('Sin egresados',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10.sp, color: isDark ? Colors.white70 : accentColor)),
        ),
      );
    }

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: alumniList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final alumni = alumniList[index];
          final String name = alumni.name.isNotEmpty ? alumni.name : 'Egresado';
          final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'E';

          return Container(
            width: 180,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1F38) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: isDark ? primaryColor.withOpacity(0.18) : primaryColor.withOpacity(0.08),
                      child: Text(initial,
                          style: TextStyle(
                              color: isDark ? const Color(0xFFB59AFF) : primaryColor,
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
                                  color: isDark ? Colors.white : accentColor,
                                  height: 1.1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text('Clase ${alumni.graduationYear}',
                              style: TextStyle(
                                  fontSize: 8.5.sp,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey[400],
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    alumni.currentJob,
                    style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white70 : accentColor,
                        height: 1.1),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    alumni.company,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark ? const Color(0xFFB59AFF) : primaryColor,
                        fontWeight: FontWeight.w900,
                        height: 1.1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
