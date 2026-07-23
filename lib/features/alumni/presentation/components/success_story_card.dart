import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/success_story_entity.dart';

class SuccessStoryCard extends StatelessWidget {
  final SuccessStoryEntity story;
  final VoidCallback? onTap;

  const SuccessStoryCard({
    super.key,
    required this.story,
    this.onTap,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color accentColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.025),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar Premium con Gradiente
                      Container(
                        width: 52.r,
                        height: 52.r,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryColor, accentColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            story.alumniName.isNotEmpty ? story.alumniName[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.alumniName,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16.sp,
                                color: const Color(0xFF1D1B4B),
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${story.career} • Clase ${story.graduationYear}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icono de comillas sutil
                      Icon(
                        Icons.format_quote_rounded, 
                        color: primaryColor.withOpacity(0.06), 
                        size: 36.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Título dinámico o genérico
                  Text(
                    'Mi Trayectoria en la Industria',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5.sp,
                      color: primaryColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Contenido de la historia (Discreto pero perceptible)
                  Text(
                    story.story,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.sp,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
