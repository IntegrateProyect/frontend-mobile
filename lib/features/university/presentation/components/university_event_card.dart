import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/university_event_entity.dart';

class UniversityEventCard extends StatelessWidget {
  final UniversityEventEntity event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UniversityEventCard({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a', 'es').format(event.date);

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                  Image.network(
                    event.imageUrl!,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => _buildPlaceholder(),
                  )
                else
                  _buildPlaceholder(),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Row(
                    children: [
                      _buildCircleAction(
                        icon: Icons.edit_outlined,
                        onTap: onEdit,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      _buildCircleAction(
                        icon: Icons.delete_outline_rounded,
                        onTap: onDelete,
                        color: Colors.white,
                        iconColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12.sp, color: primaryColor),
                            SizedBox(width: 6.w),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 16.sp, color: Colors.grey[400]),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    event.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.image_outlined, color: primaryColor.withOpacity(0.2), size: 48.sp),
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    Color iconColor = primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }
}
