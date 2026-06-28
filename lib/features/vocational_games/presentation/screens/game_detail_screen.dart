import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../providers/games_provider.dart';

class GameDetailScreen extends StatefulWidget {
  final GameEntity game;

  const GameDetailScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen>
    with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  int _currentIndex = 0;
  int _secondsLeft = 60;
  Timer? _timer;

  bool _isSending = false;
  bool _showSuccess = false;

  GameQuestionOptionEntity? _selectedOption;

  late AnimationController _sceneController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();

    _sceneController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Future.microtask(() {
      final provider = context.read<GamesProvider>();
      if (provider.questions.isNotEmpty) {
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sceneController.dispose();
    _successController.dispose();
    context.read<GamesProvider>().clearQuestions();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsLeft <= 1) {
        timer.cancel();
        _autoAnswer();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _autoAnswer() async {
    final provider = context.read<GamesProvider>();
    if (_isSending || provider.questions.isEmpty) return;

    final question = provider.questions[_currentIndex];
    if (question.options.isEmpty) return;

    final option =
    question.options.length >= 3 ? question.options[2] : question.options.first;

    await _selectAnswer(option);
  }

  Future<void> _selectAnswer(GameQuestionOptionEntity option) async {
    if (_isSending) return;

    final provider = context.read<GamesProvider>();
    if (provider.questions.isEmpty) return;

    final question = provider.questions[_currentIndex];

    _timer?.cancel();

    setState(() {
      _isSending = true;
      _selectedOption = option;
      _showSuccess = true;
    });

    _successController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 1000));

    await provider.sendAnswer(
      gameId: widget.game.id,
      questionId: question.id,
      optionId: option.id,
      answer: option.text,
      weights: option.weights,
    );

    if (_currentIndex < provider.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isSending = false;
        _showSuccess = false;
      });

      _sceneController.forward(from: 0);
      _startTimer();
    } else {
      await provider.finishGame(widget.game.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minijuego vocacional finalizado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.game.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.questions.isEmpty
          ? const Center(child: Text('No hay retos disponibles.'))
          : _buildGame(provider),
    );
  }

  Widget _buildGame(GamesProvider provider) {
    final question = provider.questions[_currentIndex];
    final scene = _detectScene(question.text);
    final isBinary = question.options.length == 2;

    if (_showSuccess && _selectedOption != null) {
      return _buildSuccessScene(scene, _selectedOption!.text);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
        child: Column(
          children: [
            _buildHeader(provider.questions.length),
            const SizedBox(height: 22),
            Text(
              _formatQuestion(question.text, isBinary),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: darkText,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isBinary ? 'Arrastra tu respuesta' : 'Arrastra la ficha a tu nivel de interés',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _sceneController,
                builder: (_, __) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: _sceneGradient(scene),
                    ),
                    child: CustomPaint(
                      painter: _InteractiveScenePainter(
                        scene: scene,
                        variant: _currentIndex % 3,
                        progress: _sceneController.value,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            _buildDragToken(),
            const SizedBox(height: 12),
            isBinary ? _buildBinaryTargets(question) : _buildLikertTargets(question),
            const SizedBox(height: 10),
            Text(
              'Responde rápido con tu primera impresión.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int total) {
    final progress = (_currentIndex + 1) / total;

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Reto ${_currentIndex + 1} de $total',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: primaryColor, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: primaryColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '00:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            color: primaryColor,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _buildDragToken() {
    return Draggable<int>(
      data: 1,
      feedback: Material(
        color: Colors.transparent,
        child: _token(size: 70, dragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: _token(size: 64),
      ),
      child: _token(size: 64),
    );
  }

  Widget _token({required double size, bool dragging = false}) {
    return AnimatedScale(
      scale: dragging ? 1.12 : 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.touch_app, color: Colors.white, size: 34),
      ),
    );
  }

  Widget _buildBinaryTargets(GameQuestionEntity question) {
    return Row(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final positive = index == 0;

        return Expanded(
          child: DragTarget<int>(
            onWillAccept: (_) => !_isSending,
            onAccept: (_) => _selectAnswer(option),
            builder: (context, candidateData, rejectedData) {
              final hover = candidateData.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                height: hover ? 154 : 140,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: hover
                      ? (positive ? Colors.green : Colors.red).withOpacity(0.20)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: positive ? Colors.green : Colors.red,
                    width: hover ? 4 : 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      positive ? Icons.check_circle : Icons.cancel,
                      color: positive ? Colors.green : Colors.red,
                      size: hover ? 62 : 52,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      option.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildLikertTargets(GameQuestionEntity question) {
    final icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.lightGreen,
      Colors.green,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: List.generate(question.options.length, (index) {
          final option = question.options[index];

          return Expanded(
            child: DragTarget<int>(
              onWillAccept: (_) => !_isSending,
              onAccept: (_) => _selectAnswer(option),
              builder: (context, candidateData, rejectedData) {
                final hover = candidateData.isNotEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: hover ? colors[index].withOpacity(0.18) : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: hover ? colors[index] : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CircleAvatar(
                        radius: hover ? 29 : 25,
                        backgroundColor: colors[index].withOpacity(0.18),
                        child: Icon(
                          icons[index],
                          color: colors[index],
                          size: hover ? 34 : 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 31,
                        child: Text(
                          option.text,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSuccessScene(_SceneType scene, String answer) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            _buildHeader(context.read<GamesProvider>().questions.length),
            const SizedBox(height: 30),
            const Text(
              '¡Genial!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu elección: $answer',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _successController,
                builder: (_, __) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: _sceneGradient(scene),
                    ),
                    child: CustomPaint(
                      painter: _SuccessScenePainter(
                        scene: scene,
                        progress: _successController.value,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Continuamos...',
              style: TextStyle(
                color: primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _successController.value,
                minHeight: 8,
                color: primaryColor,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatQuestion(String text, bool binary) {
    if (!binary) return text;
    final clean = text.trim();
    if (clean.isEmpty || clean.startsWith('¿')) return clean;
    return '¿Te gusta ${clean[0].toLowerCase()}${clean.substring(1)}?';
  }

  _SceneType _detectScene(String raw) {
    final text = raw.toLowerCase();

    if (_has(text, ['música', 'musica', 'concierto', 'instrumento', 'coral', 'compositor', 'discos'])) {
      return _SceneType.music;
    }

    if (_has(text, ['licuadora', 'máquina', 'maquina', 'taladro', 'reparar', 'soldar', 'reloj', 'eléctrico', 'electrico', 'torno', 'muebles'])) {
      return _SceneType.mechanic;
    }

    if (_has(text, ['pintar', 'óleo', 'oleo', 'arte', 'dibujar', 'mosaicos', 'decoración', 'decoracion', 'paisajes', 'tapices'])) {
      return _SceneType.art;
    }

    if (_has(text, ['eclipse', 'telescopio', 'estrellas', 'observatorio', 'energía atómica', 'energia atomica', 'rocas', 'espectro'])) {
      return _SceneType.space;
    }

    if (_has(text, ['sangre', 'plantas', 'abejas', 'insectos', 'hormigas', 'organismos', 'acuario', 'oxígeno', 'oxigeno'])) {
      return _SceneType.bio;
    }

    if (_has(text, ['calcular', 'aritmética', 'aritmetica', 'numérico', 'numerico', 'porcentajes', 'logaritmos', 'matemáticos', 'matematicos', 'convertir', 'radios', 'grados', 'área', 'area'])) {
      return _SceneType.math;
    }

    if (_has(text, ['escribir', 'cuentos', 'novelas', 'literatura', 'biblioteca', 'periódico', 'periodico', 'cartas', 'clásicos', 'clasicos'])) {
      return _SceneType.literary;
    }

    if (_has(text, ['ayudar', 'orfelinatos', 'consejero', 'niños', 'ninos', 'ciegos', 'escuchar', 'servir', 'problemas'])) {
      return _SceneType.social;
    }

    if (_has(text, ['debates', 'argumentos', 'convencer', 'defender', 'líder', 'lider', 'dirigir', 'campañas', 'campanas', 'producto'])) {
      return _SceneType.persuasive;
    }

    return _SceneType.general;
  }

  bool _has(String text, List<String> words) {
    return words.any((word) => text.contains(word));
  }

  LinearGradient _sceneGradient(_SceneType scene) {
    switch (scene) {
      case _SceneType.music:
        return const LinearGradient(colors: [Color(0xFFFFF7E8), Color(0xFFFFD36E)]);
      case _SceneType.mechanic:
        return const LinearGradient(colors: [Color(0xFFFFF1E9), Color(0xFFE7F0FF)]);
      case _SceneType.art:
        return const LinearGradient(colors: [Color(0xFFE6F7FF), Color(0xFFFFF4D8)]);
      case _SceneType.space:
        return const LinearGradient(colors: [Color(0xFFEAE8FF), Color(0xFF1D1B4B)]);
      case _SceneType.bio:
        return const LinearGradient(colors: [Color(0xFFE8FFF2), Color(0xFFC7F2D4)]);
      case _SceneType.math:
        return const LinearGradient(colors: [Color(0xFFEDEAFF), Color(0xFFD9F0FF)]);
      case _SceneType.literary:
        return const LinearGradient(colors: [Color(0xFFFFF4E8), Color(0xFFE8D2B8)]);
      case _SceneType.social:
        return const LinearGradient(colors: [Color(0xFFFFEAF2), Color(0xFFFFD4E5)]);
      case _SceneType.persuasive:
        return const LinearGradient(colors: [Color(0xFFFFF3E0), Color(0xFFFFB74D)]);
      case _SceneType.general:
        return const LinearGradient(colors: [Color(0xFFEDEAFF), Color(0xFFF8F9FE)]);
    }
  }
}

enum _SceneType {
  music,
  mechanic,
  art,
  space,
  bio,
  math,
  literary,
  social,
  persuasive,
  general,
}

class _InteractiveScenePainter extends CustomPainter {
  final _SceneType scene;
  final int variant;
  final double progress;

  _InteractiveScenePainter({
    required this.scene,
    required this.variant,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final t = sin(progress * pi * 2);

    _soft(canvas, size);

    switch (scene) {
      case _SceneType.music:
        variant == 0 ? _music1(canvas, c, t) : variant == 1 ? _music2(canvas, c, t) : _music3(canvas, c, t);
        break;
      case _SceneType.mechanic:
        variant == 0 ? _mechanic1(canvas, c, t) : variant == 1 ? _mechanic2(canvas, c, t) : _mechanic3(canvas, c, t);
        break;
      case _SceneType.art:
        variant == 0 ? _art1(canvas, c, t) : variant == 1 ? _art2(canvas, c, t) : _art3(canvas, c, t);
        break;
      case _SceneType.space:
        variant == 0 ? _space1(canvas, c, t) : variant == 1 ? _space2(canvas, c, t) : _space3(canvas, c, t);
        break;
      case _SceneType.bio:
        variant == 0 ? _bio1(canvas, c, t) : variant == 1 ? _bio2(canvas, c, t) : _bio3(canvas, c, t);
        break;
      case _SceneType.math:
        variant == 0 ? _math1(canvas, c, t) : variant == 1 ? _math2(canvas, c, t) : _math3(canvas, c, t);
        break;
      case _SceneType.literary:
        variant == 0 ? _book1(canvas, c, t) : variant == 1 ? _book2(canvas, c, t) : _book3(canvas, c, t);
        break;
      case _SceneType.social:
        variant == 0 ? _social1(canvas, c, t) : variant == 1 ? _social2(canvas, c, t) : _social3(canvas, c, t);
        break;
      case _SceneType.persuasive:
        variant == 0 ? _persuasive1(canvas, c, t) : variant == 1 ? _persuasive2(canvas, c, t) : _persuasive3(canvas, c, t);
        break;
      case _SceneType.general:
        _general(canvas, c, t);
        break;
    }
  }

  void _soft(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.32);
    canvas.drawCircle(Offset(size.width * .22, size.height * .18), 60, p);
    canvas.drawCircle(Offset(size.width * .82, size.height * .25), 42, p);
  }

  void _music1(Canvas c, Offset o, double t) => _emoji(c, '🎹', o + Offset(0, 35 + t * 8), 105);
  void _music2(Canvas c, Offset o, double t) { _emoji(c, '🎧', o, 100); _emoji(c, '♫', o + Offset(-95, -65 + t * 8), 42); _emoji(c, '♪', o + Offset(95, 65 - t * 8), 42); }
  void _music3(Canvas c, Offset o, double t) { _emoji(c, '🎤', o, 95); _emoji(c, '✨', o + Offset(-80, -70), 34); _emoji(c, '🎶', o + Offset(85, 80), 42); }

  void _mechanic1(Canvas c, Offset o, double t) { _emoji(c, '🔧', o + Offset(-60, t * 8), 80); _emoji(c, '⚙️', o + Offset(60, -t * 8), 80); }
  void _mechanic2(Canvas c, Offset o, double t) { _emoji(c, '🔌', o + Offset(-60, 20), 80); _emoji(c, '💡', o + Offset(60, -20 + t * 8), 80); }
  void _mechanic3(Canvas c, Offset o, double t) { _emoji(c, '🛠️', o, 110); _emoji(c, '✨', o + Offset(85, -70), 36); }

  void _art1(Canvas c, Offset o, double t) { _emoji(c, '🎨', o, 105); _emoji(c, '🖌️', o + Offset(90, 70 + t * 5), 48); }
  void _art2(Canvas c, Offset o, double t) { _emoji(c, '🖼️', o, 110); _emoji(c, '🌈', o + Offset(0, -95), 48); }
  void _art3(Canvas c, Offset o, double t) { _emoji(c, '✏️', o + Offset(-55, 0), 80); _emoji(c, '📐', o + Offset(55, 0), 80); }

  void _space1(Canvas c, Offset o, double t) { _emoji(c, '🔭', o + Offset(0, 70), 75); _emoji(c, '🌙', o + Offset(0, -45 + t * 6), 95); }
  void _space2(Canvas c, Offset o, double t) { _emoji(c, '🪐', o, 105); _emoji(c, '✨', o + Offset(-90, -80), 36); _emoji(c, '⭐', o + Offset(90, 80), 36); }
  void _space3(Canvas c, Offset o, double t) { _emoji(c, '☄️', o + Offset(t * 25, 0), 100); _emoji(c, '🌌', o + Offset(0, 95), 45); }

  void _bio1(Canvas c, Offset o, double t) { _emoji(c, '🧬', o + Offset(0, t * 6), 105); _emoji(c, '🔬', o + Offset(95, 70), 50); }
  void _bio2(Canvas c, Offset o, double t) { _emoji(c, '🌱', o, 105); _emoji(c, '💧', o + Offset(-75, -75 + t * 8), 42); }
  void _bio3(Canvas c, Offset o, double t) { _emoji(c, '🩸', o + Offset(-45, 0), 80); _emoji(c, '🧪', o + Offset(55, 0), 90); }

  void _math1(Canvas c, Offset o, double t) { _emoji(c, '📐', o + Offset(-65, -15), 80); _emoji(c, '🧮', o + Offset(65, 15), 80); _text(c, 'rad → °', o + Offset(0, 105), 34); }
  void _math2(Canvas c, Offset o, double t) { _text(c, 'π', o + Offset(-70, -30), 70); _text(c, '360°', o + Offset(60, 35 + t * 5), 46); _emoji(c, '📏', o + Offset(0, 95), 55); }
  void _math3(Canvas c, Offset o, double t) { _text(c, '√%', o + Offset(-55, 0), 58); _emoji(c, '🧩', o + Offset(60, t * 7), 85); }

  void _book1(Canvas c, Offset o, double t) { _emoji(c, '📖', o + Offset(0, t * 5), 110); }
  void _book2(Canvas c, Offset o, double t) { _emoji(c, '✍️', o, 100); _text(c, 'A+', o + Offset(-90, 75), 42); }
  void _book3(Canvas c, Offset o, double t) { _emoji(c, '📰', o, 105); _emoji(c, '💡', o + Offset(90, -70), 40); }

  void _social1(Canvas c, Offset o, double t) { _emoji(c, '🤝', o + Offset(0, t * 5), 110); }
  void _social2(Canvas c, Offset o, double t) { _emoji(c, '❤️', o + Offset(-55, 0), 75); _emoji(c, '💬', o + Offset(55, 0), 75); }
  void _social3(Canvas c, Offset o, double t) { _emoji(c, '🧑‍🤝‍🧑', o, 100); _emoji(c, '✨', o + Offset(90, -70), 35); }

  void _persuasive1(Canvas c, Offset o, double t) { _emoji(c, '🎤', o, 105); _emoji(c, '💬', o + Offset(90, -70), 42); }
  void _persuasive2(Canvas c, Offset o, double t) { _emoji(c, '🗣️', o + Offset(-50, 0), 85); _emoji(c, '📢', o + Offset(60, 0), 85); }
  void _persuasive3(Canvas c, Offset o, double t) { _emoji(c, '🏆', o, 100); _text(c, 'IDEA', o + Offset(0, 95), 34, color: Colors.orange); }

  void _general(Canvas c, Offset o, double t) { _emoji(c, '🎯', o + Offset(0, t * 5), 105); }

  void _emoji(Canvas canvas, String text, Offset pos, double size) => _text(canvas, text, pos, size);

  void _text(Canvas canvas, String text, Offset pos, double size, {Color color = Colors.black}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w900)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _InteractiveScenePainter oldDelegate) => true;
}

class _SuccessScenePainter extends CustomPainter {
  final _SceneType scene;
  final double progress;

  _SuccessScenePainter({required this.scene, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, 50 + progress * 120, Paint()..color = Colors.white.withOpacity(0.30));

    final emoji = switch (scene) {
      _SceneType.music => '🎹',
      _SceneType.mechanic => '🔧',
      _SceneType.art => '🎨',
      _SceneType.space => '🔭',
      _SceneType.bio => '🧬',
      _SceneType.math => '🧮',
      _SceneType.literary => '📖',
      _SceneType.social => '🤝',
      _SceneType.persuasive => '🎤',
      _SceneType.general => '🎯',
    };

    final tp = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 130)),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SuccessScenePainter oldDelegate) => true;
}