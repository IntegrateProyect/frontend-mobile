import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/careers_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  static const Color primaryColor = Color(0xFF3B0A57);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CareersProvider>().fetchRecommendedCareers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CareersProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content;

    if (provider.state == CareersState.loading && provider.careers.isEmpty) {
      content = const Center(child: CircularProgressIndicator(color: primaryColor));
    } else if (provider.state == CareersState.error && provider.careers.isEmpty) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              SizedBox(height: 16.h),
              Text(
                provider.errorMessage ?? 'Ocurrió un error al cargar las recomendaciones',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => provider.fetchRecommendedCareers(force: true),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: () => provider.refresh(),
        color: primaryColor,
        child: ListView(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 28.h),
          children: [
            Text(
              'Tu Futuro Te Espera',
              style: TextStyle(
                color: isDark ? Colors.white : darkText,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Basado en tus pruebas vocacionales y perfil actual, estas son las opciones que mejor se alinean contigo.',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 12.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            _searchBox(),
            SizedBox(height: 18.h),
            _statsRow(),
            SizedBox(height: 18.h),
            if (provider.careers.isEmpty) ...[
              _careerCard(
                id: 'ia',
                area: 'Tecnología',
                title: 'Ingeniería en Inteligencia Artificial',
                percent: '98%',
                description:
                    'Tu alto desempeño en lógica y matemáticas indica una afinidad fuerte con tecnología avanzada.',
                tags: [
                  'Pensamiento analítico',
                  'Resolución de problemas',
                  'Interés tecnológico',
                ],
              ),
              _careerCard(
                id: 'psicologia',
                area: 'Sociales',
                title: 'Psicología Organizacional',
                percent: '85%',
                description:
                    'Tus habilidades interpersonales y liderazgo sugieren potencial para gestionar talento humano.',
                tags: [
                  'Empatía',
                  'Liderazgo',
                  'Comunicación asertiva',
                ],
              ),
              _careerCard(
                id: 'ux',
                area: 'Arte y Diseño',
                title: 'Diseño de Experiencia de Usuario (UX)',
                percent: '78%',
                description:
                    'Combina creatividad visual con análisis para crear soluciones centradas en personas.',
                tags: [
                  'Creatividad',
                  'Atención al detalle',
                  'Pensamiento crítico',
                ],
              ),
            ] else
              ...provider.careers.map((career) => _careerCard(
                    id: career.id,
                    area: career.universityName ?? 'Institución',
                    title: career.name,
                    percent: '${career.compatibilityPercentage}%',
                    description: career.description,
                    tags: career.fields,
                  )),
            _chatHelpCard(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Carreras recomendadas',
          style: TextStyle(
            color: isDark ? Colors.white : darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: content,
    );
  }

  Widget _searchBox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F30) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: isDark ? Colors.white54 : Colors.grey[500], size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Buscar por carrera o área...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white30 : Colors.grey[500],
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: isDark ? Colors.white54 : Colors.grey[600], size: 20.sp),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            icon: Icons.track_changes_rounded,
            title: 'CLARIDAD',
            value: 'Alta Precisión',
            color: const Color(0xFF4285F4),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _statBox(
            icon: Icons.business_center_outlined,
            title: 'MERCADO',
            value: 'Demanda Creciente',
            color: const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _statBox({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F30) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 23.sp),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark ? Colors.white : darkText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _careerCard({
    required String id,
    required String area,
    required String title,
    required String percent,
    required String description,
    required List<String> tags,
  }) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F30) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.025),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(height: 13.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2A4A) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  area,
                  style: TextStyle(
                    color: const Color(0xFF2563EB),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$percent\nCOMPATIBILIDAD',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121324) : const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: isDark ? const Color(0xFF2E3150) : const Color(0xFFE0E7FF)),
            ),
            child: Text(
              '¿POR QUÉ ES PARA TI?\n$description',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700],
                fontSize: 11.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Perfil de ingreso clave:',
            style: TextStyle(
              color: isDark ? Colors.white70 : darkText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                backgroundColor: isDark ? const Color(0xFF2E3150) : const Color(0xFFF3F4F6),
                side: BorderSide.none,
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                  ),
                  child: const Text(
                    'Ver detalle  →',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: () => favoritesProvider.toggleFavorite(id, 'career'),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white24 : Colors.grey.withOpacity(0.25)),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatHelpCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFE040FB), Color(0xFF4B5CFF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Aún no estás seguro?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Habla con nuestro ChatBot vocacional para resolver dudas específicas sobre estas carreras.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.chat.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
              ),
              child: const Text(
                'Consultar con IA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}