import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/university_alumni_entity.dart';

class UniversityAlumniCard extends StatelessWidget {
  final UniversityAlumniEntity alumni;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final EdgeInsetsGeometry? margin;

  const UniversityAlumniCard({
    super.key,
    required this.alumni,
    required this.onEdit,
    required this.onDelete,
    this.margin,
  });

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  child: Text(
                    alumni.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alumni.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: _accentColor,
                        ),
                      ),
                      Text(
                        alumni.email,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                  },
                  icon: Icon(Icons.more_vert_rounded, color: Colors.grey[400]),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem(value: 'delete', child: Text('Eliminar', style: TextStyle(color: Colors.redAccent))),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              children: [
                _buildChip(Icons.school_outlined, alumni.careerName ?? 'Carrera'),
                _buildChip(Icons.calendar_today_outlined, alumni.graduationYear.toString()),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.business_center_rounded, size: 16.sp, color: _primaryColor),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      '${alumni.currentJob} en ${alumni.company}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: _accentColor,
                      ),
                    ),
                  ),
                  if (alumni.linkedinUrl != null && alumni.linkedinUrl!.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.link_rounded, color: _primaryColor, size: 20.sp),
                      onPressed: () => launchUrl(Uri.parse(alumni.linkedinUrl!)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: _primaryColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
