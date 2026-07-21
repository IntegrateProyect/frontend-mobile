import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/presentation/components/common/student_bottom_navigation_bar.dart';

import '../../domain/entities/vocational_game_kind.dart';
import '../../domain/entities/vocational_mini_game_entity.dart';

import '../components/games_list/games_empty_state.dart';
import '../components/games_list/games_list_header.dart';
import '../components/games_list/games_loading_overlay.dart';
import '../components/games_list/vocational_mini_game_card.dart';

import '../providers/games_provider.dart';

import 'games/consultorio_game_screen.dart';
import 'games/estudio_game_screen.dart';
import 'games/laboratorio_game_screen.dart';
import 'games/taller_game_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({
    super.key,
  });

  @override
  State<GamesListScreen> createState() {
    return _GamesListScreenState();
  }
}

class _GamesListScreenState
    extends State<GamesListScreen> {
  static const Color primaryColor =
  Color(0xFF311B92);

  static const Color backgroundColor =
  Color(0xFFF8F9FE);

  bool _isOpeningGame = false;
  bool _isReturningHome = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        final provider =
        context.read<GamesProvider>();

        /*
         * No vuelve a consultar el backend cuando
         * los minijuegos ya están cargados.
         */
        if (provider.miniGames.isEmpty &&
            !provider.isLoading &&
            !provider.isLoadingQuestions) {
          provider.fetchGames();
        } else {
          provider.refreshLocalStatuses();
        }
      },
    );
  }

  void _goToStudentHome() {
    if (!mounted || _isReturningHome) {
      return;
    }

    _isReturningHome = true;

    context.go(
      AppRoutes.home.path,
    );
  }

  Future<bool> _handleSystemBack() async {
    _goToStudentHome();

    return true;
  }

  Future<void> _refreshGames(
      GamesProvider provider,
      ) async {
    await provider.fetchGames(
      force: true,
    );

    if (!mounted) {
      return;
    }

    final message = provider.errorMessage;

    /*
     * Cuando ya existen tarjetas, el error no
     * aparece en GamesEmptyState. Por eso se muestra
     * como SnackBar después de deslizar para actualizar.
     */
    if (provider.miniGames.isNotEmpty &&
        message != null &&
        message.isNotEmpty) {
      _showMessage(message);
    }
  }

  Future<void> _retryGames(
      GamesProvider provider,
      ) async {
    await provider.fetchGames(
      force: true,
    );
  }

  Future<void> _openMiniGame(
      GamesProvider provider,
      VocationalMiniGameEntity miniGame,
      ) async {
    if (_isOpeningGame ||
        provider.isLoadingQuestions) {
      return;
    }

    if (miniGame.questions.isEmpty) {
      _showMessage(
        'Este minijuego todavía no tiene preguntas.',
      );

      return;
    }

    setState(() {
      _isOpeningGame = true;
    });

    try {
      await provider.selectMiniGame(
        miniGame,
      );

      if (!mounted) {
        return;
      }

      final game = provider.activeGame;

      if (game == null) {
        _showMessage(
          'No se pudo identificar el juego seleccionado.',
        );

        return;
      }

      /*
       * Inicia o recupera la sesión antes de
       * abrir la pantalla de Flame.
       */
      await provider.startSessionIfNeeded(
        game.id,
        statusKey: miniGame.statusKey,
      );

      if (!mounted) {
        return;
      }

      late final Widget destination;

      switch (miniGame.kind) {
        case VocationalGameKind.laboratorio:
          destination =
              LaboratorioGameScreen(
                game: game,
                miniGameKey:
                miniGame.statusKey,
              );
          break;

        case VocationalGameKind.consultorio:
          destination =
              ConsultorioGameScreen(
                game: game,
                miniGameKey:
                miniGame.statusKey,
              );
          break;

        case VocationalGameKind.taller:
          destination =
              TallerGameScreen(
                game: game,
                miniGameKey:
                miniGame.statusKey,
              );
          break;

        case VocationalGameKind.estudio:
          destination =
              EstudioGameScreen(
                game: game,
                miniGameKey:
                miniGame.statusKey,
              );
          break;
      }

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => destination,
        ),
      );

      if (!mounted) {
        return;
      }

      /*
       * Al regresar solamente se leen los estados
       * guardados localmente.
       *
       * Aquí ya no se llama fetchGames(), porque
       * eso producía solicitudes repetidas al backend.
       */
      await provider.refreshLocalStatuses();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al abrir el minijuego: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        provider.errorMessage ??
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
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<GamesProvider>();

    return BackButtonListener(
      onBackButtonPressed:
      _handleSystemBack,
      child: Scaffold(
        backgroundColor:
        backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading:
          false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip:
            'Regresar al inicio',
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed:
            _goToStudentHome,
          ),
          title: const Text(
            'Minijuegos vocacionales',
            style: TextStyle(
              color: Colors.black,
              fontWeight:
              FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(provider),
        bottomNavigationBar:
        const StudentBottomNavigationBar(
          currentIndex: 1,
        ),
      ),
    );
  }

  Widget _buildBody(
      GamesProvider provider,
      ) {
    if (provider.isLoading &&
        provider.miniGames.isEmpty) {
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
          onRefresh: () {
            return _refreshGames(
              provider,
            );
          },
          child:
          provider.miniGames.isEmpty
              ? GamesEmptyState(
            isLoading:
            provider.isLoading,
            message:
            provider.errorMessage,
            onRetry: () {
              return _retryGames(
                provider,
              );
            },
          )
              : ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding:
            const EdgeInsets.all(
              22,
            ),
            children: [
              const GamesListHeader(),
              ...provider
                  .miniGames
                  .asMap()
                  .entries
                  .map(
                    (entry) {
                  final miniGame =
                      entry.value;

                  final status =
                  provider
                      .getMiniGameStatus(
                    miniGame
                        .statusKey,
                  );

                  final progress =
                  provider
                      .getMiniGameProgress(
                    miniGame
                        .statusKey,
                    miniGame
                        .questions
                        .length,
                  );

                  return VocationalMiniGameCard(
                    miniGame:
                    miniGame,
                    status:
                    status,
                    progress:
                    progress,
                    animationIndex:
                    entry.key,
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
          visible:
          _isOpeningGame ||
              provider.isLoadingQuestions,
        ),
      ],
    );
  }
}