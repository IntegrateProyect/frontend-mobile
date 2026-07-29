import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/university_announcement_entity.dart';

class UniversityAnnouncementCard extends StatelessWidget {
  final UniversityAnnouncementEntity announcement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UniversityAnnouncementCard({
    super.key,
    required this.announcement,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF1D1B4B);

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'becas':
      case 'beca':
        return Colors.green[600]!;
      case 'inscripción':
      case 'inscripcion':
        return Colors.blue[600]!;
      case 'convocatoria':
        return Colors.orange[700]!;
      default:
        return Colors.purple[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(announcement.category);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
              Image.network(
                announcement.imageUrl!,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
              ),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    announcement.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: catColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 20.sp),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem(value: 'delete', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: accentColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              announcement.description,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Publicado recientemente', // Aquí podrías poner la fecha real si existiera en la entidad
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[400], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    ]),
  ));}
}
