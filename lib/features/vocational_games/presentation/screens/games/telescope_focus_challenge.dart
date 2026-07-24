import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TelescopeFocusConfig {
  final String backgroundAsset;
  final double initialFocus;
  final double correctStart;
  final double correctEnd;

  const TelescopeFocusConfig({
    required this.backgroundAsset,
    required this.initialFocus,
    required this.correctStart,
    required this.correctEnd,
  });

  static const TelescopeFocusConfig defaultConfig = TelescopeFocusConfig(
    backgroundAsset: 'telescopioregalo.png',
    initialFocus: 0.06,
    correctStart: 0.285,
    correctEnd: 0.380,
  );
}

class TelescopeFocusChallengeComponent extends PositionComponent {
  final TelescopeFocusConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final _FocusedStar _star;
  late final _InvisibleFocusDial _dial;
  late final _FocusProgress _progress;

  PositionComponent? _message;

  double _focus = 0;
  double _maximumFocus = 0;
  int _adjustments = 0;
  int _hintIndex = 0;
  bool _touchedAny = false;
  bool _locked = false;

  final DateTime _startedAt = DateTime.now();

  TelescopeFocusChallengeComponent({
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

    _focus = config.initialFocus;
    _maximumFocus = _focus;

    await _addBackground();
    _addInstruction();
    _addStar();
    _addProgress();
    _addDialHitbox();
    _addButtons();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(
        SpriteComponent(
          sprite: sprite,
          position: Vector2.zero(),
          size: size.clone(),
          priority: -100,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
      add(
        RectangleComponent(
          size: size.clone(),
          priority: -100,
          paint: Paint()..color = const Color(0xFF020B24),
        ),
      );
    }
  }

  void _addInstruction() {
    add(
      TextBoxComponent(
        text:
        'Arrastra el botón celeste alrededor de la perilla hasta colocarlo dentro de la zona verde.',
        position: Vector2(size.x / 2, size.y * 0.025),
        size: Vector2(size.x - 54, 60),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 200,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFE4F9FF),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.22,
          ),
        ),
      ),
    );
  }

  void _addStar() {
    // Coincide con el centro del visor superior de la plantilla.
    _star = _FocusedStar(
      position: Vector2(size.x * 0.716, size.y * 0.232),
      size: Vector2.all(size.x * 0.115),
      focus: _focus,
    );
    add(_star);
  }

  void _addProgress() {
    // Se coloca exactamente sobre los tres indicadores de la plantilla.
    _progress = _FocusProgress(
      position: Vector2(size.x * 0.500, size.y * 0.582),
      size: Vector2(size.x * 0.178, 24),
      focus: _focus,
    );
    add(_progress);
  }

  void _addDialHitbox() {
    // La plantilla nueva ya dibuja la perilla. Este componente NO pinta
    // círculos: solo detecta el gesto sobre la perilla pequeña.
    _dial = _InvisibleFocusDial(
      position: Vector2(size.x * 0.500, size.y * 0.790),
      size: Vector2.all(size.x * 0.400),
      initialFocus: _focus,
      correctStart: config.correctStart,
      correctEnd: config.correctEnd,
      onFocusChanged: _onFocusChanged,
      onAdjustmentFinished: _onAdjustmentFinished,
    );
    add(_dial);
  }

  void _addButtons() {
    add(
      _FocusButton(
        text: '💡 Pista',
        color: const Color(0xFF49E9F6),
        position: Vector2(size.x / 2 - 62, size.y - 35),
        onPressed: _showHint,
      ),
    );

    add(
      _FocusButton(
        text: 'Saltar',
        color: const Color(0xFF90A4AE),
        position: Vector2(size.x / 2 + 62, size.y - 35),
        onPressed: () => _finish(reason: 'skipped'),
      ),
    );
  }

  void _onFocusChanged(double value) {
    if (_locked) return;

    _touchedAny = true;
    _focus = value.clamp(0.0, 1.0);
    _maximumFocus = max(_maximumFocus, _focus);

    _star.focus = (_focus / config.correctEnd).clamp(0.0, 1.0);
    _progress.focus = _focus;
  }

  void _onAdjustmentFinished() {
    if (_locked) return;
    _adjustments++;

    if (_focus >= config.correctStart && _focus <= config.correctEnd) {
      _showCompletion();
    }
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    _dial.lock();
    _message?.removeFromParent();
    _message = null;

    add(
      _AstronomyCompletionOverlay(
        size: size.clone(),
        characterAsset: 'joven_telescopio.png',
        onContinue: () => _deliverFinish(reason: 'completed'),
      ),
    );
  }

  void _showHint() {
    if (_locked) return;

    const hints = <String>[
      'Mueve la perilla poco a poco y observa cómo cambia el brillo.',
      'Sigue el borde circular con el botón celeste.',
      'Detén el botón dentro de las marcas verdes cuando la estrella esté nítida.',
    ];

    final text = hints[_hintIndex.clamp(0, hints.length - 1)];
    if (_hintIndex < hints.length - 1) {
      _hintIndex++;
    }

    _showMessage(text, const Color(0xFF49E9F6), seconds: 3.5);
  }

  void _showMessage(
      String text,
      Color color, {
        required double seconds,
        VoidCallback? onRemoved,
      }) {
    _message?.removeFromParent();

    final banner = _FocusMessage(
      text: text,
      color: color,
      position: Vector2(size.x / 2, size.y * 0.525),
      size: Vector2(size.x - 64, 58),
      seconds: seconds,
      onRemoved: onRemoved,
    );

    _message = banner;
    add(banner);
  }

  int _currentLevel() {
    if (_focus >= config.correctStart && _focus <= config.correctEnd) return 4;
    if (_maximumFocus >= config.correctStart * 0.85) return 3;
    if (_maximumFocus >= config.correctStart * 0.45) return 2;
    if (_touchedAny) return 1;
    return 0;
  }

  void _finish({required String reason}) {
    if (_locked) return;

    _locked = true;
    _dial.lock();
    _deliverFinish(reason: reason);
  }

  void _deliverFinish({required String reason}) {
    _locked = true;
    _dial.lock();

    final elapsed = DateTime.now().difference(_startedAt).inSeconds;

    onFinish(
      reason == 'completed' ? 4 : _currentLevel(),
      <String, dynamic>{
        'activityKind': 'astronomy',
        'challengeType': 'telescopeFocus',
        'finalFocus': _focus,
        'maximumFocus': _maximumFocus,
        'adjustments': _adjustments,
        'touchedAny': _touchedAny,
        'completionTimeSeconds': elapsed,
        'endReason': reason,
      },
    );
  }
}

class _InvisibleFocusDial extends PositionComponent with DragCallbacks {
  final double correctStart;
  final double correctEnd;
  final ValueChanged<double> onFocusChanged;
  final VoidCallback onAdjustmentFinished;

  double focus;
  double? _previousAngle;
  Vector2? _pointerPosition;
  bool _dragging = false;
  bool _locked = false;

  _InvisibleFocusDial({
    required Vector2 position,
    required Vector2 size,
    required double initialFocus,
    required this.correctStart,
    required this.correctEnd,
    required this.onFocusChanged,
    required this.onAdjustmentFinished,
  })  : focus = initialFocus,
        super(
        position: position,
        size: size,
        anchor: Anchor.center,
        priority: 150,
      );

  void lock() {
    _locked = true;
    _dragging = false;
    _previousAngle = null;
    _pointerPosition = null;
  }

  double _angleFor(Vector2 point) {
    final center = size / 2;
    return atan2(point.y - center.y, point.x - center.x);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_locked) return;

    _dragging = true;
    _pointerPosition = event.localPosition.clone();
    _previousAngle = _angleFor(_pointerPosition!);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_dragging || _locked) return;

    _pointerPosition ??= size / 2;
    _pointerPosition!.add(event.localDelta);
    final currentAngle = _angleFor(_pointerPosition!);
    final previousAngle = _previousAngle ?? currentAngle;

    var delta = currentAngle - previousAngle;
    if (delta > pi) delta -= 2 * pi;
    if (delta < -pi) delta += 2 * pi;

    // Una vuelta completa cambia todo el rango de enfoque.
    focus = (focus + delta / (2 * pi)).clamp(0.0, 1.0);
    _previousAngle = currentAngle;
    onFocusChanged(focus);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_dragging || _locked) return;

    _dragging = false;
    _previousAngle = null;
    _pointerPosition = null;
    onAdjustmentFinished();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_locked) return;

    _dragging = false;
    _previousAngle = null;
    _pointerPosition = null;
    onAdjustmentFinished();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.455;
    const startAngle = -pi;
    const totalSweep = pi * 1.5;

    // Zona correcta: coincide con las marcas verdes de la plantilla.
    final targetStart = startAngle + totalSweep * correctStart;
    final targetSweep = totalSweep * (correctEnd - correctStart);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      targetStart,
      targetSweep,
      false,
      Paint()
        ..color = const Color(0xFF65F5B5)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8,
    );

    // Botón que el alumno mueve siguiendo la circunferencia.
    final handleAngle = startAngle + totalSweep * focus;
    final handle = Offset(
      center.dx + cos(handleAngle) * radius,
      center.dy + sin(handleAngle) * radius,
    );

    canvas.drawCircle(
      handle,
      17,
      Paint()..color = const Color(0xFF07162F).withOpacity(0.82),
    );
    canvas.drawCircle(
      handle,
      14,
      Paint()..color = const Color(0xFF49E9F6),
    );
    canvas.drawCircle(
      handle,
      14,
      Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.drawCircle(
      Offset(handle.dx - 4, handle.dy - 5),
      3.2,
      Paint()..color = Colors.white.withOpacity(0.72),
    );
  }
}

class _FocusedStar extends PositionComponent {
  double focus;

  _FocusedStar({
    required Vector2 position,
    required Vector2 size,
    required this.focus,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 100,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);
    final blur = 1.5 + (1 - focus) * 13;
    final glowRadius = size.x * (0.16 + (1 - focus) * 0.24);

    canvas.drawCircle(
      center,
      glowRadius,
      Paint()
        ..color = const Color(0xFFFFD66A).withOpacity(0.38)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );

    canvas.drawCircle(
      center,
      3.5 + focus * 3.2,
      Paint()..color = Colors.white,
    );

    if (focus > 0.60) {
      final sharpness = ((focus - 0.60) / 0.40).clamp(0.0, 1.0);
      final length = size.x * (0.12 + sharpness * 0.13);
      final paint = Paint()
        ..color = const Color(0xFFFFE8A6).withOpacity(sharpness)
        ..strokeWidth = 1.6;

      canvas.drawLine(
        Offset(center.dx - length, center.dy),
        Offset(center.dx + length, center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - length),
        Offset(center.dx, center.dy + length),
        paint,
      );
    }
  }
}

class _FocusProgress extends PositionComponent {
  double focus;

  _FocusProgress({
    required Vector2 position,
    required Vector2 size,
    required this.focus,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 110,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final activeCount = focus < 0.34
        ? 1
        : focus < 0.67
        ? 2
        : 3;
    final spacing = size.x / 4;

    for (var index = 0; index < 3; index++) {
      if (index >= activeCount) continue;

      final center = Offset(spacing * (index + 1), size.y / 2);
      canvas.drawCircle(
        center,
        5.5,
        Paint()..color = const Color(0xFF49E9F6),
      );
      canvas.drawCircle(
        center,
        8.5,
        Paint()
          ..color = const Color(0xFF49E9F6).withOpacity(0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }
}

class _FocusMessage extends PositionComponent {
  final String text;
  final Color color;
  final double seconds;
  final VoidCallback? onRemoved;

  _FocusMessage({
    required this.text,
    required this.color,
    required this.seconds,
    required Vector2 position,
    required Vector2 size,
    this.onRemoved,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 400,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextBoxComponent(
        text: text,
        position: size / 2,
        size: Vector2(size.x - 24, size.y - 10),
        anchor: Anchor.center,
        align: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            height: 1.18,
          ),
        ),
      ),
    );

    add(
      TimerComponent(
        period: seconds,
        removeOnFinish: true,
        onTick: () {
          removeFromParent();
          onRemoved?.call();
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));

    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF10233A).withOpacity(0.96),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }
}

class _AstronomyCompletionOverlay extends PositionComponent {
  final String characterAsset;
  final VoidCallback onContinue;

  _AstronomyCompletionOverlay({
    required Vector2 size,
    required this.characterAsset,
    required this.onContinue,
  }) : super(
    size: size,
    position: Vector2.zero(),
    priority: 1000,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final panelSize = Vector2(size.x * 0.84, size.y * 0.57);
    final panel = _CompletionPanel(
      position: size / 2,
      size: panelSize,
    );
    add(panel);

    try {
      final sprite = await Sprite.load(characterAsset);
      panel.add(
        SpriteComponent(
          sprite: sprite,
          position: Vector2(panelSize.x * 0.27, panelSize.y * 0.57),
          size: Vector2(panelSize.x * 0.42, panelSize.y * 0.70),
          anchor: Anchor.center,
          priority: 2,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar $characterAsset: $error');
    }

    panel.add(
      TextComponent(
        text: '¡Wow, genial!',
        position: Vector2(panelSize.x * 0.68, panelSize.y * 0.18),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF65F5B5),
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

    panel.add(
      TextBoxComponent(
        text:
        '¡Felicidades!\n\nLograste enfocar la estrella y aprendiste a ajustar un telescopio observando su nitidez.',
        position: Vector2(panelSize.x * 0.68, panelSize.y * 0.29),
        size: Vector2(panelSize.x * 0.50, panelSize.y * 0.35),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFF2FAFF),
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            height: 1.28,
          ),
        ),
      ),
    );

    panel.add(
      _CompletionButton(
        text: 'Continuar',
        position: Vector2(panelSize.x * 0.68, panelSize.y * 0.78),
        size: Vector2(panelSize.x * 0.44, 48),
        onPressed: onContinue,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF01091D).withOpacity(0.80),
    );
  }
}

class _CompletionPanel extends PositionComponent {
  _CompletionPanel({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 1,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(28));
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF102C43).withOpacity(0.98),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF65F5B5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
}

class _CompletionButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  _CompletionButton({
    required this.text,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 20,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextComponent(
        text: text,
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF061727),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF65F5B5),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _FocusButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  _FocusButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
  }) : super(
    position: position,
    size: Vector2(108, 36),
    anchor: Anchor.center,
    priority: 300,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextComponent(
        text: text,
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));

    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF0C1B31).withOpacity(0.92),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}