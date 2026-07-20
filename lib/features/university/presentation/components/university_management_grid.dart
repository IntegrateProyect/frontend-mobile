import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/AppRoutes.dart';

class UniversityManagementGrid extends StatelessWidget {
  const UniversityManagementGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF1D1B4B);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
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
    return InkWell(
      onTap: () => context.push(path),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w900,
                color: accentColor,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8.5.sp,
                color: Colors.grey[400],
                fontWeight: FontWeight.w700,
                height: 1.05,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
