import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';
import 'package:orientate/features/student/presentation/providers/careers_provider.dart';
import '../../../vocational_games/presentation/providers/games_provider.dart';
import '../../domain/entities/career_entity.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';

class VocationalResultsScreen extends StatefulWidget {
  const VocationalResultsScreen({super.key});

  @override
  State<VocationalResultsScreen> createState() {
    return _VocationalResultsScreenState();
  }
}

class _VocationalResultsScreenState
    extends State<VocationalResultsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final resultsProvider = context.read<StudentResultsProvider>();
      final gamesProvider = context.read<GamesProvider>();
      final careersProvider = context.read<CareersProvider>();

      await resultsProvider.fetchResults();
      await gamesProvider.fetchGames();

      if (resultsProvider.results.isNotEmpty &&
          !gamesProvider.areAllGamesCompleted) {
        await gamesProvider.markAllAsCompleted();
      }

      if (!mounted) return;

      if (gamesProvider.areAllGamesCompleted &&
          resultsProvider.results.isNotEmpty) {
        await careersProvider.fetchRecommendedCareers(
          topN: 5,
        );
      }
    });
  }

  void _goToStudentHome() {
    if (!mounted) return;

    context.go(AppRoutes.home.path);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentResultsProvider>();
    final gamesProvider = context.watch<GamesProvider>();
    final careersProvider = context.watch<CareersProvider>();

    if (gamesProvider.isLoading && gamesProvider.miniGames.isEmpty) {
      return Scaffold(
        backgroundColor: StudentUiColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Tus Resultados',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: StudentUiColors.primary,
          ),
        ),
        bottomNavigationBar: const StudentBottomNavigationBar(
          currentIndex: 3,
        ),
      );
    }

    final allCompleted = gamesProvider.areAllGamesCompleted;

    return PopScope(
      /*
       * Esta pantalla se abre mediante context.go().
       * Por eso no debe ejecutar context.pop(), ya que puede no existir
       * una pantalla anterior dentro de la pila de GoRouter.
       */
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _goToStudentHome();
      },
      child: Scaffold(
        backgroundColor: StudentUiColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Regresar al inicio',
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: _goToStudentHome,
          ),
          title: Text(
            'Tus Resultados',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Notificaciones',
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
              onPressed: () {
                _showMessage(
                  'Notificaciones próximamente',
                );
              },
            ),
            IconButton(
              tooltip: 'Más opciones',
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {
                _showMessage(
                  'Más opciones próximamente',
                );
              },
            ),
          ],
        ),
        body: allCompleted
            ? _buildBody(
          provider,
          careersProvider,
        )
            : _buildIncompleteGamesState(),
        bottomNavigationBar:
        const StudentBottomNavigationBar(
          currentIndex: 3,
        ),
      ),
    );
  }

  Widget _buildBody(
      StudentResultsProvider provider,
      CareersProvider careersProvider,
      ) {
    if (provider.isLoading &&
        provider.results.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: () async {
        await provider.fetchResults();
        await careersProvider.fetchRecommendedCareers(
          topN: 5,
          force: true,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          18.w,
          16.h,
          18.w,
          28.h,
        ),
        children: [
          if (provider.errorMessage != null) ...[
            _ResultsErrorCard(
              message: provider.errorMessage!,
              onRetry: provider.fetchResults,
            ),
            SizedBox(height: 18.h),
          ],

          _buildMainResultCard(provider),

          SizedBox(height: 22.h),

          _buildRecommendedCareers(
            careersProvider,
          ),

          SizedBox(height: 22.h),

          _buildSectionHeader(
            title: 'Fortalezas Detectadas',
            action: 'Ver todas',
            onActionPressed: () {
              _showMessage(
                'Listado completo próximamente',
              );
            },
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
            color: StudentUiColors.teal,
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
              color: StudentUiColors.darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 12.h),

          _buildInterestChips(),

          SizedBox(height: 26.h),

          _buildClarityCard(provider),

          SizedBox(height: 28.h),

          _buildCareersButton(),
        ],
      ),
    );
  }

  Widget _buildRecommendedCareers(
      CareersProvider provider,
      ) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carreras recomendadas',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Opciones calculadas con tus resultados y factores personales.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11.sp,
              height: 1.3,
            ),
          ),
          SizedBox(height: 16.h),
          if (provider.isLoading)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 24.h,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: StudentUiColors.primary,
                ),
              ),
            )
          else if (provider.errorMessage != null)
            Column(
              children: [
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton.icon(
                  onPressed: () {
                    provider.fetchRecommendedCareers(
                      topN: 5,
                      force: true,
                    );
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: const Text(
                    'Intentar nuevamente',
                  ),
                ),
              ],
            )
          else if (provider.careers.isEmpty)
              Text(
                'Todavía no hay recomendaciones disponibles.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
              )
            else
              ...provider.careers
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom:
                    entry.key ==
                        provider.careers.length - 1
                        ? 0
                        : 12.h,
                  ),
                  child: _buildCareerItem(
                    position: entry.key + 1,
                    career: entry.value,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildCareerItem({
    required int position,
    required CareerEntity career,
  }) {
    final double score =
    career.score.clamp(0.0, 1.0);
    final String? universityName =
        career.universityName;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: StudentUiColors.primary
            .withOpacity(0.055),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: StudentUiColors.primary
              .withOpacity(0.13),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: StudentUiColors.primary,
            foregroundColor: Colors.white,
            child: Text(
              '$position',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.name.toString(),
                  style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (universityName != null &&
                    universityName.trim().isNotEmpty) ...[
                  SizedBox(height: 5.h),
                  Text(
                    universityName,
                    style: TextStyle(
                      color: Colors.grey[650],
                      fontSize: 10.5.sp,
                      height: 1.25,
                    ),
                  ),
                ],
                SizedBox(height: 9.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 7.h,
                    backgroundColor: const Color(0xFFEDE9FE),
                    color: StudentUiColors.primary,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${(score * 100).round()}% de compatibilidad',
                  style: TextStyle(
                    color: StudentUiColors.primary,
                    fontSize: 10.sp,
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

  Widget _buildMainResultCard(
      StudentResultsProvider provider,
      ) {
    final hasResult = provider.results.isNotEmpty;

    final topCareer = hasResult &&
        provider.results.first.topCareer.trim().isNotEmpty
        ? provider.results.first.topCareer.trim()
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
            color: const Color(0xFF7C4DFF)
                .withOpacity(0.35),
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
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
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
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
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
              color: Colors.white.withOpacity(0.9),
              fontSize: 13.sp,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 22.h),

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
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
                        'COMPATIBILIDAD',
                        style: TextStyle(
                          color:
                          Colors.white.withOpacity(0.75),
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
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
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
    required VoidCallback onActionPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          child: Text(
            '$action  ›',
            style: TextStyle(
              color: const Color(0xFF2563EB),
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
            ),
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
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
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
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23.sp,
            ),
          ),

          SizedBox(width: 13.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: StudentUiColors.darkText,
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
    const interests = [
      _InterestChip(
        icon: Icons.bolt_rounded,
        label: 'Tecnología',
        backgroundColor: Color(0xFFEFF6FF),
        color: Color(0xFF2563EB),
      ),
      _InterestChip(
        icon: Icons.data_object_rounded,
        label: 'Matemáticas',
        backgroundColor: Color(0xFFF3E8FF),
        color: Color(0xFF9333EA),
      ),
      _InterestChip(
        icon: Icons.emoji_events_outlined,
        label: 'Liderazgo',
        backgroundColor: Color(0xFFFFF7ED),
        color: Color(0xFFF97316),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: interests.map((item) {
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 9.h,
            ),
            decoration: BoxDecoration(
              color: item.backgroundColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: item.color,
                  size: 17.sp,
                ),
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClarityCard(
      StudentResultsProvider provider,
      ) {
    final clarity = _getClarity(provider);
    final percentage = (clarity * 100).round();

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
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
                color: StudentUiColors.darkText,
                size: 24.sp,
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Text(
                  'Claridad Vocacional',
                  style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              Text(
                '$percentage%',
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
              backgroundColor:
              const Color(0xFFF3E8FF),
              color: StudentUiColors.primary,
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
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
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              _getClarityMessage(clarity),
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

  double _getClarity(
      StudentResultsProvider provider,
      ) {
    if (provider.results.isEmpty) {
      return 0.85;
    }

    /*
     * Por ahora se conserva el valor visual.
     * Cuando tu entidad incluya claridad vocacional,
     * sustituye este valor por el dato real.
     */
    return 0.85;
  }

  String _getClarityMessage(double clarity) {
    if (clarity >= 0.80) {
      return '¡Excelente! Tus respuestas muestran una dirección muy clara hacia carreras técnicas. Estás listo para el siguiente paso.';
    }

    if (clarity >= 0.50) {
      return 'Tu perfil comienza a mostrar una dirección vocacional. Continúa explorando carreras y realizando actividades.';
    }

    return 'Todavía estás explorando tus intereses. Realiza más actividades para fortalecer tu perfil vocacional.';
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
            backgroundColor: StudentUiColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
            elevation: 0,
          ),
          onPressed: () {
            context.push(AppRoutes.careers.path);
          },
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
              Icon(
                Icons.arrow_forward_rounded,
                size: 22.sp,
              ),
            ],
          ),
        )
    );
  }

  Widget _buildIncompleteGamesState() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          Icon(
            Icons.sports_esports_outlined,
            size: 80.sp,
            color: StudentUiColors.primary.withOpacity(0.8),
          ),
          SizedBox(height: 20.h),
          Text(
            '¡Continúa tu aventura vocacional!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Aún no has completado todos los minijuegos. Para poder analizar tus habilidades, intereses y darte tus resultados finales con las carreras recomendadas, debes completar todas las áreas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: StudentUiColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              onPressed: () {
                context.go(AppRoutes.games.path);
              },
              child: Text(
                'Ir a los Minijuegos',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsErrorCard extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ResultsErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red.shade100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _InterestChip {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color color;

  const _InterestChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.color,
  });
}