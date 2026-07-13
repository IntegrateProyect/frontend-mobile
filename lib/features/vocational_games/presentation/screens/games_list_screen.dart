import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/components/common/student_bottom_navigation_bar.dart';

import '../../domain/entities/vocational_mini_game_entity.dart';
import '../components/games_list/games_empty_state.dart';
import '../components/games_list/games_list_header.dart';
import '../components/games_list/games_loading_overlay.dart';
import '../components/games_list/vocational_mini_game_card.dart';
import '../providers/games_provider.dart';
import 'game_detail_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() {
    return _GamesListScreenState();
  }
}

class _GamesListScreenState extends State<GamesListScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color backgroundColor = Color(0xFFF8F9FE);

  bool _isOpeningGame = false;
  bool _isReturningHome = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GamesProvider>().fetchGames();
      }
    });
  }

  void _goToStudentHome() {
    if (!mounted || _isReturningHome) {
      return;
    }

    _isReturningHome = true;
    context.go(AppRoutes.home.path);
  }

  Future<bool> _handleSystemBack() async {
    _goToStudentHome();
    return true;
  }

  Future<void> _openMiniGame(
      GamesProvider provider,
      VocationalMiniGameEntity miniGame,
      ) async {
    if (_isOpeningGame || provider.isLoadingQuestions) {
      return;
    }

    setState(() {
      _isOpeningGame = true;
    });

    try {
      await provider.selectMiniGame(miniGame);

      if (!mounted) {
        return;
      }

      final game = provider.activeGame;

      if (game == null) {
        _showMessage(
          'No se pudo cargar el minijuego.',
        );
        return;
      }

      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => GameDetailScreen(
            game: game,
            miniGameKey: miniGame.statusKey,
          ),
        ),
      );

      if (mounted) {
        await provider.fetchGames();
      }
    } catch (error) {
      debugPrint('Error al abrir minijuego: $error');

      _showMessage(
        'Ocurrió un error al abrir el minijuego.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningGame = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

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
    final provider = context.watch<GamesProvider>();

    return BackButtonListener(
      onBackButtonPressed: _handleSystemBack,
      child: Scaffold(
        backgroundColor: backgroundColor,
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
          title: const Text(
            'Minijuegos vocacionales',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(provider),
        bottomNavigationBar: const StudentBottomNavigationBar(
          currentIndex: 1,
        ),
      ),
    );
  }

  Widget _buildBody(GamesProvider provider) {
    if (provider.isLoading && provider.miniGames.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: primaryColor,
          onRefresh: provider.fetchGames,
          child: provider.miniGames.isEmpty
              ? GamesEmptyState(
            isLoading: provider.isLoading,
            message: provider.errorMessage,
            onRetry: provider.fetchGames,
          )
              : ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(22),
            children: [
              const GamesListHeader(),
              ...provider.miniGames.asMap().entries.map(
                    (entry) {
                  final miniGame = entry.value;
                  final status = provider.getMiniGameStatus(
                    miniGame.statusKey,
                  );

                  return VocationalMiniGameCard(
                    miniGame: miniGame,
                    status: status,
                    progress: provider.getMiniGameProgress(
                      miniGame.statusKey,
                      miniGame.questions.length,
                    ),
                    animationIndex: entry.key,
                    onTap: () {
                      _openMiniGame(
                        provider,
                        miniGame,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        GamesLoadingOverlay(
          visible: _isOpeningGame || provider.isLoadingQuestions,
        ),
      ],
    );
  }
}