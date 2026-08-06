import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../responsive.dart';

class UniversityManagementGrid extends StatelessWidget {
  const UniversityManagementGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);
    final screenSize = context.screenSize;

    // Adaptamos el grid según el tamaño de pantalla
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = (width >= 600 && width < 720) ? 3 : 2;
    final double childAspectRatio = (width >= 600 && width < 720) ? 1.4 : 1.15;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 10.r,
      crossAxisSpacing: 10.r,
      childAspectRatio: childAspectRatio,
      children: [
        _buildActionCard(
          context,
          'Oferta Académica',
          'Gestionar carreras',
          Icons.school,
          AppRoutes.manageCareers.path,
          const Color(0xFFF0FDF4),
          Colors.green,
          accentColor,
        ),
        _buildActionCard(
          context,
          'Eventos',
          'Publicar ferias',
          Icons.calendar_month,
          AppRoutes.manageEvents.path,
          const Color(0xFFEFF6FF),
          Colors.blue,
          accentColor,
        ),
        _buildActionCard(
          context,
          'Anuncios',
          'Comunicados/Becas',
          Icons.campaign,
          AppRoutes.manageAnnouncements.path,
          const Color(0xFFFFF7ED),
          Colors.orange,
          accentColor,
        ),
        _buildActionCard(
          context,
          'Egresados',
          'Administrar graduados',
          Icons.card_membership,
          AppRoutes.manageAlumni.path,
          const Color(0xFFFAF5FF),
          Colors.purple,
          accentColor,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String path,
    Color bg,
    Color iconColor,
    Color accentColor,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.push(path),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F38) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isDark ? iconColor.withOpacity(0.18) : bg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: isDark ? const Color(0xFFB59AFF) : iconColor, size: 20.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : accentColor,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark ? Colors.grey.shade400 : Colors.grey[400],
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
