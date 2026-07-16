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
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'Oriéntate+',
        style: TextStyle(
          color: StudentUiColors.primary,
          fontWeight: FontWeight.w900,
          fontSize: 20.sp,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: onNotificationsPressed,
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
          ),
        ),

        // Icono de cuenta del estudiante
        IconButton(
          tooltip: 'Información de la cuenta',
          onPressed: onAccountPressed,
          icon: const Icon(
            Icons.person_rounded,
            color: Colors.black,
          ),
        ),

        SizedBox(width: 6.w),
      ],
    );
  }
}