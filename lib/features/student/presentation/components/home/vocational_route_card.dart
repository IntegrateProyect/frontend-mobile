import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VocationalRouteCard extends StatelessWidget {
  /// Abre GamesListScreen desde StudentHomeScreen.
  final VoidCallback onTap;

  final VoidCallback onChatTap;
  final VoidCallback onResultsTap;

  const VocationalRouteCard({
    super.key,
    required this.onTap,
    required this.onChatTap,
    required this.onResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
          _buildHeader(),
          _buildRouteSteps(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi ruta vocacional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Paso actual: Actividades vocacionales',
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.90),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '2 de 4 etapas',
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.70),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
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

  Widget _buildRouteSteps() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.w,
        14.h,
        16.w,
        14.h,
      ),
      child: Column(
        children: [
          _buildStepItem(
            title: 'Perfil inicial',
            icon: Icons.person_rounded,
            status: 'Completado',
            isCompleted: true,
            iconColor: const Color(0xFF4CAF50),
            backgroundColor:
            const Color(0xFFE8F5E9),
          ),

          // Al tocar este paso abre los minijuegos.
          _buildStepItem(
            title: 'Actividades vocacionales',
            icon: Icons.sports_esports_rounded,
            status: 'Continuar',
            isActive: true,
            showArrow: true,
            onTap: onTap,
            iconColor: const Color(0xFF1976D2),
            backgroundColor:
            const Color(0xFFE3F2FD),
          ),

          _buildStepItem(
            title: 'Chatbot vocacional',
            icon: Icons.smart_toy_rounded,
            status: 'Pendiente',
            isMuted: true,
            onTap: onChatTap,
            iconColor: const Color(0xFF757575),
            backgroundColor:
            const Color(0xFFF5F5F5),
          ),

          _buildStepItem(
            title: 'Resultados',
            icon: Icons.bar_chart_rounded,
            status: 'Pendiente de completar',
            isLast: true,
            isMuted: true,
            onTap: onResultsTap,
            iconColor: const Color(0xFFBDBDBD),
            backgroundColor:
            const Color(0xFFF5F5F5),
          ),

          SizedBox(height: 12.h),

          // Este botón también abre los minijuegos.
          Container(
            width: double.infinity,
            height: 46.h,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(23.r),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5D35F2),
                  Color(0xFF24106B),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5D35F2)
                      .withOpacity(0.20),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(23.r),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_esports_rounded,
                    color: Colors.white,
                    size: 19.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Ir a actividades',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    String? status,
    bool isCompleted = false,
    bool isActive = false,
    bool isLast = false,
    bool isMuted = false,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    final titleColor = isMuted
        ? Colors.grey.shade500
        : const Color(0xFF1D1B4B);

    final statusColor = isMuted
        ? Colors.grey.shade500
        : iconColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _buildTimelineIndicator(
            isCompleted: isCompleted,
            isActive: isActive,
            isLast: isLast,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 8.h,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius:
                BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                  BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(9.w),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF1976D2)
                            .withOpacity(0.28)
                            : const Color(0xFFF0F0F0),
                        width: isActive ? 1.3 : 1,
                      ),
                      color: isActive
                          ? const Color(0xFFF8FBFF)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius:
                            BorderRadius.circular(
                              9.r,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 19.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 12.sp,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                status ??
                                    (isActive
                                        ? 'En curso'
                                        : 'Pendiente'),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9.sp,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showArrow &&
                            onTap != null)
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              color: iconColor
                                  .withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              size: 12.sp,
                              color: iconColor,
                            ),
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

  Widget _buildTimelineIndicator({
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    final indicatorColor = isCompleted
        ? const Color(0xFF4CAF50)
        : isActive
        ? const Color(0xFF1976D2)
        : const Color(0xFFD1D1D1);

    return Column(
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: indicatorColor,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: 11.sp,
            )
                : isActive
                ? Container(
              width: 8.w,
              height: 8.w,
              decoration:
              const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
                : null,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.w,
              margin: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              color: const Color(0xFFD1D1D1),
            ),
          ),
      ],
    );
  }
}