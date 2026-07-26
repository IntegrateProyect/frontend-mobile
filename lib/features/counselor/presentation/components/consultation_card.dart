import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/student_consultation_entity.dart';

class ConsultationCard extends StatelessWidget {
  static const Color _primary = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF1D1B4B);

  final StudentConsultationEntity consultation;
  final VoidCallback onTap;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = consultation.status.trim().toLowerCase();
    final pending = status != 'responded' && status != 'resolved';
    final studentName = consultation.studentName.trim().isEmpty
        ? 'Alumno'
        : consultation.studentName.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFECECF3)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: _primary.withOpacity(.09),
                child: Text(
                  studentName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: _primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            studentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: pending
                                ? const Color(0xFFFFF4E5)
                                : const Color(0xFFEAF8ED),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            pending ? 'Pendiente' : 'Respondido',
                            style: TextStyle(
                              color: pending
                                  ? const Color(0xFFE18400)
                                  : const Color(0xFF159947),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      consultation.message.trim().isEmpty
                          ? 'Sin mensaje'
                          : consultation.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      DateFormat(
                        "dd/MM/yyyy · hh:mm a",
                      ).format(consultation.createdAt.toLocal()),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 9.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 7.w),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
