import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class UniversityBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const UniversityBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  static const Color _primaryColor = Color(0xFF311B92);

  static final List<_NavigationItem> _destinations = [
    _NavigationItem(
      label: 'Inicio',
      icon: Icons.home_rounded,
      path: AppRoutes.universityHome.path,
    ),
    _NavigationItem(
      label: 'Oferta',
      icon: Icons.school_rounded,
      path: AppRoutes.manageCareers.path,
    ),
    _NavigationItem(
      label: 'Eventos',
      icon: Icons.event_available_rounded,
      path: AppRoutes.manageEvents.path,
    ),
    _NavigationItem(
      label: 'Anuncios',
      icon: Icons.campaign_rounded,
      path: AppRoutes.manageAnnouncements.path,
    ),
    _NavigationItem(
      label: 'Egresados',
      icon: Icons.people_alt_rounded,
      path: AppRoutes.manageAlumni.path,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 10.sp,
        unselectedFontSize: 10.sp,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) => _navigate(context, index),
        items: _destinations.map((destination) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(destination.icon, size: 22.sp),
            ),
            label: destination.label,
          );
        }).toList(),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    final destination = _destinations[index];
    final currentPath = GoRouterState.of(context).uri.path;

    if (currentPath == destination.path) return;

    context.go(destination.path);
  }
}

class _NavigationItem {
  final String label;
  final IconData icon;
  final String path;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.path,
  });
}