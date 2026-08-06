import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounselorHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pendingNotifications;
  final VoidCallback onNotificationsPressed;

  const CounselorHomeAppBar({
    super.key,
    required this.pendingNotifications,
    required this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF311B92);
    const secondary = Color(0xFF6847D6);
    const dark = Color(0xFF17164A);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 68.h,
      backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
      surfaceTintColor: isDark ? const Color(0xFF0F1020) : Colors.white,
      elevation: 0,
      titleSpacing: 20.w,
      title: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primary, secondary],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Oriéntate+',
            style: TextStyle(
              color: isDark ? Colors.white : dark,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -.4,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: onNotificationsPressed,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: isDark ? Colors.white : dark,
              ),
              if (pendingNotifications > 0)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      pendingNotifications > 9 ? '9+' : '$pendingNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(68.h);
}
