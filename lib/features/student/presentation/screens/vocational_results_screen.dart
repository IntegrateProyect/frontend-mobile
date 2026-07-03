import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class VocationalResultsScreen extends StatefulWidget {
  const VocationalResultsScreen({super.key});

  @override
  State<VocationalResultsScreen> createState() =>
      _VocationalResultsScreenState();
}

class _VocationalResultsScreenState extends State<VocationalResultsScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentResultsProvider>().fetchResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentResultsProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Tus Resultados',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
        color: primaryColor,
        onRefresh: provider.fetchResults,
        child: ListView(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 28.h),
          children: [
            _buildMainResultCard(provider),
            SizedBox(height: 22.h),
            _buildSectionHeader(
              title: 'Fortalezas Detectadas',
              action: 'Ver todas',
            ),
            SizedBox(height: 12.h),
            _strengthItem(
              icon: Icons.psychology_outlined,
              title: 'Pensamiento Lógico',
              text:
              'Capacidad excepcional para resolver problemas complejos mediante el análisis.',
              color: const Color(0xFF4285F4),
            ),
            SizedBox(height: 10.h),
            _strengthItem(
              icon: Icons.groups_2_outlined,
              title: 'Colaboración',
              text:
              'Habilidad natural para trabajar en equipos multidisciplinarios con éxito.',
              color: const Color(0xFF00A6A6),
            ),
            SizedBox(height: 10.h),
            _strengthItem(
              icon: Icons.workspace_premium_outlined,
              title: 'Atención al Detalle',
              text:
              'Alta precisión en tareas técnicas y metodológicas.',
              color: const Color(0xFF6A4CFF),
            ),
            SizedBox(height: 24.h),
            Text(
              'Intereses Principales',
              style: TextStyle(
                color: darkText,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
            _buildInterestChips(),
            SizedBox(height: 26.h),
            _buildClarityCard(),
            SizedBox(height: 28.h),
            _buildCareersButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainResultCard(StudentResultsProvider provider) {
    final hasResult = provider.results.isNotEmpty;
    final topCareer = hasResult && provider.results.first.topCareer.isNotEmpty
        ? provider.results.first.topCareer
        : 'Ingeniería y STEM';

    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE040FB),
            Color(0xFF7C4DFF),
            Color(0xFF4B5CFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              Icons.track_changes_rounded,
              color: Colors.white,
              size: 42.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Resultado Principal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            topCareer,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tu perfil destaca por habilidades analíticas y pensamiento sistemático.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMPATIBILIDAD',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '94%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 31.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String action,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: darkText,
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Text(
          '$action  ›',
          style: TextStyle(
            color: const Color(0xFF2563EB),
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _strengthItem({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: color, size: 23.sp),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10.5.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChips() {
    final interests = [
      _InterestChip(
        icon: Icons.bolt_rounded,
        label: 'Tecnología',
        bg: const Color(0xFFEFF6FF),
        color: const Color(0xFF2563EB),
      ),
      _InterestChip(
        icon: Icons.data_object_rounded,
        label: 'Matemáticas',
        bg: const Color(0xFFF3E8FF),
        color: const Color(0xFF9333EA),
      ),
      _InterestChip(
        icon: Icons.emoji_events_outlined,
        label: 'Liderazgo',
        bg: const Color(0xFFFFF7ED),
        color: const Color(0xFFF97316),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: interests
            .map(
              (item) => Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: item.color, size: 17.sp),
                SizedBox(width: 6.w),
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildClarityCard() {
    const clarity = 0.85;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.star_border_rounded,
                color: darkText,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Claridad Vocacional',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '85%',
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: clarity,
              minHeight: 9.h,
              backgroundColor: const Color(0xFFF3E8FF),
              color: primaryColor,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _clarityLabel('EXPLORANDO'),
              _clarityLabel('DEFINIDO'),
              _clarityLabel('SEGURO'),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              '¡Excelente! Tus respuestas muestran una dirección muy clara hacia carreras técnicas. Estás listo para el siguiente paso.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 11.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clarityLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildCareersButton() {
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          elevation: 0,
        ),
        onPressed: () => context.push(AppRoutes.careers.path),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ver carreras recomendadas',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.arrow_forward_rounded, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _InterestChip {
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;

  _InterestChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.color,
  });
}