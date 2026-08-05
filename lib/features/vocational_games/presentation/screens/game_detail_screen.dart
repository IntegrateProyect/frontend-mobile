import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../components/game_detail/game_timer_widget.dart';
import '../components/game_detail/game_error_view.dart';
import '../components/game_detail/game_exit_dialog.dart';
import '../components/game_detail/first_aid_dialog.dart';
import '../components/games_list/game_question_content.dart';
import '../components/games_list/game_success_content.dart';
import '../providers/games_provider.dart';
import '../providers/game_play_provider.dart';
import '../providers/game_persistence_provider.dart';
import 'game_result_screen.dart';

class GameDetailScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const GameDetailScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _successController;
  bool _showSuccess = false;
  GameQuestionOptionEntity? _selectedOption;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeGame());
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  Future<void> _initializeGame() async {
    final gamesProvider = context.read<GamesProvider>();
    final playProvider = context.read<GamePlayProvider>();
    final persistence = context.read<GamePersistenceProvider>();

    try {
      if (gamesProvider.miniGames.isEmpty) {
        await gamesProvider.fetchGames();
      }

      final miniGame = gamesProvider.miniGames.firstWhere(
        (mg) => mg.statusKey == widget.miniGameKey,
      );

      final savedIndex = persistence.getSavedIndex(widget.miniGameKey);
      final savedSession = persistence.getSavedSession(widget.miniGameKey);

      playProvider.setupSession(
        widget.game,
        miniGame.questions,
        savedIndex,
        savedSession,
      );

      if (savedSession == null) {
        await playProvider.startNewSession(widget.game.id);
        if (mounted) {
          await persistence.saveProgress(
            widget.miniGameKey,
            0,
            sessionId: playProvider.sessionId,
          );
        }
      }
    } catch (e) {
      debugPrint('Error initializing game: $e');
    }
  }

  Future<void> _handleAnswer(
    GameQuestionOptionEntity option,
    Map<String, dynamic> interactionData,
  ) async {
    final playProvider = context.read<GamePlayProvider>();
    final persistence = context.read<GamePersistenceProvider>();
    final question = playProvider.questions[playProvider.currentIndex];

    if (mounted) {
      setState(() {
        _selectedOption = option;
        _showSuccess = true;
      });
    }
    _successController.forward(from: 0);

    if (_isFirstAid(question.text)) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => FirstAidDialog(onContinue: () => Navigator.pop(context)),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (!mounted) return;

    try {
      await playProvider.submitAnswer(
        gameId: widget.game.id,
        questionId: question.id,
        optionId: option.id,
        answer: option.text,
        weights: option.weights,
        interactionData: interactionData,
      );

      if (mounted) {
        await persistence.saveProgress(
          widget.miniGameKey,
          playProvider.currentIndex,
        );
      }

      if (playProvider.currentIndex < playProvider.questions.length) {
        if (mounted) {
          setState(() {
            _showSuccess = false;
            _selectedOption = null;
            _secondsLeft = 60;
          });
        }
      } else {
        _finishGame();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showSuccess = false;
          _selectedOption = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _finishGame() async {
    final playProvider = context.read<GamePlayProvider>();
    final persistence = context.read<GamePersistenceProvider>();
    final gamesProvider = context.read<GamesProvider>();

    try {
      final result = await playProvider.finishSession(widget.game.id);
      await persistence.markAsCompleted(widget.miniGameKey);

      if (!mounted) return;

      if (persistence.areAllCompleted(gamesProvider.miniGames)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => GameResultScreen(result: result)),
        );
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error finishing game: $e');
    }
  }

  Future<bool> _onWillPop() async {
    final playProvider = context.read<GamePlayProvider>();
    if (playProvider.isSubmitting) return false;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => const GameExitDialog(),
    );

    return shouldExit ?? false;
  }

  bool _isFirstAid(String text) {
    final low = text.toLowerCase();
    return low.contains('primeros auxilios') || low.contains('herida') || low.contains('vendar');
  }

  @override
  Widget build(BuildContext context) {
    final playProvider = context.watch<GamePlayProvider>();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () async {
              if (await _onWillPop()) Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.game.title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: _buildBody(playProvider),
      ),
    );
  }

  Widget _buildBody(GamePlayProvider playProvider) {
    if (playProvider.isSubmitting && playProvider.questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (playProvider.errorMessage != null) {
      return GameErrorView(
        message: playProvider.errorMessage!,
        onRetry: _initializeGame,
      );
    }

    if (playProvider.questions.isEmpty) {
      return const Center(child: Text('No hay preguntas disponibles.'));
    }

    final question = playProvider.questions[playProvider.currentIndex];

    return Column(
      children: [
        GameTimerWidget(
          key: ValueKey(playProvider.currentIndex),
          totalSeconds: 60,
          onTick: (seconds) {
            if (mounted) {
              setState(() => _secondsLeft = seconds);
            }
          },
          onTimeExpired: () {
            final neutralOption = question.options[question.options.length ~/ 2];
            _handleAnswer(neutralOption, {'interactionType': 'TIMEOUT'});
          },
        ),
        Expanded(
          child: _showSuccess && _selectedOption != null
              ? GameSuccessContent(
                  questionText: question.text,
                  answer: _selectedOption!.text,
                  successAnimation: _successController,
                  currentIndex: playProvider.currentIndex,
                  totalQuestions: playProvider.questions.length,
                  secondsLeft: _secondsLeft,
                )
              : GameQuestionContent(
                  question: question,
                  miniGameKey: widget.miniGameKey,
                  currentIndex: playProvider.currentIndex,
                  totalQuestions: playProvider.questions.length,
                  secondsLeft: _secondsLeft,
                  isSending: playProvider.isSubmitting,
                  onAnswerSelected: (opt, data) => _handleAnswer(opt, data),
                ),
        ),
      ],
    );
  }
}
