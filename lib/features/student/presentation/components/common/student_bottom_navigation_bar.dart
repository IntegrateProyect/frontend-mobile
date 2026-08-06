import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import 'student_group_required_dialog.dart';
import 'student_ui_colors.dart';

class StudentBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const StudentBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  Future<void> _navigate(BuildContext context, int index) async {
    if (index == currentIndex) return;

    // Inicio y Perfil permanecen disponibles sin grupo.
    final requiresGroup = index == 1 || index == 2 || index == 3;

    if (requiresGroup) {
      final canContinue = await requireStudentGroup(context: context);

      if (!canContinue || !context.mounted) return;
    }

    if (!context.mounted) return;

    switch (index) {
      case 0:
        context.goNamed(AppRoutes.home.name);
        break;
      case 1:
        context.goNamed(AppRoutes.games.name);
        break;
      case 2:
        context.goNamed(AppRoutes.studentAgenda.name);
        break;
      case 3:
        context.goNamed(AppRoutes.vocationalResults.name);
        break;
      case 4:
        context.goNamed(AppRoutes.studentProfile.name);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF0F1020) : Theme.of(context).colorScheme.surface,
      selectedItemColor: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
      unselectedItemColor: isDark ? Colors.white60 : Colors.grey.shade500,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
      onTap: (index) => _navigate(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports_outlined),
          activeIcon: Icon(Icons.sports_esports_rounded),
          label: 'Minijuegos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month_rounded),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart_rounded),
          label: 'Resultados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
