import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:orientate/shared/theme/theme_provider.dart';

class UniversityHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UniversityHomeAppBar({super.key});

  // kToolbarHeight (56) en vez de 45.h fijo: un valor puramente calculado
  // por ScreenUtil puede quedar corto si el texto de sistema está
  // escalado. Usamos un mínimo seguro de Material y dejamos que el título
  // se trunque con ellipsis en vez de desbordar hacia el body.
  static const double _minHeight = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: _minHeight,
      title: Text(
        'Dashboard Universidad',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isDark ? Colors.white : accentColor,
          fontWeight: FontWeight.w900,
          fontSize: 18.sp,
        ),
      ),
      actions: [
        IconButton(
          tooltip: isDark ? 'Activar modo claro' : 'Activar modo oscuro',
          icon: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.amberAccent.withOpacity(0.1)
                  : const Color(0xFF311B92).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amberAccent : const Color(0xFF311B92),
              size: 18,
            ),
          ),
          onPressed: themeProvider.toggleTheme,
        ),
        SizedBox(width: 4.w),
        IconButton(
          tooltip: 'Cerrar sesión',
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
  Size get preferredSize => const Size.fromHeight(_minHeight);
}