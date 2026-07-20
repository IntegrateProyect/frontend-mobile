import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversityInstitutionalHeader extends StatelessWidget {
  final String universityName;
  final String status;

  const UniversityInstitutionalHeader({
    super.key,
    required this.universityName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);
    final bool isVerified = status == 'VERIFIED';

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: primaryColor, size: 22),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  universityName,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 1.1),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified
                            ? Icons.verified_rounded
                            : Icons.info_outline_rounded,
                        size: 10.sp,
                        color: isVerified ? Colors.green[800] : Colors.amber[900],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isVerified ? 'VERIFICADO' : 'UNVERIFIED',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: isVerified ? Colors.green[800] : Colors.amber[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
