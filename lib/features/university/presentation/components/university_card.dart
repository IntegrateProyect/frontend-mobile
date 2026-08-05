import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/university_entity.dart';
import '../../../student/presentation/components/common/student_ui_colors.dart';

class UniversityCard extends StatelessWidget {
  final UniversityEntity university;
  final VoidCallback? onTap;

  const UniversityCard({
    super.key,
    required this.university,
    this.onTap,
  });

  Future<void> _openMap() async {
    if (university.latitude == null || university.longitude == null) return;
    
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${university.latitude},${university.longitude}'
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
    university.isRegistered
        ? const Color(0xFF16A34A)
        : const Color(0xFFF59E0B);

    final statusBackground =
    university.isRegistered
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFFF7ED);

    final statusText =
    university.isRegistered
        ? 'Registrada en Oriéntate+'
        : 'Registro RENOES';

    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(22.r),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: 14.h,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(22.r),
          border: Border.all(
            color:
            const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color:
                const Color(0xFFEDE9FE),
                borderRadius:
                BorderRadius.circular(18.r),
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                color:
                StudentUiColors.primary,
                size: 31,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: TextStyle(
                      color:
                      StudentUiColors.darkText,
                      fontSize: 14.sp,
                      fontWeight:
                      FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12.sp, color: Colors.grey[500]),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          university.location,
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius:
                          BorderRadius.circular(
                            14.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Icon(
                              university.isRegistered
                                  ? Icons
                                  .verified_rounded
                                  : Icons
                                  .inventory_2_outlined,
                              color: statusColor,
                              size: 13.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 9.sp,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (university.duration != null && university.duration!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined, size: 13.sp, color: Colors.grey[600]),
                              SizedBox(width: 5.w),
                              Text(
                                university.duration!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 26.sp,
            ),
          ],
        ),
      ),
    );
  }
}
