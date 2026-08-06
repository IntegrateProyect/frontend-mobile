import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../responsive.dart';

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
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
              color: isDark ? primaryColor.withOpacity(0.18) : primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.account_balance_rounded,
              color: isDark ? const Color(0xFFB59AFF) : primaryColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  universityName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : accentColor,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? (isDark ? const Color(0xFF162E1C) : const Color(0xFFDCFCE7))
                        : (isDark ? const Color(0xFF2D251D) : const Color(0xFFFEF3C7)),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified ? Icons.verified_rounded : Icons.info_outline_rounded,
                        size: 11.sp,
                        color: isVerified
                            ? (isDark ? const Color(0xFF4EE27D) : Colors.green[800])
                            : (isDark ? const Color(0xFFF59E0B) : Colors.amber[900]),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isVerified ? 'VERIFICADO' : 'UNVERIFIED',
                        style: TextStyle(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w900,
                          color: isVerified
                              ? (isDark ? const Color(0xFF4EE27D) : Colors.green[800])
                              : (isDark ? const Color(0xFFF59E0B) : Colors.amber[900]),
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
