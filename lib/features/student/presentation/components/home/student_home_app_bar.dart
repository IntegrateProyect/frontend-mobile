import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/student_ui_colors.dart';

class StudentHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onNotificationsPressed;
  final VoidCallback onAccountPressed;

  const StudentHomeAppBar({
    super.key,
    required this.onNotificationsPressed,
    required this.onAccountPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
      surfaceTintColor: isDark ? const Color(0xFF0F1020) : Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'Oriéntate+',
        style: TextStyle(
          color: isDark ? Colors.white : StudentUiColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 20.sp,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: onNotificationsPressed,
          icon: Icon(
            Icons.notifications_none_rounded,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        // Icono de cuenta del estudiante
        IconButton(
          tooltip: 'Información de la cuenta',
          onPressed: onAccountPressed,
          icon: Icon(
            Icons.person_rounded,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        SizedBox(width: 6.w),
      ],
    );
  }
}