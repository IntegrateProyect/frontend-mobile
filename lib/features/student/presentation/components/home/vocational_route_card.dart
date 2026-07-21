import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VocationalRouteCard extends StatelessWidget {
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
          // CABECERA (Compacta con degradado)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF24106B), Color(0xFF5D35F2)],
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
                      SizedBox(height: 2.h),
                      Text(
                        'Paso actual: Actividades (2 de 4)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.terrain_rounded,
                  size: 40.sp,
                  color: Colors.white.withOpacity(0.2),
                ),
              ],
            ),
          ),

          // LISTA DE PASOS
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Column(
              children: [
                _buildStepItem(
                  '1', 'Perfil inicial', Icons.person_rounded,
                  status: 'Completado',
                  isCompleted: true,
                  iconColor: const Color(0xFF4CAF50),
                  bgColor: const Color(0xFFE8F5E9),
                ),
                _buildStepItem(
                  '2', 'Actividades vocacionales', Icons.assignment_rounded,
                  isActive: true,
                  showButton: true,
                  onTap: onTap,
                  iconColor: const Color(0xFF1976D2),
                  bgColor: const Color(0xFFE3F2FD),
                ),
                _buildStepItem(
                  '3', 'Chatbot vocacional', Icons.smart_toy_rounded,
                  status: 'Pendiente',
                  isMuted: true,
                  onTap: onChatTap,
                  iconColor: const Color(0xFF757575),
                  bgColor: const Color(0xFFF5F5F5),
                ),
                _buildStepItem(
                  '4', 'Resultados', Icons.bar_chart_rounded,
                  status: 'Pendiente de completar',
                  isLast: true,
                  isMuted: true,
                  onTap: onResultsTap,
                  iconColor: const Color(0xFFBDBDBD),
                  bgColor: const Color(0xFFF5F5F5),
                ),

                SizedBox(height: 12.h),

                // Botón principal
                Container(
                  width: double.infinity,
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5D35F2), Color(0xFF24106B)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shortcut_rounded, color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Continuar ruta',
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

                // Link detalle
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ver detalle de la ruta',
                    style: TextStyle(
                      color: const Color(0xFF24106B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    String num, String title, IconData icon, {
    String? status,
    bool isCompleted = false, bool isActive = false,
    bool isLast = false, bool isMuted = false,
    bool showButton = false,
    VoidCallback? onTap,
    required Color iconColor, required Color bgColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? const Color(0xFF4CAF50) : (isActive ? const Color(0xFF1976D2) : const Color(0xFFD1D1D1)),
                ),
                child: Center(
                  child: isCompleted 
                    ? Icon(Icons.check, color: Colors.white, size: 10.sp)
                    : (isActive ? Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)) : null),
                ),
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
          // Contenido
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8.r)),
                      child: Icon(icon, color: iconColor, size: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(color: isMuted ? Colors.grey : const Color(0xFF1D1B4B), fontSize: 12.sp, fontWeight: FontWeight.w800)),
                          Text(status ?? (isActive ? "En curso" : "Pendiente"), style: TextStyle(color: isMuted ? Colors.grey : iconColor, fontSize: 9.sp, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    if (showButton)
                      Icon(Icons.arrow_forward_ios_rounded, size: 12.sp, color: iconColor.withOpacity(0.3)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
