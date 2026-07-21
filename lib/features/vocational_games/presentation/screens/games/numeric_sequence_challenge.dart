import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class NumericSequenceConfig {
  final String backgroundAsset;
  final List<String> sequenceValues;
  final int missingIndex;
  final List<Vector2> flaskFractions;
  final List<String> optionLabels;
  final List<Vector2> optionFractions;

  /*
   * Se conservan para que el código anterior
   * que construye esta configuración siga compilando.
   */
  final Vector2 skipButtonFraction;
  final Vector2 skipButtonSizeFraction;

  final String correctAnswer;

  NumericSequenceConfig({
    required this.backgroundAsset,
    required this.sequenceValues,
    required this.missingIndex,
    required this.flaskFractions,
    required this.optionLabels,
    required this.optionFractions,
    required this.skipButtonFraction,
    required this.skipButtonSizeFraction,
    this.correctAnswer = '16',
  });

  static final NumericSequenceConfig defaultConfig =
  NumericSequenceConfig(
    backgroundAsset: 'rompecabezasnumericos.png',
    sequenceValues: const [
      '2',
      '4',
      '8',
      '?',
      '32',
    ],
    missingIndex: 3,
    flaskFractions: [
      Vector2(0.145, 0.45),
      Vector2(0.335, 0.45),
      Vector2(0.525, 0.45),
      Vector2(0.685, 0.44),
      Vector2(0.875, 0.45),
    ],
    optionLabels: const [
      '12',
      '16',
      '24',
    ],
    optionFractions: [
      Vector2(0.21, 0.685),
      Vector2(0.51, 0.685),
      Vector2(0.80, 0.685),
    ],
    skipButtonFraction: Vector2(0.72, 0.81),
    skipButtonSizeFraction: Vector2(0.28, 0.045),
    correctAnswer: '16',
  );
}

class NumericSequenceChallengeComponent
    extends PositionComponent {
  final NumericSequenceConfig config;

  final void Function(
      int level,
      Map<String, dynamic> meta,
      ) onFinish;

  late final Vector2 _targetPosition;
  late final _FlaskTargetGlow _targetGlow;
  late final _FeedbackBanner _feedbackBanner;
  late final _HintButton _hintButton;

  final List<_DraggableNumberCard> _cards = [];
  final List<Map<String, dynamic>> _attemptHistory = [];
  final List<int> _hintTimestampsMs = [];

  TextComponent? _missingValueText;

  bool _touchedAny = false;
  bool _completed = false;
  bool _locked = false;
  bool _isValidating = false;

  int _attempts = 0;
  int _incorrectAttempts = 0;
  int _hintsUsed = 0;

  String? _selectedAnswer;

  final DateTime _startedAt = DateTime.now();
  DateTime? _firstActionAt;
  DateTime? _firstHintAt;

  NumericSequenceChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.topCenter,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _validateConfiguration();

    await _addBackground();

    _addInstruction();

    _configureTargetPosition();
    _addTargetGlow();
    _addSequenceNumbers();
    _addOptionCards();
    _addFeedbackBanner();
    _addHintButton();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(
        config.backgroundAsset,
      );

      add(
        SpriteComponent(
          sprite: sprite,
          position: Vector2.zero(),
          size: size,
          priority: -100,
        ),
      );
    } catch (error) {
      debugPrint(
        'No se pudo cargar '
            '${config.backgroundAsset}: $error',
      );

      add(
        RectangleComponent(
          size: size,
          priority: -100,
          paint: Paint()
            ..color = const Color(0xFF06172D),
        ),
      );
    }
  }

  void _validateConfiguration() {
    if (config.sequenceValues.length !=
        config.flaskFractions.length) {
      throw ArgumentError(
        'sequenceValues y flaskFractions deben tener '
            'la misma cantidad.',
      );
    }

    if (config.optionLabels.length !=
        config.optionFractions.length) {
      throw ArgumentError(
        'optionLabels y optionFractions deben tener '
            'la misma cantidad.',
      );
    }

    if (config.missingIndex < 0 ||
        config.missingIndex >=
            config.sequenceValues.length) {
      throw ArgumentError(
        'missingIndex está fuera del rango permitido.',
      );
    }

    if (!config.optionLabels.contains(
      config.correctAnswer,
    )) {
      throw ArgumentError(
        'La respuesta correcta debe existir '
            'dentro de optionLabels.',
      );
    }
  }

  void _addInstruction() {
    add(
      TextBoxComponent(
        text:
        'Observa el patrón y arrastra la tarjeta '
            'correcta hasta el frasco vacío.',
        position: Vector2(
          size.x / 2,
          size.y * 0.035,
        ),
        size: Vector2(
          size.x - 36,
          54,
        ),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 10,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFD9F4FF),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  void _configureTargetPosition() {
    final targetFraction =
    config.flaskFractions[
    config.missingIndex];

    _targetPosition = Vector2(
      size.x * targetFraction.x,
      size.y * targetFraction.y,
    );
  }

  void _addTargetGlow() {
    _targetGlow = _FlaskTargetGlow(
      position: _targetPosition.clone(),
      size: Vector2(
        size.x * 0.19,
        size.y * 0.17,
      ),
    );

    add(_targetGlow);
  }

  void _addSequenceNumbers() {
    for (var index = 0;
    index < config.sequenceValues.length;
    index++) {
      final fraction =
      config.flaskFractions[index];

      final numberPosition = Vector2(
        size.x * fraction.x,
        size.y * fraction.y,
      );

      final isMissing =
          index == config.missingIndex;

      final numberText = TextComponent(
        text: isMissing
            ? '?'
            : config.sequenceValues[index],
        position: numberPosition,
        anchor: Anchor.center,
        priority: 3,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      );

      if (isMissing) {
        _missingValueText = numberText;
      }

      add(numberText);
    }
  }

  void _addOptionCards() {
    for (var index = 0;
    index < config.optionLabels.length;
    index++) {
      final fraction =
      config.optionFractions[index];

      final card = _DraggableNumberCard(
        label: config.optionLabels[index],
        position: Vector2(
          size.x * fraction.x,
          size.y * fraction.y,
        ),
        targetPositionProvider:
            () => _targetPosition,
        onTouched: _registerFirstAction,
        onHoverChanged: (hovering) {
          if (_locked || _isValidating) {
            return;
          }

          _targetGlow.setHovering(
            hovering,
          );
        },
        onDropped: _onCardDropped,
      );

      _cards.add(card);
      add(card);
    }
  }

  void _addFeedbackBanner() {
    _feedbackBanner = _FeedbackBanner(
      position: Vector2(
        size.x / 2,
        size.y * 0.16,
      ),
      size: Vector2(
        size.x - 42,
        58,
      ),
    );

    add(_feedbackBanner);
  }

  void _addHintButton() {
    _hintButton = _HintButton(
      label: '💡 Pista',
      position: Vector2(
        size.x / 2,
        size.y * 0.83,
      ),
      size: Vector2(
        150,
        43,
      ),
      onPressed: showHint,
    );

    add(_hintButton);
  }

  void _registerFirstAction() {
    _touchedAny = true;
    _firstActionAt ??= DateTime.now();
  }

  /// Método público para mostrar una pista.
  ///
  /// También puede llamarse desde un overlay Flutter.
  void showHint() {
    if (_locked ||
        _isValidating ||
        _hintsUsed >= 3) {
      return;
    }

    _hintsUsed++;

    final now = DateTime.now();

    _firstHintAt ??= now;

    _hintTimestampsMs.add(
      now.difference(_startedAt).inMilliseconds,
    );

    _targetGlow.showHint();

    switch (_hintsUsed) {
      case 1:
        _feedbackBanner.showMessage(
          'Observa: 2 pasa a 4 y 4 pasa a 8. '
              '¿Qué operación se repite?',
          const Color(0xFF29B6F6),
        );

        _hintButton.setLabel(
          '💡 Otra pista',
        );
        break;

      case 2:
        _feedbackBanner.showMessage(
          'Cada número es el doble del anterior. '
              'Calcula 8 × 2.',
          const Color(0xFFFFC857),
        );

        _correctCard?.hintPulse(
          strong: false,
        );

        _hintButton.setLabel(
          '💡 Última pista',
        );
        break;

      case 3:
        _feedbackBanner.showMessage(
          '8 × 2 = 16. Arrastra la tarjeta 16 '
              'hasta el frasco vacío.',
          const Color(0xFFFFC857),
        );

        _correctCard?.hintPulse(
          strong: true,
        );

        _hintButton.setLabel(
          '✓ Pista completa',
        );

        _hintButton.disable();
        break;
    }
  }

  _DraggableNumberCard? get _correctCard {
    for (final card in _cards) {
      if (card.label ==
          config.correctAnswer) {
        return card;
      }
    }

    return null;
  }

  void _onCardDropped(
      _DraggableNumberCard card,
      ) {
    if (_locked || _isValidating) {
      card.returnToOriginalPosition();
      return;
    }

    _registerFirstAction();

    _attempts++;

    final isCorrect =
        card.label == config.correctAnswer;

    final elapsedMilliseconds =
        DateTime.now()
            .difference(_startedAt)
            .inMilliseconds;

    _attemptHistory.add(
      <String, dynamic>{
        'selectedAnswer': card.label,
        'isCorrect': isCorrect,
        'elapsedMs': elapsedMilliseconds,
      },
    );

    if (!isCorrect) {
      _handleIncorrectAnswer(card);
      return;
    }

    _handleCorrectAnswer(card);
  }

  void _handleIncorrectAnswer(
      _DraggableNumberCard card,
      ) {
    _incorrectAttempts++;

    _targetGlow.showError();

    card.showWrongAndReturn();

    _feedbackBanner.showMessage(
      'Casi. Observa nuevamente cómo cambia '
          'cada número.',
      const Color(0xFFFF5F6D),
    );
  }

  Future<void> _handleCorrectAnswer(
      _DraggableNumberCard card,
      ) async {
    _isValidating = true;
    _completed = true;
    _selectedAnswer = card.label;

    _targetGlow.setHovering(false);
    _targetGlow.showSuccess();

    _missingValueText?.removeFromParent();
    _missingValueText = null;

    for (final currentCard in _cards) {
      currentCard.disable();
    }

    card.acceptAt(
      _targetPosition,
    );

    final fillSize = Vector2(
      size.x * 0.19,
      size.y * 0.18,
    );

    add(
      _FlaskFillComponent(
        position: _targetPosition.clone(),
        size: fillSize,
        value: card.label,
        liquidColor: card.cardColor,
      ),
    );

    add(
      _CelebrationParticles(
        position: _targetPosition.clone(),
        color: const Color(0xFF29D8E8),
      ),
    );

    _feedbackBanner.showMessage(
      '¡Excelente! Cada número es el doble '
          'del anterior.',
      const Color(0xFF35D69A),
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 250),
    );

    if (card.isMounted) {
      card.removeFromParent();
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 1050),
    );

    if (!isMounted || _locked) {
      return;
    }

    _finish(
      reason: 'correct_answer',
    );
  }

  int _calculateLevel() {
    /*
     * El nivel se usa para elegir una de las
     * opciones originales del backend.
     *
     * 4: resolvió en el primer intento sin pistas.
     * 3: resolvió con máximo una pista o un error.
     * 2: resolvió con varias pistas o errores.
     */
    if (!_completed) {
      return _touchedAny ? 1 : 0;
    }

    if (_attempts == 1 &&
        _hintsUsed == 0) {
      return 4;
    }

    if (_incorrectAttempts <= 1 &&
        _hintsUsed <= 1) {
      return 3;
    }

    return 2;
  }

  void _finish({
    required String reason,
  }) {
    if (_locked) {
      return;
    }

    _locked = true;
    _isValidating = false;

    final finishedAt = DateTime.now();

    final responseTimeMs =
        finishedAt
            .difference(_startedAt)
            .inMilliseconds;

    final firstActionTimeMs =
    _firstActionAt == null
        ? null
        : _firstActionAt!
        .difference(_startedAt)
        .inMilliseconds;

    final firstHintTimeMs =
    _firstHintAt == null
        ? null
        : _firstHintAt!
        .difference(_startedAt)
        .inMilliseconds;

    onFinish(
      _calculateLevel(),
      <String, dynamic>{
        'activityKind': 'numeric_sequence',
        'challengeType': 'numeric_sequence',
        'sequence': [
          '2',
          '4',
          '8',
          null,
          '32',
        ],
        'correctAnswer':
        config.correctAnswer,
        'selectedAnswer':
        _selectedAnswer,
        'completed': _completed,
        'isCorrect': _completed,
        'touchedAny': _touchedAny,
        'attempts': _attempts,
        'incorrectAttempts':
        _incorrectAttempts,
        'hintsUsed': _hintsUsed,
        'hintTimestampsMs':
        List<int>.from(
          _hintTimestampsMs,
        ),
        'firstActionTimeMs':
        firstActionTimeMs,
        'firstHintTimeMs':
        firstHintTimeMs,
        'responseTimeMs':
        responseTimeMs,
        'completionTimeSeconds':
        responseTimeMs / 1000,
        'inputMethod': 'drag_drop',
        'rule': 'double_each_step',
        'endReason': reason,
        'attemptHistory':
        List<Map<String, dynamic>>.from(
          _attemptHistory,
        ),
      },
    );
  }
}

class _DraggableNumberCard
    extends PositionComponent
    with DragCallbacks {
  final String label;

  final void Function(
      _DraggableNumberCard card,
      ) onDropped;

  final VoidCallback onTouched;
  final ValueChanged<bool> onHoverChanged;
  final Vector2 Function()
  targetPositionProvider;

  late final Vector2 originalPosition;

  bool _isDragging = false;
  bool _disabled = false;
  bool _hoveringTarget = false;

  double _shakeTime = 0;
  double _hintTime = 0;
  double _hintStrength = 0.08;

  Color get cardColor {
    switch (label) {
      case '12':
        return const Color(0xFF35B99A);

      case '16':
        return const Color(0xFFF26332);

      case '24':
        return const Color(0xFF0798A6);

      default:
        return const Color(0xFFF26332);
    }
  }

  _DraggableNumberCard({
    required this.label,
    required Vector2 position,
    required this.targetPositionProvider,
    required this.onTouched,
    required this.onHoverChanged,
    required this.onDropped,
  }) : super(
    position: position,
    size: Vector2(88, 92),
    anchor: Anchor.center,
    priority: 5,
  ) {
    originalPosition = position.clone();
  }

  void disable() {
    _disabled = true;
    _isDragging = false;
    _hoveringTarget = false;

    scale = Vector2.all(1);
    priority = 5;

    onHoverChanged(false);
  }

  void acceptAt(Vector2 target) {
    _disabled = true;
    _isDragging = false;
    _hoveringTarget = false;

    position.setFrom(target);
    scale = Vector2.all(0.88);
    priority = 5;

    onHoverChanged(false);
  }

  void showWrongAndReturn() {
    _isDragging = false;
    _hoveringTarget = false;

    position.setFrom(originalPosition);
    scale = Vector2.all(1);

    _shakeTime = 0.48;

    onHoverChanged(false);
  }

  void hintPulse({
    required bool strong,
  }) {
    if (_disabled || _isDragging) {
      return;
    }

    _hintTime = strong ? 1.8 : 1.2;
    _hintStrength = strong ? 0.14 : 0.08;
  }

  void returnToOriginalPosition() {
    _isDragging = false;
    _hoveringTarget = false;

    scale = Vector2.all(1);
    position.setFrom(originalPosition);
    priority = 5;

    onHoverChanged(false);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_shakeTime > 0) {
      _shakeTime -= dt;

      final movement =
          sin(_shakeTime * 55) * 7;

      position.x =
          originalPosition.x + movement;

      if (_shakeTime <= 0) {
        position.setFrom(
          originalPosition,
        );
      }
    }

    if (_hintTime > 0 &&
        !_isDragging &&
        !_disabled) {
      _hintTime -= dt;

      final pulse =
          1 +
              sin(_hintTime * 10).abs() *
                  _hintStrength;

      scale = Vector2.all(pulse);

      if (_hintTime <= 0) {
        scale = Vector2.all(1);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.34)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    final backgroundPaint = Paint()
      ..color = cardColor;

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.09);

    final borderPaint = Paint()
      ..color = const Color(0xFFE9FBFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    final shadowRect =
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        3,
        7,
        size.x - 6,
        size.y - 7,
      ),
      const Radius.circular(19),
    );

    final cardRect =
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        2,
        2,
        size.x - 4,
        size.y - 4,
      ),
      const Radius.circular(19),
    );

    final innerRect =
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        10,
        10,
        size.x - 20,
        size.y - 30,
      ),
      const Radius.circular(13),
    );

    canvas.drawRRect(
      shadowRect,
      shadowPaint,
    );

    canvas.drawRRect(
      cardRect,
      backgroundPaint,
    );

    canvas.drawRRect(
      innerRect,
      innerPaint,
    );

    canvas.drawRRect(
      cardRect,
      borderPaint,
    );

    final numberPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 5,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    numberPainter.paint(
      canvas,
      Offset(
        (size.x -
            numberPainter.width) /
            2,
        27,
      ),
    );

    final dotPaint = Paint()
      ..color = const Color(0xFF07394A);

    final dotY = size.y - 13;

    canvas.drawCircle(
      Offset(
        size.x / 2 - 11,
        dotY,
      ),
      3.2,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(
        size.x / 2,
        dotY,
      ),
      3.2,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(
        size.x / 2 + 11,
        dotY,
      ),
      3.2,
      dotPaint,
    );

    super.render(canvas);
  }

  @override
  void onDragStart(
      DragStartEvent event,
      ) {
    super.onDragStart(event);

    if (_disabled) {
      return;
    }

    _isDragging = true;
    _shakeTime = 0;
    _hintTime = 0;

    onTouched();

    scale = Vector2.all(1.10);
    priority = 20;
  }

  @override
  void onDragUpdate(
      DragUpdateEvent event,
      ) {
    super.onDragUpdate(event);

    if (!_isDragging ||
        _disabled) {
      return;
    }

    position.add(
      event.localDelta,
    );

    final distance =
    position.distanceTo(
      targetPositionProvider(),
    );

    final hovering =
        distance <= 88;

    if (hovering !=
        _hoveringTarget) {
      _hoveringTarget = hovering;

      onHoverChanged(
        hovering,
      );
    }
  }

  @override
  void onDragEnd(
      DragEndEvent event,
      ) {
    super.onDragEnd(event);

    if (!_isDragging ||
        _disabled) {
      return;
    }

    _isDragging = false;

    final targetPosition =
    targetPositionProvider();

    final distance =
    position.distanceTo(
      targetPosition,
    );

    scale = Vector2.all(1);
    priority = 5;

    onHoverChanged(false);
    _hoveringTarget = false;

    if (distance <= 88) {
      position.setFrom(
        targetPosition,
      );

      onDropped(this);
      return;
    }

    returnToOriginalPosition();
  }

  @override
  void onDragCancel(
      DragCancelEvent event,
      ) {
    super.onDragCancel(event);

    if (_disabled) {
      return;
    }

    returnToOriginalPosition();
  }
}

class _FlaskTargetGlow
    extends PositionComponent {
  bool _hovering = false;

  double _hintTime = 0;
  double _errorTime = 0;
  double _successTime = 0;
  double _time = 0;

  _FlaskTargetGlow({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 2,
  );

  void setHovering(bool value) {
    _hovering = value;
  }

  void showHint() {
    _hintTime = 1.2;
  }

  void showError() {
    _errorTime = 0.55;
  }

  void showSuccess() {
    _successTime = 1.2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _time += dt;

    if (_hintTime > 0) {
      _hintTime -= dt;
    }

    if (_errorTime > 0) {
      _errorTime -= dt;
    }

    if (_successTime > 0) {
      _successTime -= dt;
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(
      size.x / 2,
      size.y / 2,
    );

    final pulse =
        0.5 +
            0.5 *
                sin(_time * 5).abs();

    Color color =
    const Color(0xFF22DCEB);

    double opacity = 0.16;

    if (_hovering) {
      opacity = 0.52;
    }

    if (_hintTime > 0) {
      opacity =
          0.30 + pulse * 0.28;
    }

    if (_errorTime > 0) {
      color =
      const Color(0xFFFF4D67);
      opacity = 0.52;
    }

    if (_successTime > 0) {
      color =
      const Color(0xFF35D69A);
      opacity = 0.62;
    }

    final glowPaint = Paint()
      ..color = color.withOpacity(opacity)
      ..maskFilter =
      const MaskFilter.blur(
        BlurStyle.normal,
        15,
      );

    final borderPaint = Paint()
      ..color = color.withOpacity(
        opacity + 0.18 > 1
            ? 1
            : opacity + 0.18,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth =
      _hovering ? 4 : 2.2;

    final radius =
        min(size.x, size.y) / 2;

    canvas.drawCircle(
      center,
      radius,
      glowPaint,
    );

    canvas.drawCircle(
      center,
      radius - 5,
      borderPaint,
    );

    super.render(canvas);
  }
}

class _FlaskFillComponent
    extends PositionComponent {
  final String value;
  final Color liquidColor;

  double _progress = 0;

  _FlaskFillComponent({
    required Vector2 position,
    required Vector2 size,
    required this.value,
    required this.liquidColor,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 8,
  );

  @override
  void update(double dt) {
    super.update(dt);

    if (_progress < 1) {
      _progress += dt / 0.65;

      if (_progress > 1) {
        _progress = 1;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final liquidPaint = Paint()
      ..color = liquidColor;

    final highlightPaint = Paint()
      ..color =
      Colors.white.withOpacity(0.24);

    final liquidPath = Path()
      ..moveTo(
        size.x * 0.23,
        size.y * 0.39,
      )
      ..quadraticBezierTo(
        size.x * 0.16,
        size.y * 0.47,
        size.x * 0.10,
        size.y * 0.67,
      )
      ..quadraticBezierTo(
        size.x * 0.03,
        size.y * 0.86,
        size.x * 0.23,
        size.y * 0.94,
      )
      ..quadraticBezierTo(
        size.x * 0.50,
        size.y * 1.02,
        size.x * 0.79,
        size.y * 0.94,
      )
      ..quadraticBezierTo(
        size.x * 0.98,
        size.y * 0.86,
        size.x * 0.91,
        size.y * 0.67,
      )
      ..quadraticBezierTo(
        size.x * 0.84,
        size.y * 0.47,
        size.x * 0.77,
        size.y * 0.39,
      )
      ..close();

    final liquidBottom =
        size.y * 0.97;

    final liquidTop =
        size.y * 0.39;

    final visibleTop =
        liquidBottom -
            (liquidBottom - liquidTop) *
                _progress;

    canvas.save();

    canvas.clipRect(
      Rect.fromLTRB(
        0,
        visibleTop,
        size.x,
        size.y,
      ),
    );

    canvas.drawPath(
      liquidPath,
      liquidPaint,
    );

    canvas.drawCircle(
      Offset(
        size.x * 0.32,
        size.y * 0.66,
      ),
      size.x * 0.045,
      highlightPaint,
    );

    canvas.drawCircle(
      Offset(
        size.x * 0.70,
        size.y * 0.77,
      ),
      size.x * 0.035,
      highlightPaint,
    );

    canvas.restore();

    if (_progress > 0.45) {
      final textPainter =
      TextPainter(
        text: TextSpan(
          text: value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight:
            FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        textDirection:
        TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          (size.x -
              textPainter.width) /
              2,
          size.y * 0.61,
        ),
      );
    }

    super.render(canvas);
  }
}

class _FeedbackBanner
    extends PositionComponent {
  String _message = '';
  Color _color =
  const Color(0xFF29B6F6);

  double _visibleTime = 0;

  _FeedbackBanner({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.topCenter,
    priority: 12,
  );

  void showMessage(
      String message,
      Color color,
      ) {
    _message = message;
    _color = color;
    _visibleTime = 5;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_visibleTime > 0) {
      _visibleTime -= dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_message.isEmpty ||
        _visibleTime <= 0) {
      return;
    }

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
      const Radius.circular(14),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color =
        const Color(0xFF07192B)
            .withOpacity(0.91),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color =
        _color.withOpacity(0.78)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.7,
    );

    final painter = TextPainter(
      text: TextSpan(
        text: _message,
        style: TextStyle(
          color: _color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(
      maxWidth: size.x - 22,
    );

    painter.paint(
      canvas,
      Offset(
        (size.x - painter.width) / 2,
        (size.y - painter.height) / 2,
      ),
    );

    super.render(canvas);
  }
}

class _HintButton extends PositionComponent
    with TapCallbacks {
  String label;
  final VoidCallback onPressed;

  bool _disabled = false;

  _HintButton({
    required this.label,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 15,
  );

  void setLabel(String value) {
    label = value;
  }

  void disable() {
    _disabled = true;
  }

  @override
  void render(Canvas canvas) {
    final color = _disabled
        ? const Color(0xFF78909C)
        : const Color(0xFFFFC857);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
      Radius.circular(
        size.y / 2,
      ),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color =
        const Color(0xFF0E2235)
            .withOpacity(0.94),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color =
        color.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        (size.x - painter.width) / 2,
        (size.y - painter.height) / 2,
      ),
    );

    super.render(canvas);
  }

  @override
  void onTapDown(
      TapDownEvent event,
      ) {
    super.onTapDown(event);

    if (_disabled) {
      return;
    }

    onPressed();
  }
}

class _CelebrationParticles
    extends PositionComponent {
  final Color color;

  final Random _random = Random();
  final List<_ParticleData> _particles = [];

  double _life = 1;

  _CelebrationParticles({
    required Vector2 position,
    required this.color,
  }) : super(
    position: position,
    size: Vector2.all(1),
    anchor: Anchor.center,
    priority: 20,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (var index = 0;
    index < 24;
    index++) {
      final angle =
          _random.nextDouble() *
              pi *
              2;

      final speed =
          35 +
              _random.nextDouble() * 85;

      _particles.add(
        _ParticleData(
          position: Offset.zero,
          velocity: Offset(
            cos(angle) * speed,
            sin(angle) * speed,
          ),
          radius:
          1.5 +
              _random.nextDouble() * 3,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _life -= dt;

    for (final particle in _particles) {
      particle.position +=
          particle.velocity * dt;

      particle.velocity = Offset(
        particle.velocity.dx * 0.97,
        particle.velocity.dy + 35 * dt,
      );
    }

    if (_life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity =
    _life.clamp(0.0, 1.0);

    final paint = Paint()
      ..color = color.withOpacity(
        opacity,
      );

    for (final particle in _particles) {
      canvas.drawCircle(
        particle.position,
        particle.radius,
        paint,
      );
    }

    super.render(canvas);
  }
}

class _ParticleData {
  Offset position;
  Offset velocity;
  final double radius;

  _ParticleData({
    required this.position,
    required this.velocity,
    required this.radius,
  });
}