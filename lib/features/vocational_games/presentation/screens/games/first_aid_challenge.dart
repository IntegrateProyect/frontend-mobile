import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class FirstAidConfig {
  final String backgroundAsset;
  final List<String> bandageAssets;
  const FirstAidConfig({
    required this.backgroundAsset,
    required this.bandageAssets,
  });

  static const defaultConfig = FirstAidConfig(
    backgroundAsset: 'primerosauxilios.png',
    bandageAssets: <String>[
      'vendajeflojo.png',
      'vendajecorrecto.png',
      'vendajeapretado.png',
    ],
  );
}

class FirstAidChallengeComponent extends PositionComponent {
  final FirstAidConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  static const _instructions = <String>[
    'Arrastra el vendaje con la tensión correcta hasta la herida.',
    'Finalmente toca la muñeca para comprobar la circulación.',
  ];

  static const _hints = <String>[
    'Un vendaje seguro debe quedar firme, pero sin cambiar el color o la temperatura de los dedos.',
    'Busca dónde se puede sentir el pulso y revisa si la mano conserva color, calor y sensibilidad.',
  ];

  late final TextBoxComponent _instruction;
  final List<_DraggableBandage> _bandages = <_DraggableBandage>[];
  final List<_AidTapZone> _zones = <_AidTapZone>[];
  PositionComponent? _message;

  int _step = 0;
  int _attempts = 0;
  bool _locked = false;
  bool _scanning = false;
  bool _completionShown = false;
  final DateTime _startedAt = DateTime.now();

  FirstAidChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();

    _instruction = TextBoxComponent(
      text: _instructions.first,
      position: Vector2(size.x / 2, size.y * 0.025),
      size: Vector2(size.x - 52, 58),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 220,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFE8E8),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
    add(_instruction);

    await _addDraggableBandages();

    // Verificación de circulación en la muñeca.
    _addZone(2, Vector2(0.780, 0.515), Vector2(0.15, 0.12), _verifyCirculation);

    _addButtons();
    _updateZones();
  }

  Future<void> _addDraggableBandages() async {
    // Centros medidos sobre los tres círculos de primerosauxilios.png.
    const positions = <double>[0.272, 0.500, 0.728];
    for (var index = 0; index < config.bandageAssets.length; index++) {
      final card = _DraggableBandage(
        assetName: config.bandageAssets[index],
        bandageIndex: index,
        position: Vector2(size.x * positions[index], size.y * 0.372),
        size: Vector2.all(size.x * 0.165),
        target: Vector2(size.x * 0.505, size.y * 0.515),
        acceptanceDistance: size.x * 0.19,
        onAttempt: () => _attempts++,
        onIncorrect: (wrongIndex) {
          _wrong(
            wrongIndex == 0
                ? 'Ese vendaje está muy flojo: no sostendría correctamente el apósito.'
                : 'Ese vendaje está muy apretado: podría reducir la circulación.',
          );
        },
        onCorrect: _bandagePlaced,
      );
      _bandages.add(card);
      add(card);
    }
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(
        sprite: sprite,
        position: Vector2.zero(),
        size: size.clone(),
        priority: -100,
      ));
    } catch (error) {
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
      add(RectangleComponent(
        size: size.clone(),
        priority: -100,
        paint: Paint()..color = const Color(0xFF030E27),
      ));
    }
  }

  void _addZone(
      int requiredStep,
      Vector2 fraction,
      Vector2 sizeFraction,
      VoidCallback action,
      ) {
    final zone = _AidTapZone(
      requiredStep: requiredStep,
      position: Vector2(size.x * fraction.x, size.y * fraction.y),
      size: Vector2(size.x * sizeFraction.x, size.y * sizeFraction.y),
      onPressed: () {
        if (_locked || _step != requiredStep) return;
        _attempts++;
        action();
      },
    );
    _zones.add(zone);
    add(zone);
  }

  void _bandagePlaced(_DraggableBandage selected) {
    if (_locked) return;
    _message?.removeFromParent();
    _message = null;
    _step = 2;
    for (final bandage in _bandages) {
      bandage.removeFromParent();
    }
    // La tarjeta circular desaparece y se coloca únicamente el vendaje sobre
    // el brazo, siguiendo su forma horizontal.
    add(_AppliedBandage(
      position: Vector2(size.x * 0.505, size.y * 0.515),
      size: Vector2(size.x * 0.190, size.y * 0.064),
    ));
    _instruction.text = _instructions[1];
    _updateZones();
    _showMessage(
      '💡 ¿Sabías que? Después de vendar se revisan el color, la temperatura y la sensibilidad de los dedos para confirmar que la sangre circula bien.',
      true,
    );
  }

  void _verifyCirculation() {
    if (_locked || _scanning || _step != 2) return;
    _scanning = true;
    _step = 3;
    _updateZones();
    _showMessage('Analizando circulación… observa cómo la luz recorre el brazo.', true);

    add(_CirculationScan(
      position: Vector2(size.x * 0.595, size.y * 0.515),
      size: Vector2(size.x * 0.515, size.y * 0.105),
      duration: 1.8,
    ));

    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      if (_locked) return;
      _showMessage(
        '¡Circulación correcta! La luz llegó hasta la muñeca sin interrupciones.',
        true,
      );
    });
    Future<void>.delayed(const Duration(milliseconds: 2800), () {
      if (!_locked) _showCompletionModal();
    });
  }

  void _showCompletionModal() {
    if (_locked || _completionShown) return;

    _completionShown = true;
    _message?.removeFromParent();
    _message = null;
    _instruction.text = '';

    for (final zone in _zones) {
      zone.active = false;
    }

    for (final bandage in _bandages) {
      bandage.lock();
    }

    add(
      _FirstAidCompletionModal(
        imageAsset: 'first_aid_girl.png',
        position: Vector2.zero(),
        size: size.clone(),
        onContinue: () => _finish('completed'),
      ),
    );
  }

  void _wrong(String text) {
    if (_locked) return;
    _showMessage(text, false);
  }

  void _updateZones() {
    for (final zone in _zones) {
      zone.active = zone.requiredStep == _step;
    }
  }

  void _showMessage(String text, bool success) {
    _message?.removeFromParent();
    final isFact = text.contains('¿Sabías que?');
    final banner = _AidMessage(
      text: text,
      color: success ? const Color(0xFF43F0C2) : const Color(0xFFFF667A),
      position: Vector2(size.x / 2, size.y * (isFact ? 0.805 : 0.825)),
      size: Vector2(size.x - 70, isFact ? 88 : 58),
    );
    _message = banner;
    add(banner);
  }

  void _showHint() {
    if (_locked) return;
    final hintIndex = _step == 0 ? 0 : 1;
    _showMessage(_hints[hintIndex], false);
    // La pista ofrece un criterio para razonar, pero no ilumina la respuesta.
  }

  void _addButtons() {
    add(_AidButton(
      text: '💡 Pista',
      color: const Color(0xFFFF526D),
      position: Vector2(size.x / 2 - 62, size.y - 40),
      width: 108,
      onPressed: _showHint,
    ));
    add(_AidButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 40),
      width: 108,
      onPressed: () => _finish('skipped'),
    ));
  }

  int _level() {
    if (_step >= 3) return 4;
    if (_step == 2) return 3;
    if (_step == 1) return 2;
    if (_attempts > 0) return 1;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    for (final zone in _zones) {
      zone.active = false;
    }
    for (final bandage in _bandages) {
      bandage.lock();
    }
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(_level(), <String, dynamic>{
      'activityKind': 'medical',
      'challengeType': 'firstAidBandage',
      'stepsCompleted': _step,
      'stepsTotal': 3,
      'attempts': _attempts,
      'completionTimeSeconds': elapsed,
      'endReason': reason,
    });
  }
}

class _FirstAidCompletionModal extends PositionComponent
    with TapCallbacks {
  final String imageAsset;
  final VoidCallback onContinue;

  _FirstAidCompletionModal({
    required this.imageAsset,
    required Vector2 position,
    required Vector2 size,
    required this.onContinue,
  }) : super(
    position: position,
    size: size,
    priority: 2000,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final modalWidth = math.min(size.x - 38, 430.0);
    final modalHeight = math.min(size.y - 90, 470.0);
    final modalSize = Vector2(modalWidth, modalHeight);
    final modalTopLeft = Vector2(
      (size.x - modalWidth) / 2,
      (size.y - modalHeight) / 2,
    );

    add(
      _FirstAidModalBackground(
        position: modalTopLeft,
        size: modalSize,
      ),
    );

    add(
      TextBoxComponent(
        text: '¡Felicidades!',
        position: Vector2(
          modalTopLeft.x + modalWidth / 2,
          modalTopLeft.y + 28,
        ),
        size: Vector2(modalWidth - 36, 52),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 3,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFC857),
            fontSize: 29,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

    final characterCenter = Vector2(
      modalTopLeft.x + modalWidth * 0.27,
      modalTopLeft.y + modalHeight * 0.53,
    );

    try {
      final character = await Sprite.load(imageAsset);
      add(
        SpriteComponent(
          sprite: character,
          position: characterCenter,
          size: Vector2(
            modalWidth * 0.40,
            modalHeight * 0.62,
          ),
          anchor: Anchor.center,
          priority: 3,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar $imageAsset: $error');
      add(
        TextComponent(
          text: '👩‍⚕️🧰',
          position: characterCenter,
          anchor: Anchor.center,
          priority: 3,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 60),
          ),
        ),
      );
    }

    add(
      TextBoxComponent(
        text:
        '¡Excelente trabajo!\n\nCuraste correctamente el brazo y completaste la actividad de primeros auxilios.\n\nTu ayuda hizo sentir mucho mejor al paciente.',
        position: Vector2(
          modalTopLeft.x + modalWidth * 0.48,
          modalTopLeft.y + modalHeight * 0.27,
        ),
        size: Vector2(
          modalWidth * 0.46,
          modalHeight * 0.48,
        ),
        priority: 3,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFF4F8FC),
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ),
    );

    add(
      _FirstAidContinueButton(
        position: Vector2(
          modalTopLeft.x + modalWidth / 2,
          modalTopLeft.y + modalHeight - 48,
        ),
        width: modalWidth - 52,
        onPressed: onContinue,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF00152E).withOpacity(0.88),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Consume el toque para impedir que llegue al juego que está debajo.
    super.onTapDown(event);
  }
}

class _FirstAidModalBackground extends PositionComponent {
  _FirstAidModalBackground({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    priority: 1,
  );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final shape = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(30),
    );

    canvas.drawRRect(
      shape,
      Paint()..color = const Color(0xFF123450),
    );

    canvas.drawRRect(
      shape,
      Paint()
        ..color = const Color(0xFFFFC857)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}

class _FirstAidContinueButton extends PositionComponent
    with TapCallbacks {
  final VoidCallback onPressed;

  _FirstAidContinueButton({
    required Vector2 position,
    required double width,
    required this.onPressed,
  }) : super(
    position: position,
    size: Vector2(width, 58),
    anchor: Anchor.center,
    priority: 10,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextComponent(
        text: 'Continuar',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF08233B),
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final shape = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.y / 2),
    );

    canvas.drawRRect(
      shape,
      Paint()..color = const Color(0xFFFFC857),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _CirculationScan extends PositionComponent {
  final double duration;
  double _elapsed = 0;

  _CirculationScan({
    required Vector2 position,
    required Vector2 size,
    required this.duration,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 205,
  );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed = (_elapsed + dt).clamp(0.0, duration);
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final armShape = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Radius.circular(size.y / 2),
    );
    canvas.save();
    canvas.clipRRect(armShape);

    // No se dibujan líneas nuevas. El punto luminoso recorre las vueltas
    // punteadas que ya forman parte de primerosauxilios.png.
    const loopCount = 6;
    final travel = progress * loopCount;
    final loopIndex = travel.floor().clamp(0, loopCount - 1);
    final loopProgress = travel >= loopCount
        ? 1.0
        : travel - loopIndex;
    final angle = -math.pi / 2 + loopProgress * math.pi * 2;

    // Centros y radios ajustados a las líneas impresas del antebrazo.
    final centerX = size.x * (0.10 + loopIndex * 0.145);
    final radiusX = size.x * 0.040;
    final radiusY = size.y * 0.34;
    final pulse = Offset(
      centerX + math.cos(angle) * radiusX,
      size.y / 2 + math.sin(angle) * radiusY,
    );
    canvas.drawCircle(
      pulse,
      15,
      Paint()
        ..color = const Color(0xFF55FFE0).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(pulse, 6, Paint()..color = const Color(0xFFE8FFFA));
    canvas.drawCircle(
      pulse,
      10,
      Paint()
        ..color = const Color(0xFF55FFE0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.restore();
  }
}

class _AppliedBandage extends PositionComponent {
  _AppliedBandage({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 195,
  );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final shape = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.y * 0.20),
    );

    canvas.drawRRect(
      shape,
      Paint()..color = const Color(0xFFE8D2A9),
    );

    // Sombra inferior para integrarlo con el volumen del brazo.
    canvas.drawRRect(
      shape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF7E7C7),
            Color(0xFFD0B486),
          ],
        ).createShader(rect),
    );

    final seamPaint = Paint()
      ..color = const Color(0xFFB89A6E).withOpacity(0.72)
      ..strokeWidth = 1.2;
    final highlightPaint = Paint()
      ..color = const Color(0xFFFFF3DA).withOpacity(0.72)
      ..strokeWidth = 1;

    // Vueltas verticales del vendaje alrededor del antebrazo.
    const strips = 6;
    final stripWidth = size.x / strips;
    for (var i = 1; i < strips; i++) {
      final x = stripWidth * i;
      canvas.drawLine(Offset(x, 3), Offset(x, size.y - 3), seamPaint);
      canvas.drawLine(
        Offset(x + 2, 4),
        Offset(x + 2, size.y - 4),
        highlightPaint,
      );
    }

    canvas.drawRRect(
      shape,
      Paint()
        ..color = const Color(0xFFFFEBC5).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}

class _DraggableBandage extends SpriteComponent
    with DragCallbacks, TapCallbacks {
  final String assetName;
  final int bandageIndex;
  final Vector2 target;
  final double acceptanceDistance;
  final VoidCallback onAttempt;
  final ValueChanged<int> onIncorrect;
  final ValueChanged<_DraggableBandage> onCorrect;

  late final Vector2 _startPosition;
  bool _dragging = false;
  bool _placed = false;
  bool _locked = false;

  _DraggableBandage({
    required this.assetName,
    required this.bandageIndex,
    required Vector2 position,
    required Vector2 size,
    required this.target,
    required this.acceptanceDistance,
    required this.onAttempt,
    required this.onIncorrect,
    required this.onCorrect,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 170,
  ) {
    _startPosition = position.clone();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(assetName);
  }

  void lock() {
    _locked = true;
    _dragging = false;
  }

  void pulse() {
    if (_locked || _placed) return;
    add(ScaleEffect.to(
      Vector2.all(1.08),
      EffectController(
        duration: 0.18,
        reverseDuration: 0.18,
        alternate: true,
        repeatCount: 2,
      ),
      onComplete: () {
        if (!_placed) scale = Vector2.all(1);
      },
    ));
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_locked || _placed) return;
    _dragging = true;
    priority = 260;
    scale = Vector2.all(1.05);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (_locked || _placed) return;
    onAttempt();
    if (bandageIndex == 0 || bandageIndex == 2) {
      onIncorrect(bandageIndex);
    } else {
      pulse();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_dragging || _locked || _placed) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_dragging || _locked || _placed) return;
    _dragging = false;
    onAttempt();

    final reachedWound = position.distanceTo(target) <= acceptanceDistance;
    if (reachedWound && bandageIndex == 1) {
      _placed = true;
      _locked = true;
      position.setFrom(target);
      scale = Vector2.all(0.72);
      priority = 190;
      onCorrect(this);
      return;
    }

    if (reachedWound) onIncorrect(bandageIndex);
    _returnToStart();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_locked || _placed) return;
    _dragging = false;
    _returnToStart();
  }

  void _returnToStart() {
    position.setFrom(_startPosition);
    scale = Vector2.all(1);
    priority = 170;
  }
}

class _AidTapZone extends PositionComponent with TapCallbacks {
  final int requiredStep;
  final VoidCallback onPressed;
  bool active = false;

  _AidTapZone({
    required this.requiredStep,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 150);

  void pulse() {
    add(ScaleEffect.to(
      Vector2.all(1.08),
      EffectController(duration: 0.18, reverseDuration: 0.18, alternate: true, repeatCount: 2),
      onComplete: () => scale = Vector2.all(1),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (active) onPressed();
  }
}

class _AidMessage extends PositionComponent {
  final String text;
  final Color color;
  _AidMessage({required this.text, required this.color, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 24, size.y - 10),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.15)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF09172C));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.78)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class _AidButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _AidButton({required this.text, required this.color, required Vector2 position, required double width, required this.onPressed})
      : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF09172C));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.70)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}