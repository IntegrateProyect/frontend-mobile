import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../university/domain/entities/university_entity.dart';
import '../../../domain/entities/university_entity.dart';
import '../common/student_ui_colors.dart';

class UniversityCard extends StatelessWidget {
  final UniversityEntity university;
  final VoidCallback? onTap;

  const UniversityCard({
    super.key,
    required this.university,
    this.onTap,
  });

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
              child: Icon(
                Icons.account_balance_rounded,
                color:
                StudentUiColors.primary,
                size: 31.sp,
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
                  SizedBox(height: 10.h),
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
                          size: 15.sp,
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10.sp,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
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