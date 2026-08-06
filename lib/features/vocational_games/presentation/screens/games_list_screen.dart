import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';

import '../../domain/entities/vocational_mini_game_entity.dart';
import '../components/games_list/games_empty_state.dart';
import '../components/games_list/games_loading_overlay.dart';
import '../components/games_list/games_list_body.dart';
import '../providers/games_provider.dart';
import '../providers/game_play_provider.dart';
import '../providers/game_persistence_provider.dart';
import 'game_detail_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  bool _isOpeningGame = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  Future<void> _initData() async {
    if (!mounted) return;

    final gamesProvider = context.read<GamesProvider>();
    final persistenceProvider = context.read<GamePersistenceProvider>();
    final resultsProvider = context.read<StudentResultsProvider>();

    try {
      await gamesProvider.fetchGames();
      if (!mounted) return;

      await persistenceProvider.loadAllStatuses(gamesProvider.miniGames);
      await resultsProvider.fetchResults();

      if (mounted && 
          resultsProvider.results.isNotEmpty && 
          !persistenceProvider.areAllCompleted(gamesProvider.miniGames)) {
        await persistenceProvider.markAllAsCompleted(gamesProvider.miniGames);
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  Future<void> _refreshGames() async {
    final gamesProvider = context.read<GamesProvider>();
    await gamesProvider.fetchGames(force: true);
    if (mounted && gamesProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gamesProvider.errorMessage!), 
          behavior: SnackBarBehavior.floating
        ),
      );
    }
  }

  Future<void> _onGameTap(VocationalMiniGameEntity miniGame) async {
    if (_isOpeningGame) return;
    if (miniGame.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este minijuego aún no tiene preguntas.'), 
          behavior: SnackBarBehavior.floating
        ),
      );
      return;
    }

    setState(() => _isOpeningGame = true);

    try {
      final gamesProvider = context.read<GamesProvider>();
      final playProvider = context.read<GamePlayProvider>();
      final persistenceProvider = context.read<GamePersistenceProvider>();

      if (gamesProvider.games.isEmpty) return;

      final activeGame = gamesProvider.games.first;
      final savedIndex = persistenceProvider.getSavedIndex(miniGame.statusKey);
      final savedSession = persistenceProvider.getSavedSession(miniGame.statusKey);

      playProvider.setupSession(activeGame, miniGame.questions, savedIndex, savedSession);

      if (savedSession == null) {
        await playProvider.startNewSession(activeGame.id);
        if (mounted) {
          await persistenceProvider.saveProgress(
            miniGame.statusKey, 
            0, 
            sessionId: playProvider.sessionId
          );
        }
      }

      if (mounted) {
        _navigateToGame(miniGame);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir el juego: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isOpeningGame = false);
    }
  }

  void _navigateToGame(VocationalMiniGameEntity miniGame) {
    final gamesProvider = context.read<GamesProvider>();
    if (gamesProvider.games.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameDetailScreen(
          game: gamesProvider.games.first,
          miniGameKey: miniGame.statusKey,
        ),
      ),
    ).then((_) {
      if (mounted) _initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        surfaceTintColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.go(AppRoutes.home.path),
        ),
        title: Text(
          'Minijuegos vocacionales', 
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w900, 
            fontSize: 18
          )
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshGames,
            child: provider.miniGames.isEmpty && !provider.isLoading
                ? GamesEmptyState(
                    isLoading: provider.isLoading, 
                    message: provider.errorMessage, 
                    onRetry: _refreshGames
                  )
                : GamesListBody(
                    miniGames: provider.miniGames,
                    onGameTap: _onGameTap,
                  ),
          ),
          if (provider.isLoading || _isOpeningGame) 
            const GamesLoadingOverlay(visible: true),
        ],
      ),
    );
  }
}
