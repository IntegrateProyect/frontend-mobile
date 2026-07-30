import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/providers/careers_provider.dart';
import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';

import '../../../vocational_games/presentation/providers/games_provider.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';

class VocationalResultsScreen extends StatefulWidget {
  const VocationalResultsScreen({super.key});

  @override
  State<VocationalResultsScreen> createState() =>
      _VocationalResultsScreenState();
}

class _VocationalResultsScreenState
    extends State<VocationalResultsScreen> {
  static const Map<String, String> _riasecNames = {
    'R': 'Realista',
    'I': 'Investigador',
    'A': 'Artístico',
    'S': 'Social',
    'E': 'Emprendedor',
    'C': 'Convencional',
  };

  static const Map<String, Color> _riasecColors = {
    'R': Color(0xFF2563EB),
    'I': Color(0xFF7C3AED),
    'A': Color(0xFFDB2777),
    'S': Color(0xFF059669),
    'E': Color(0xFFEA580C),
    'C': Color(0xFF475569),
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final resultsProvider =
    context.read<StudentResultsProvider>();
    final gamesProvider = context.read<GamesProvider>();
    final careersProvider = context.read<CareersProvider>();

    await resultsProvider.fetchResults();
    await gamesProvider.fetchGames();

    if (!mounted) return;

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
  }

  Future<void> _refreshData() async {
    final resultsProvider =
    context.read<StudentResultsProvider>();
    final careersProvider = context.read<CareersProvider>();

    await resultsProvider.fetchResults();

    if (resultsProvider.results.isNotEmpty) {
      await careersProvider.fetchRecommendedCareers(
        topN: 5,
        force: true,
      );
    }
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
    final resultsProvider =
    context.watch<StudentResultsProvider>();
    final gamesProvider = context.watch<GamesProvider>();
    final careersProvider = context.watch<CareersProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goToStudentHome();
        }
      },
      child: Scaffold(
        backgroundColor: StudentUiColors.background,
        appBar: _buildAppBar(),
        body: _buildScreenBody(
          resultsProvider: resultsProvider,
          gamesProvider: gamesProvider,
          careersProvider: careersProvider,
        ),
        bottomNavigationBar:
        const StudentBottomNavigationBar(
          currentIndex: 3,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
            _showMessage('Notificaciones próximamente');
          },
        ),
        IconButton(
          tooltip: 'Más opciones',
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onPressed: () {
            _showMessage('Más opciones próximamente');
          },
        ),
      ],
    );
  }

  Widget _buildScreenBody({
    required StudentResultsProvider resultsProvider,
    required GamesProvider gamesProvider,
    required CareersProvider careersProvider,
  }) {
    if ((gamesProvider.isLoading &&
        gamesProvider.miniGames.isEmpty) ||
        (resultsProvider.isLoading &&
            resultsProvider.results.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    if (!gamesProvider.areAllGamesCompleted &&
        resultsProvider.results.isEmpty) {
      return _buildIncompleteGamesState();
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: _refreshData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          18.w,
          16.h,
          18.w,
          30.h,
        ),
        children: [
          if (resultsProvider.errorMessage != null) ...[
            _ResultsErrorCard(
              message: resultsProvider.errorMessage!,
              onRetry: _refreshData,
            ),
            SizedBox(height: 16.h),
          ],
          if (resultsProvider.results.isEmpty)
            _buildEmptyResults()
          else ...[
            _buildRecommendedCareers(
              careersProvider,
            ),
            SizedBox(height: 20.h),
            _buildRiasecOverview(
              resultsProvider.latestResult!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiasecOverview(
      VocationalResultEntity result,
      ) {
    final scores = <MapEntry<String, double>>[];

    for (final letter in const [
      'R',
      'I',
      'A',
      'S',
      'E',
      'C',
    ]) {
      scores.add(
        MapEntry(
          letter,
          _normalizeScore(result.scores[letter] ?? 0),
        ),
      );
    }

    final rankedScores =
    List<MapEntry<String, double>>.from(scores)
      ..sort((a, b) => b.value.compareTo(a.value));

    final dominant = rankedScores
        .take(3)
        .map((item) => item.key)
        .join('');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8E6F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6D28D9),
                      Color(0xFF4338CA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu perfil RIASEC',
                      style: TextStyle(
                        color: StudentUiColors.darkText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Puntuaciones reales obtenidas en tus actividades.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (dominant.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ECFF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    dominant,
                    style: TextStyle(
                      color: StudentUiColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 22.h),
          ...scores.map(
                (item) => _buildRiasecScoreRow(
              letter: item.key,
              score: item.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiasecScoreRow({
    required String letter,
    required double score,
  }) {
    final color =
        _riasecColors[letter] ?? StudentUiColors.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 37.w,
            height: 37.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _riasecNames[letter] ?? letter,
                        style: TextStyle(
                          color: StudentUiColors.darkText,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${(score * 100).round()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 7.h,
                    backgroundColor: color.withOpacity(0.09),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8E6F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carreras recomendadas',
                      style: TextStyle(
                        color: StudentUiColors.darkText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Ordenadas según tu perfil RIASEC y tus factores personales.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.hasCareers)
                IconButton(
                  tooltip: 'Actualizar recomendaciones',
                  onPressed: provider.refresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: StudentUiColors.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          if (provider.isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 28.h),
              child: const Center(
                child: CircularProgressIndicator(
                  color: StudentUiColors.primary,
                ),
              ),
            )
          else if (provider.errorMessage != null)
            _buildRecommendationError(provider)
          else if (provider.careers.isEmpty)
              _buildEmptyRecommendations(provider)
            else
              ...provider.careers.asMap().entries.map(
                    (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key ==
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
    final university = career.universityName?.trim();
    final isFirst = position == 1;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isFirst
              ? StudentUiColors.primary.withOpacity(0.32)
              : const Color(0xFFE6E2F2),
        ),
        boxShadow: [
          BoxShadow(
            color: StudentUiColors.primary.withOpacity(
              isFirst ? 0.10 : 0.045,
            ),
            blurRadius: isFirst ? 16 : 11,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5B21B6),
                  Color(0xFF4338CA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#$position',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isFirst)
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFD166),
                    size: 13.sp,
                  ),
              ],
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? const Color(0xFFFFF4D8)
                        : const Color(0xFFF1ECFF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    isFirst
                        ? 'MEJOR COINCIDENCIA'
                        : 'OPCIÓN RECOMENDADA',
                    style: TextStyle(
                      color: isFirst
                          ? const Color(0xFFB76A00)
                          : StudentUiColors.primary,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.35,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  career.name.trim().isEmpty
                      ? 'Carrera sin nombre'
                      : career.name.trim(),
                  style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 13.5.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (university != null &&
                    university.isNotEmpty) ...[
                  SizedBox(height: 9.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7FC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 27.w,
                          height: 27.w,
                          decoration: BoxDecoration(
                            color: StudentUiColors.primary
                                .withOpacity(0.10),
                            borderRadius:
                            BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.account_balance_rounded,
                            size: 15.sp,
                            color: StudentUiColors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            university,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10.5.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: StudentUiColors.primary,
                      size: 15.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Seleccionada a partir de tu perfil RIASEC',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 9.8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationError(
      CareersProvider provider,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          OutlinedButton.icon(
            onPressed: () {
              provider.fetchRecommendedCareers(
                topN: 5,
                force: true,
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Intentar nuevamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRecommendations(
      CareersProvider provider,
      ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 42.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 10.h),
            Text(
              'Todavía no hay recomendaciones disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 10.h),
            TextButton.icon(
              onPressed: () {
                provider.fetchRecommendedCareers(
                  topN: 5,
                  force: true,
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar recomendaciones'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.radar_rounded,
            size: 52.sp,
            color: StudentUiColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Aún no hay resultados RIASEC',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Completa tus actividades para generar tu perfil vocacional.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
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
            'Completa todos los minijuegos para obtener tu '
                'perfil RIASEC y tus carreras recomendadas.',
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
                'Ir a los minijuegos',
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

  double _normalizeScore(dynamic value) {
    final raw = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;

    if (raw > 1 && raw <= 100) {
      return (raw / 100)
          .clamp(0.0, 1.0)
          .toDouble();
    }

    return raw.clamp(0.0, 1.0).toDouble();
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