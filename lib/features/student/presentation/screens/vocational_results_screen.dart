import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/providers/careers_provider.dart';
import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';

import '../../../vocational_games/presentation/providers/games_provider.dart';
import '../../../vocational_games/presentation/providers/game_persistence_provider.dart';
import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';
import '../components/vocational_results/vocational_results_body.dart';

class VocationalResultsScreen extends StatefulWidget {
  const VocationalResultsScreen({super.key});

  @override
  State<VocationalResultsScreen> createState() =>
      _VocationalResultsScreenState();
}

class _VocationalResultsScreenState
    extends State<VocationalResultsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final resultsProvider = context.read<StudentResultsProvider>();
    final gamesProvider = context.read<GamesProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    final careersProvider = context.read<CareersProvider>();

    await resultsProvider.fetchResults();
    await gamesProvider.fetchGames();

    if (!mounted) return;

    await persistenceProvider.loadAllStatuses(gamesProvider.miniGames);

    if (resultsProvider.results.isNotEmpty &&
        !persistenceProvider.areAllCompleted(gamesProvider.miniGames)) {
      await persistenceProvider.markAllAsCompleted(gamesProvider.miniGames);
    }

    if (!mounted) return;

    if (persistenceProvider.areAllCompleted(gamesProvider.miniGames) &&
        resultsProvider.results.isNotEmpty) {
      await careersProvider.fetchRecommendedCareers(
        topN: 5,
      );
    }
  }

  Future<void> _refreshData() async {
    final resultsProvider = context.read<StudentResultsProvider>();
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
    final resultsProvider = context.watch<StudentResultsProvider>();
    final gamesProvider = context.watch<GamesProvider>();
    final persistenceProvider = context.watch<GamePersistenceProvider>();
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
        body: VocationalResultsBody(
          resultsProvider: resultsProvider,
          gamesProvider: gamesProvider,
          persistenceProvider: persistenceProvider,
          careersProvider: careersProvider,
          onRefresh: _refreshData,
          onGoToGames: () => context.go(AppRoutes.games.path),
        ),
        bottomNavigationBar: const StudentBottomNavigationBar(
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
}
