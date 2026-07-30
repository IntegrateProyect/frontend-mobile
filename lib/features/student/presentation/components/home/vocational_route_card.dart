import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VocationalRouteCard extends StatelessWidget {
  final bool hasGroup;
  final bool gamesStarted;
  final bool gamesCompleted;
  final bool chatbotCompleted;
  final bool resultsCompleted;

  final VoidCallback onGamesTap;
  final VoidCallback onChatTap;
  final VoidCallback onResultsTap;

  const VocationalRouteCard({
    super.key,
    required this.hasGroup,
    required this.gamesStarted,
    required this.gamesCompleted,
    required this.chatbotCompleted,
    required this.resultsCompleted,
    required this.onGamesTap,
    required this.onChatTap,
    required this.onResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    final stages = _stages;
    final completedCount =
        stages.where((stage) => stage.completed).length;
    final currentStage = stages.firstWhere(
          (stage) => !stage.completed,
      orElse: () => stages.last,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(
            currentStage: currentStage,
            completedCount: completedCount,
          ),
          _buildRouteSteps(context, stages),
        ],
      ),
    );
  }

  List<_RouteStage> get _stages {
    final gamesStatus = !hasGroup
        ? 'Únete a un grupo'
        : gamesCompleted
        ? 'Completado'
        : gamesStarted
        ? 'En progreso'
        : 'Iniciar';

    final chatbotStatus = !hasGroup
        ? 'Únete a un grupo'
        : chatbotCompleted
        ? 'Completado'
        : 'Iniciar';

    final resultsStatus = !hasGroup
        ? 'Únete a un grupo'
        : resultsCompleted
        ? 'Completado'
        : 'Pendiente';

    return [
      const _RouteStage(
        title: 'Perfil inicial',
        status: 'Completado',
        icon: Icons.person_rounded,
        color: Color(0xFF4CAF50),
        background: Color(0xFFE8F5E9),
        completed: true,
      ),
      _RouteStage(
        title: 'Actividades vocacionales',
        status: gamesStatus,
        icon: Icons.sports_esports_rounded,
        color: const Color(0xFF1976D2),
        background: const Color(0xFFE3F2FD),
        completed: hasGroup && gamesCompleted,
        active: hasGroup && gamesStarted && !gamesCompleted,
        locked: !hasGroup,
        onTap: onGamesTap,
      ),
      _RouteStage(
        title: 'Chatbot vocacional',
        status: chatbotStatus,
        icon: Icons.smart_toy_rounded,
        color: const Color(0xFF00A7A5),
        background: const Color(0xFFE7F8F7),
        completed: hasGroup && chatbotCompleted,
        active: hasGroup && !chatbotCompleted,
        locked: !hasGroup,
        onTap: onChatTap,
      ),
      _RouteStage(
        title: 'Resultados',
        status: resultsStatus,
        icon: Icons.bar_chart_rounded,
        color: const Color(0xFF9B51E0),
        background: const Color(0xFFF4EAFB),
        completed: hasGroup && resultsCompleted,
        active: hasGroup && resultsCompleted,
        locked: !hasGroup,
        onTap: onResultsTap,
      ),
    ];
  }

  Widget _buildHeader({
    required _RouteStage currentStage,
    required int completedCount,
  }) {
    final title = !hasGroup
        ? 'Únete a un grupo para continuar'
        : completedCount == 4
        ? 'Ruta vocacional completada'
        : currentStage.title;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF24106B),
            Color(0xFF5D35F2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi ruta vocacional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Paso actual: $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$completedCount de 4 etapas completadas',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.terrain_rounded,
            size: 40.sp,
            color: Colors.white.withOpacity(0.20),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSteps(
      BuildContext context,
      List<_RouteStage> stages,
      ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      child: Column(
        children: [
          for (int index = 0; index < stages.length; index++)
            _buildStepItem(
              context: context,
              stage: stages[index],
              isLast: index == stages.length - 1,
            ),
          if (!gamesCompleted) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: onGamesTap,
                icon: Icon(
                  hasGroup
                      ? Icons.sports_esports_rounded
                      : Icons.lock_outline_rounded,
                ),
                label: Text(
                  !hasGroup
                      ? 'Unirme a un grupo'
                      : gamesStarted
                      ? 'Continuar actividades'
                      : 'Iniciar actividades',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF311B92),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required BuildContext context,
    required _RouteStage stage,
    required bool isLast,
  }) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final titleColor = stage.locked
        ? Colors.grey.shade500
        : darkMode
        ? Colors.white
        : const Color(0xFF1D1B4B);

    final statusColor =
    stage.locked ? Colors.grey.shade500 : stage.color;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 19.w,
                height: 19.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stage.completed
                      ? const Color(0xFF4CAF50)
                      : stage.active
                      ? stage.color
                      : const Color(0xFFD1D1D1),
                ),
                child: stage.completed
                    ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12.sp,
                )
                    : stage.locked
                    ? Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                  size: 10.sp,
                )
                    : stage.active
                    ? Center(
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.w,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: const Color(0xFFD1D1D1),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: stage.onTap,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: stage.active
                          ? stage.color.withOpacity(0.04)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: stage.active
                            ? stage.color.withOpacity(0.30)
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: stage.locked
                                ? Colors.grey.withOpacity(0.10)
                                : stage.background,
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                          child: Icon(
                            stage.locked
                                ? Icons.lock_outline_rounded
                                : stage.icon,
                            color: statusColor,
                            size: 21.sp,
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stage.title,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                stage.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (stage.onTap != null)
                          Icon(
                            Icons.chevron_right_rounded,
                            color: statusColor,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteStage {
  final String title;
  final String status;
  final IconData icon;
  final Color color;
  final Color background;
  final bool completed;
  final bool active;
  final bool locked;
  final VoidCallback? onTap;

  const _RouteStage({
    required this.title,
    required this.status,
    required this.icon,
    required this.color,
    required this.background,
    this.completed = false,
    this.active = false,
    this.locked = false,
    this.onTap,
  });
}