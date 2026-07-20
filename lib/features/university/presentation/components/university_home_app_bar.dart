import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class UniversityHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UniversityHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 45.h,
      title: Text(
        'Dashboard Universidad',
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w900,
          fontSize: 18.sp,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
          ),
          onPressed: () async {
            await context.read<AuthProvider>().logout();
            if (context.mounted) context.go('/login');
          },
        ),
        SizedBox(width: 12.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(45.h);
}
