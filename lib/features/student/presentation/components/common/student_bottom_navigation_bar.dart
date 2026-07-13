import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import 'student_ui_colors.dart';

class StudentBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const StudentBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  static final List<_StudentNavigationItem> _destinations = [
    _StudentNavigationItem(
      label: 'Inicio',
      icon: Icons.home_rounded,
      path: AppRoutes.home.path,
    ),
    _StudentNavigationItem(
      label: 'Minijuegos',
      icon: Icons.sports_esports_outlined,
      path: AppRoutes.games.path,
    ),
    _StudentNavigationItem(
      label: 'Resultados',
      icon: Icons.bar_chart_outlined,
      path: AppRoutes.vocationalResults.path,
    ),
    _StudentNavigationItem(
      label: 'Perfil',
      icon: Icons.person_outline,
      path: AppRoutes.studentProfile.path,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      currentIndex: _safeCurrentIndex,
      selectedItemColor: StudentUiColors.primary,
      unselectedItemColor: Colors.grey[400],
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      onTap: (index) => _navigate(context, index),
      items: _destinations.map((destination) {
        return BottomNavigationBarItem(
          icon: Icon(destination.icon),
          label: destination.label,
        );
      }).toList(),
    );
  }

  int get _safeCurrentIndex {
    if (currentIndex < 0 ||
        currentIndex >= _destinations.length) {
      return 0;
    }

    return currentIndex;
  }

  void _navigate(BuildContext context, int index) {
    if (index < 0 || index >= _destinations.length) {
      return;
    }

    final destination = _destinations[index];
    final currentPath = GoRouterState.of(context).uri.path;

    if (currentPath == destination.path) {
      return;
    }

    context.go(destination.path);
  }
}

class _StudentNavigationItem {
  final String label;
  final IconData icon;
  final String path;

  const _StudentNavigationItem({
    required this.label,
    required this.icon,
    required this.path,
  });
}