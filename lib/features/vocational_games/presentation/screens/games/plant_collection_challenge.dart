import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlantCollectionConfig {
  final String backgroundAsset;
  final int samplesTotal;
  final List<String> hints;

  const PlantCollectionConfig({
    required this.backgroundAsset,
    required this.samplesTotal,
    required this.hints,
  });

  static const defaultConfig = PlantCollectionConfig(
    backgroundAsset: 'coleccionplantas.png',
    samplesTotal: 3,
    hints: <String>[
      'Toca la prensa circular verde para colocar la primera muestra.',
      'Muy bien. Vuelve a tocar la prensa para observar la segunda muestra.',
      'Falta una muestra. Toca nuevamente la prensa para clasificarla.',
    ],
  );
}

class PlantCollectionChallengeComponent extends PositionComponent {
  final PlantCollectionConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final _PlantPressButton _press;
  late final _PlantStatusOverlay _status;
  PositionComponent? _hint;
  PositionComponent? _fact;

  int _samples = 0;
  int _touches = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  PlantCollectionChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addInstruction();

    // Un solo overlay controla los puntos inferiores y las tres etapas
    // laterales. No se dibuja nada sobre el medidor derecho del PNG.
    _status = _PlantStatusOverlay(
      size: size.clone(),
      completed: 0,
    );
    add(_status);

    _press = _PlantPressButton(
      position: Vector2(size.x * 0.5, size.y * 0.420),
      size: Vector2(size.x * 0.30, size.x * 0.20),
      onPressed: _processSample,
    );
    add(_press);

    _addButtons();
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
        paint: Paint()..color = const Color(0xFF01182A),
      ));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Toca la prensa para observar y clasificar las tres muestras de hojas.',
      position: Vector2(size.x / 2, size.y * 0.025),
      size: Vector2(size.x - 48, 58),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 200,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE4FFF2),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    ));
  }

  void _processSample() {
    if (_locked) return;
    _touches++;
    if (_samples >= config.samplesTotal) return;

    _samples++;
    _status.completed = _samples;
    _press.pulse();
    _hint?.removeFromParent();
    _hint = null;
    _showClassificationFact(_samples - 1);

    if (_samples >= config.samplesTotal) {
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (!_locked) _finish('completed');
      });
    }
  }

  void _showClassificationFact(int index) {
    const facts = <String>[
      'Las hojas simples tienen una sola lámina, aunque pueden presentar cortes o formas muy distintas.',
      'Cada parte de una hoja compuesta se llama folíolo y todas juntas forman una sola hoja.',
      'Las hojas de margen entero tienen un borde liso, sin dientes ni divisiones visibles.',
    ];
    _fact?.removeFromParent();
    final card = _PlantFactCard(
      title: '🌿 ¿Sabías que?  ${index + 1}/3',
      text: facts[index.clamp(0, facts.length - 1)],
      position: Vector2(size.x / 2, size.y * 0.185),
      size: Vector2(size.x - 72, 88),
    );
    _fact = card;
    add(card);
  }

  void _addButtons() {
    add(_PlantButton(
      text: '💡 Pista',
      color: const Color(0xFF4DE39A),
      position: Vector2(size.x / 2 - 62, size.y - 40),
      width: 108,
      onPressed: _showHint,
    ));
    add(_PlantButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 40),
      width: 108,
      onPressed: () => _finish('skipped'),
    ));
  }

  void _showHint() {
    if (_locked) return;
    _hint?.removeFromParent();
    final index = _samples.clamp(0, config.hints.length - 1);
    final banner = _PlantHint(
      text: config.hints[index],
      position: Vector2(size.x / 2, size.y - 96),
      size: Vector2(size.x - 64, 52),
    );
    _hint = banner;
    add(banner);
    _press.pulse();
  }

  int _level() {
    if (_samples >= config.samplesTotal) return 4;
    if (_samples == 2) return 3;
    if (_samples == 1) return 2;
    if (_touches > 0) return 1;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    _press.lock();
    _hint?.removeFromParent();
    _fact?.removeFromParent();
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(_level(), <String, dynamic>{
      'activityKind': 'biology',
      'challengeType': 'plantCollection',
      'samplesProcessed': _samples,
      'samplesTotal': config.samplesTotal,
      'touches': _touches,
      'completionTimeSeconds': elapsed,
      'endReason': reason,
    });
  }
}

class _PlantPressButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  bool _locked = false;

  _PlantPressButton({
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(position: position, size: size, anchor: Anchor.center, priority: 100);

  void lock() => _locked = true;

  void pulse() {
    add(ScaleEffect.to(
      Vector2.all(1.06),
      EffectController(duration: 0.16, reverseDuration: 0.16, alternate: true),
      onComplete: () => scale = Vector2.all(1),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!_locked) onPressed();
  }
}

class _PlantStatusOverlay extends PositionComponent {
  int completed;

  _PlantStatusOverlay({required Vector2 size, required this.completed})
      : super(size: size, priority: 125);

  @override
  void render(Canvas canvas) {
    // Conserva los círculos originales del PNG y agrega una verificación
    // pequeña al lado de cada clasificación completada.
    const stageY = <double>[0.426, 0.499, 0.589];
    for (var i = 0; i < 3; i++) {
      final active = i < completed;
      if (active) {
        final badge = Offset(size.x * 0.168, size.y * stageY[i]);
        canvas.drawCircle(badge, 11, Paint()..color = const Color(0xFF092F2B));
        canvas.drawCircle(badge, 9, Paint()..color = const Color(0xFF55F0A4));
        final checkPaint = Paint()
          ..color = const Color(0xFF043126)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2.5;
        final check = Path()
          ..moveTo(badge.dx - 4, badge.dy)
          ..lineTo(badge.dx - 1, badge.dy + 3)
          ..lineTo(badge.dx + 5, badge.dy - 4);
        canvas.drawPath(check, checkPaint);
      }
    }

    // Los tres puntos inferiores impresos se cubren y se redibujan en orden.
    const pointX = <double>[0.393, 0.500, 0.607];
    for (var i = 0; i < 3; i++) {
      final center = Offset(size.x * pointX[i], size.y * 0.748);
      final active = i < completed;
      canvas.drawCircle(center, 13, Paint()..color = const Color(0xFF071C2A));
      canvas.drawCircle(
        center,
        8,
        Paint()
          ..color = active
              ? const Color(0xFF55F0A4)
              : const Color(0xFF263E50),
      );
      canvas.drawCircle(
        center,
        12,
        Paint()
          ..color = (active
              ? const Color(0xFF55F0A4)
              : const Color(0xFF496171))
              .withOpacity(0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }
}

class _PlantFactCard extends PositionComponent {
  final String title;
  final String text;

  _PlantFactCard({
    required this.title,
    required this.text,
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 330,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: title,
      position: Vector2(size.x / 2, 10),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF55F0A4),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    ));
    add(TextBoxComponent(
      text: text,
      position: Vector2(size.x / 2, 34),
      size: Vector2(size.x - 28, 44),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE7FFF2),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16),
    );
    canvas.drawRRect(
      shape,
      Paint()
        ..color = const Color(0xFF4DE39A).withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071D29));
    canvas.drawRRect(
      shape,
      Paint()
        ..color = const Color(0xFF4DE39A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }
}

class _PlantHint extends PositionComponent {
  final String text;
  _PlantHint({required this.text, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 22, size.y - 8),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE5FFF1), fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.15)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071D29));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF4DE39A)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class _PlantButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _PlantButton({required this.text, required this.color, required Vector2 position, required double width, required this.onPressed})
      : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF071A28));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.72)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
