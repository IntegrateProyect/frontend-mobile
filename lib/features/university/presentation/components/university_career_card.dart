import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/university_career_entity.dart';

class UniversityCareerCard extends StatelessWidget {
  final UniversityCareerEntity career;
  final VoidCallback onDelete;

  const UniversityCareerCard({
    super.key,
    required this.career,
    required this.onDelete,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF1D1B4B);

  Future<void> _openMap() async {
    if (career.latitude == null || career.longitude == null) return;
    
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${career.latitude},${career.longitude}'
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    career.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                    ),
                  ),
                  if (career.location != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 12.sp, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            career.location!,
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Text(
                    career.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildChip(Icons.layers_outlined, career.modality ?? 'Presencial'),
                      _buildChip(
                        Icons.monetization_on_outlined,
                        '\$${career.cost.toStringAsFixed(0)}',
                      ),
                      if (career.duration != null && career.duration!.isNotEmpty)
                        _buildChip(Icons.timer_outlined, career.duration!),
                      if (career.latitude != null && career.longitude != null)
                        InkWell(
                          onTap: _openMap,
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: primaryColor.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map_outlined, size: 12.sp, color: primaryColor),
                                SizedBox(width: 6.w),
                                Text(
                                  'Ver ubicación',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22.sp),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: primaryColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
