import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../components/games_list/game_question_content.dart';
import '../components/games_list/game_success_content.dart';
import '../providers/games_provider.dart';
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
  State<GameDetailScreen> createState() {
    return _GameDetailScreenState();
  }
}

class _GameDetailScreenState extends State<GameDetailScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF311B92);

  static const int questionDurationSeconds = 60;

  int _currentIndex = 0;
  int _secondsLeft = questionDurationSeconds;

  bool _isSending = false;
  bool _showSuccess = false;
  bool _isStartingSession = true;
  bool _isExiting = false;

  String? _initializationError;

  Timer? _timer;

  DateTime _questionStartedAt = DateTime.now();

  GameQuestionOptionEntity? _selectedOption;

  late final AnimationController _successController;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  Future<void> _initializeGame() async {
    final provider = context.read<GamesProvider>();

    try {
      await provider.startSessionIfNeeded(
        widget.game.id,
        statusKey: widget.miniGameKey,
      );

      if (!mounted) {
        return;
      }

      final totalQuestions = provider.questions.length;
      final savedIndex = provider.savedIndex;

      final validIndex = savedIndex >= 0 &&
          savedIndex < totalQuestions
          ? savedIndex
          : 0;

      setState(() {
        _currentIndex = validIndex;
        _isStartingSession = false;
        _initializationError = null;
      });

      if (totalQuestions > 0) {
        _startTimer();
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error al iniciar el minijuego: '
            '$error\n$stackTrace',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isStartingSession = false;
        _initializationError =
        'No se pudo iniciar el minijuego.';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _successController.dispose();

    super.dispose();
  }

  void _startTimer() {
    if (!mounted) {
      return;
    }

    _timer?.cancel();

    _questionStartedAt = DateTime.now();

    setState(() {
      _secondsLeft = questionDurationSeconds;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_secondsLeft <= 1) {
          timer.cancel();

          setState(() {
            _secondsLeft = 0;
          });

          _autoAnswer();
          return;
        }

        setState(() {
          _secondsLeft--;
        });
      },
    );
  }

  Future<void> _autoAnswer() async {
    final provider = context.read<GamesProvider>();

    if (_isSending ||
        provider.questions.isEmpty ||
        _currentIndex >= provider.questions.length) {
      return;
    }

    final question = provider.questions[_currentIndex];

    if (question.options.isEmpty) {
      return;
    }

    /*
     * Para una escala de cinco opciones se usa la opción
     * central como respuesta neutral cuando termina el tiempo.
     */
    final neutralIndex = question.options.length ~/ 2;

    final automaticOption =
    question.options[neutralIndex];

    await _selectAnswer(
      automaticOption,
      <String, dynamic>{
        'interactionType': 'TIMEOUT',
        'inputMethod': 'automatic',
        'timeExpired': true,
        'layout': 'automatic',
      },
    );
  }

  Future<void> _selectAnswer(
      GameQuestionOptionEntity option,
      Map<String, dynamic> interactionData,
      ) async {
    if (_isSending) {
      return;
    }

    final provider = context.read<GamesProvider>();

    if (provider.questions.isEmpty ||
        _currentIndex >= provider.questions.length) {
      return;
    }

    final question = provider.questions[_currentIndex];

    final responseTimeMs = DateTime.now()
        .difference(_questionStartedAt)
        .inMilliseconds;

    _timer?.cancel();

    setState(() {
      _isSending = true;
      _selectedOption = option;
      _showSuccess = true;
    });

    _successController.forward(from: 0);

    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) {
      return;
    }

    try {
      await provider.sendAnswer(
        gameId: widget.game.id,
        questionId: question.id,
        optionId: option.id,
        answer: option.text,
        weights: option.weights,
        currentIndex: _currentIndex + 1,
        progressKey: widget.miniGameKey,
        interactionData: <String, dynamic>{
          ...interactionData,
          'miniGameKey': widget.miniGameKey,
          'questionType': question.type,
          'questionIndex': _currentIndex,
          'responseTimeMs': responseTimeMs,
          'secondsRemaining': _secondsLeft,
        },
      );

      final isLastQuestion =
          _currentIndex >= provider.questions.length - 1;

      if (!isLastQuestion) {
        if (!mounted) {
          return;
        }

        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _isSending = false;
          _showSuccess = false;
        });

        _startTimer();
        return;
      }

      final result = await provider.finishGame(
        widget.game.id,
        statusKey: widget.miniGameKey,
      );

      if (!mounted) {
        return;
      }

      _openResultScreen(result);
    } catch (error, stackTrace) {
      debugPrint(
        'Error al guardar la respuesta: '
            '$error\n$stackTrace',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSending = false;
        _showSuccess = false;
        _selectedOption = null;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ??
                  'No se pudo guardar la respuesta.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

      _startTimer();
    }
  }

  void _openResultScreen(
      Map<String, dynamic> result,
      ) {
    _timer?.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return GameResultScreen(
            result: result,
          );
        },
      ),
    );
  }

  Future<void> _exitGame() async {
    if (_isExiting || _isSending) {
      return;
    }

    _isExiting = true;
    _timer?.cancel();

    final provider = context.read<GamesProvider>();

    try {
      if (!_isStartingSession &&
          provider.questions.isNotEmpty) {
        await provider.saveProgress(
          gameId: widget.miniGameKey,
          currentIndex: _currentIndex,
        );
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error al guardar el progreso: '
            '$error\n$stackTrace',
      );
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();

    provider.clearQuestions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();

    return WillPopScope(
      onWillPop: () async {
        if (_isSending) {
          return false;
        }

        await _exitGame();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: 'Salir del minijuego',
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: _isSending
                ? null
                : _exitGame,
          ),
          title: Text(
            widget.game.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        body: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(
      GamesProvider provider,
      ) {
    if (_isStartingSession) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    if (_initializationError != null) {
      return _buildInitializationError();
    }

    if (provider.questions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay retos disponibles para este minijuego.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1D1B4B),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (_currentIndex < 0 ||
        _currentIndex >= provider.questions.length) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No se pudo encontrar la pregunta actual.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1D1B4B),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    final question = provider.questions[_currentIndex];

    if (_showSuccess &&
        _selectedOption != null) {
      return GameSuccessContent(
        questionText: question.text,
        answer: _selectedOption!.text,
        currentIndex: _currentIndex,
        totalQuestions: provider.questions.length,
        secondsLeft: _secondsLeft,
        successAnimation: _successController,
      );
    }

    return GameQuestionContent(
      question: question,
      miniGameKey: widget.miniGameKey,
      currentIndex: _currentIndex,
      totalQuestions: provider.questions.length,
      secondsLeft: _secondsLeft,
      isSending: _isSending,
      onAnswerSelected: _selectAnswer,
    );
  }

  Widget _buildInitializationError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _initializationError!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1D1B4B),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isStartingSession = true;
                  _initializationError = null;
                });

                _initializeGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Reintentar',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}