import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class ProfileAvatarHeader extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String subtitle;
  final VoidCallback onAvatarTap;

  const ProfileAvatarHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.subtitle,
    required this.onAvatarTap,
  });

  bool get hasAvatar {
    return avatarUrl != null && avatarUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 110.r,
                  height: 110.r,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1B2E) : const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: hasAvatar
                      ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _fallbackAvatar();
                    },
                  )
                      : _fallbackAvatar(),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: StudentUiColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF0F1020) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            name.trim().isEmpty ? 'Estudiante' : name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : StudentUiColors.darkText,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Icon(
      Icons.person,
      size: 60.sp,
      color: Colors.grey[400],
    );
  }
}