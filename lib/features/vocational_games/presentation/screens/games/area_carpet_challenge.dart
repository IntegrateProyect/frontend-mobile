import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';

class AreaCarpetConfig {
  final String backgroundAsset;
  final int columns;
  final int rows;

  const AreaCarpetConfig({
    required this.backgroundAsset,
    required this.columns,
    required this.rows,
  });

  static const defaultConfig = AreaCarpetConfig(
    backgroundAsset: 'areacuadroalfombrarse.png',
    columns: 5,
    rows: 5,
  );
}

class AreaCarpetChallengeComponent extends PositionComponent {
  final AreaCarpetConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  final List<_CarpetTile> _tiles = [];
  TextComponent? _counter;
  _AreaProgressPips? _progressPips;
  TextBoxComponent? _result;
  PositionComponent? _message;

  int _covered = 0;
  int _hintIndex = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  static const List<String> _areaFacts = <String>[
    '📐 ¿Sabías que? El área indica cuánto espacio cubre una superficie.',
    '🟧 ¿Sabías que? Cada casilla de este plano representa 1 metro cuadrado.',
    '📏 ¿Sabías que? Un metro cuadrado mide 1 metro de largo por 1 metro de ancho.',
    '🏠 ¿Sabías que? Medir el área evita comprar alfombra de más o de menos.',
    '✖️ ¿Sabías que? En un rectángulo, el área se obtiene multiplicando largo por ancho.',
    '🔲 ¿Sabías que? Contar casillas completas también permite calcular una superficie.',
    '🧶 ¿Sabías que? La alfombra suele venderse usando medidas de superficie.',
    '📐 ¿Sabías que? Dos habitaciones pueden tener la misma área y formas diferentes.',
    '📏 ¿Sabías que? Antes de alfombrar también se deben medir puertas y obstáculos.',
    '🟧 ¿Sabías que? Cinco filas de cinco casillas forman una superficie de 25 m².',
    '🏗️ ¿Sabías que? Arquitectos y constructores usan áreas para calcular materiales.',
    '💡 ¿Sabías que? Dividir una figura en cuadrados facilita medir espacios irregulares.',
  ];

  AreaCarpetChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  int get total => config.columns * config.rows;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addBackground();
    _addInstruction();
    _addGrid();
    _addMeasurements();
    _addCounter();
    _addProgressPips();
    _addResult();
    _addButtons();
  }

  Future<void> _addBackground() async {
    try {
      final background = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(
        sprite: background,
        size: size.clone(),
        priority: -100,
      ));
    } catch (error) {
      debugPrint('No se pudo cargar ${config.backgroundAsset}: $error');
      add(RectangleComponent(
        size: size.clone(),
        priority: -100,
        paint: Paint()..color = const Color(0xFF020C2A),
      ));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Toca cada casilla del cuarto para cubrirla con alfombra.',
      position: Vector2(size.x / 2, size.y * 0.025),
      size: Vector2(size.x - 50, 46),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 220,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE8F5FF),
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    ));
  }

  void _addGrid() {
    // Interior exacto del cuarto dibujado en la plantilla.
    // Coordenadas de la plantilla limpia 5 x 5 (852 x 1846 px).
    final origin = Vector2(size.x * 0.1937, size.y * 0.3413);
    final gridSize = Vector2(size.x * 0.6279, size.y * 0.2914);
    final cellSize = Vector2(
      gridSize.x / config.columns,
      gridSize.y / config.rows,
    );

    for (var row = 0; row < config.rows; row++) {
      for (var column = 0; column < config.columns; column++) {
        final tile = _CarpetTile(
          position: origin + Vector2(column * cellSize.x, row * cellSize.y),
          size: cellSize,
          onCovered: _onTileCovered,
        );
        _tiles.add(tile);
        add(tile);
      }
    }
  }

  void _addMeasurements() {
    add(_MeasurementLabel(
      text: '${config.rows} m',
      position: Vector2(size.x * 0.0915, size.y * 0.4870),
      size: Vector2(size.x * 0.115, 38),
    ));
    add(_MeasurementLabel(
      text: '${config.columns} m',
      position: Vector2(size.x * 0.4930, size.y * 0.6900),
      size: Vector2(size.x * 0.170, 38),
    ));
  }

  void _addCounter() {
    add(RectangleComponent(
      position: Vector2(size.x / 2, size.y * 0.135),
      size: Vector2(176, 28),
      anchor: Anchor.center,
      priority: 225,
      paint: Paint()..color = const Color(0xFF07162E).withOpacity(0.96),
    ));
    _counter = TextComponent(
      text: '0 / $total casillas',
      // Encima de los indicadores dibujados en la plantilla.
      position: Vector2(size.x / 2, size.y * 0.135),
      anchor: Anchor.center,
      priority: 230,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFA726),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
    add(_counter!);
  }

  void _addProgressPips() {
    // Se coloca exactamente sobre los 25 cuadros vacíos de la plantilla.
    _progressPips = _AreaProgressPips(
      position: Vector2(size.x * 0.3509, size.y * 0.1685),
      size: Vector2(size.x * 0.2981, size.y * 0.1387),
      total: total,
    );
    add(_progressPips!);
  }

  void _addResult() {
    _result = TextBoxComponent(
      text: 'Área cubierta: 0 m²',
      position: Vector2(size.x / 2, size.y * 0.804),
      size: Vector2(size.x * 0.70, 48),
      anchor: Anchor.center,
      align: Anchor.center,
      priority: 230,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE8F5FF),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
    add(_result!);
  }

  void _onTileCovered(_CarpetTile tile) {
    if (_locked || tile.covered) return;
    tile.cover();
    _covered++;
    _counter?.text = '$_covered / $total casillas';
    _progressPips?.covered = _covered;
    _result?.text = 'Área cubierta: $_covered m²';

    add(BurstParticles(
      position: tile.position + tile.size / 2,
      color: const Color(0xFFFFA726),
    ));

    // Presenta un dato nuevo al completar cada pareja de casillas.
    if (_covered.isEven && _covered < total) {
      final factIndex = (_covered ~/ 2 - 1) % _areaFacts.length;
      _showMessage(_areaFacts[factIndex]);
    }

    if (_covered >= total) {
      _showMessage('¡Cuarto terminado! ${config.columns} × ${config.rows} = $total m²');
      Future<void>.delayed(const Duration(milliseconds: 850), () {
        if (isMounted) _finish('completed');
      });
    }
  }

  void _showHint() {
    if (_locked) return;
    const hints = <String>[
      'Empieza por una esquina y avanza casilla por casilla.',
      'Cada casilla naranja representa un metro cuadrado cubierto.',
      'Observa cuántas filas y columnas tiene el cuarto.',
      'El área total será la cantidad de casillas cubiertas.',
    ];
    final safeIndex = _hintIndex.clamp(0, hints.length - 1).toInt();
    _showMessage(hints[safeIndex]);
    if (_hintIndex < hints.length - 1) _hintIndex++;
  }

  void _showMessage(String text) {
    _message?.removeFromParent();
    late final _AreaMessage message;
    message = _AreaMessage(
      text: text,
      position: Vector2(size.x / 2, 118),
      size: Vector2(size.x - 68, 52),
      onDismiss: () {
        if (identical(_message, message)) {
          message.removeFromParent();
          _message = null;
        }
      },
    );
    _message = message;
    add(message);
  }

  void _addButtons() {
    add(_AreaButton(
      text: '💡 Pista',
      color: const Color(0xFF29B6F6),
      position: Vector2(size.x / 2 - 62, size.y - 38),
      onPressed: _showHint,
    ));
    add(_AreaButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 38),
      onPressed: () => _finish('skipped'),
    ));
  }

  int _level() {
    if (_covered >= total) return 4;
    if (_covered >= (total * 0.66).ceil()) return 3;
    if (_covered > 0) return 2;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    onFinish(_level(), <String, dynamic>{
      'activityKind': 'mathematics',
      'challengeType': 'carpetArea',
      'coveredSquares': _covered,
      'totalSquares': total,
      'length': config.columns,
      'width': config.rows,
      'area': _covered,
      'completionTimeSeconds': DateTime.now().difference(_startedAt).inSeconds,
      'endReason': reason,
    });
  }
}

class _AreaProgressPips extends PositionComponent {
  final int total;
  int covered = 0;

  _AreaProgressPips({
    required Vector2 position,
    required Vector2 size,
    required this.total,
  }) : super(position: position, size: size, priority: 228);

  @override
  void render(Canvas canvas) {
    const columns = 5;
    const rows = 5;
    final unitWidth = size.x / columns;
    final unitHeight = size.y / rows;

    for (var index = 0; index < total && index < columns * rows; index++) {
      if (index >= covered) continue;
      final column = index % columns;
      final row = index ~/ columns;
      final rect = Rect.fromLTWH(
        column * unitWidth + unitWidth * 0.09,
        row * unitHeight + unitHeight * 0.10,
        unitWidth * 0.80,
        unitHeight * 0.78,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.5)),
        Paint()..color = const Color(0xFFFFA31A),
      );
    }
  }
}

class _CarpetTile extends PositionComponent with TapCallbacks {
  final void Function(_CarpetTile tile) onCovered;
  bool covered = false;

  _CarpetTile({
    required Vector2 position,
    required Vector2 size,
    required this.onCovered,
  }) : super(position: position, size: size, priority: 100);

  void cover() => covered = true;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onCovered(this);
  }

  @override
  void render(Canvas canvas) {
    if (!covered) return;
    final rect = Rect.fromLTWH(1.2, 1.2, size.x - 2.4, size.y - 2.4);
    final carpetPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFB12B), Color(0xFFE87500)],
      ).createShader(rect);
    canvas.drawRect(rect, carpetPaint);

    // Textura discreta para que parezca alfombra y no un bloque plano.
    canvas.save();
    canvas.clipRect(rect);
    final fiber = Paint()
      ..color = const Color(0xFFFFD27A).withOpacity(0.18)
      ..strokeWidth = 0.7;
    for (double x = -size.y; x < size.x; x += 7) {
      canvas.drawLine(Offset(x, size.y), Offset(x + size.y, 0), fiber);
    }
    canvas.restore();

    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFFFC45A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}

class _MeasurementLabel extends PositionComponent {
  final String text;

  _MeasurementLabel({required this.text, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 220);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF72E6FF), fontSize: 13, fontWeight: FontWeight.w900),
      ),
    ));
  }
}

class _AreaMessage extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onDismiss;

  _AreaMessage({required this.text, required Vector2 position, required Vector2 size, required this.onDismiss})
      : super(position: position, size: size, anchor: Anchor.center, priority: 350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(
      text: text,
      position: size / 2,
      size: Vector2(size.x - 22, size.y - 8),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFF72E6FF), fontSize: 12.5, fontWeight: FontWeight.w800),
      ),
    ));
    add(TimerComponent(period: 3, removeOnFinish: true, onTick: onDismiss));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF081831).withOpacity(0.96));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF29B6F6)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) => onDismiss();
}

class _AreaButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  _AreaButton({required this.text, required this.color, required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(108, 36), anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF081831).withOpacity(0.92));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}