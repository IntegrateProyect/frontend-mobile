import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';

enum LaboratoryChallengeKind { numeric, astronomy, biology, medical }

class LaboratoryChallengeConfig {
  final LaboratoryChallengeKind kind;
  final String instruction;
  final String apparatusEmoji;
  final String apparatusLabel;
  final List<String> steps;
  final Color color;

  /// Si se define, el reto usa el mockup como fondo completo
  /// (SpriteComponent) en vez del aro/iconos dibujados a mano.
  /// Nombre de archivo dentro de `assets/images/`.
  final String? backgroundAsset;

  /// Posición del aparato/objetivo como fracción (0.0-1.0) del
  /// tamaño del componente. Solo se usa si [backgroundAsset] no es nulo.
  final Vector2? apparatusFraction;

  /// Posición de cada estación/pieza arrastrable como fracción
  /// (0.0-1.0) del tamaño del componente. Solo se usa si
  /// [backgroundAsset] no es nulo.
  final List<Vector2>? stationFractions;

  /// Si es true, la pantalla debe usar
  /// NumericSequenceChallengeComponent en vez de este componente
  /// procedural — para el reto "completar la secuencia" los números
  /// se dibujan por código (ver numeric_sequence_challenge.dart),
  /// no como imagen de fondo estática.
  final bool useNumericSequenceChallenge;

  /// Si es true, la pantalla debe usar TraySequenceChallengeComponent
  /// (charola con N espacios secuenciales sobre imagen de fondo) en
  /// vez de este componente procedural (ver tray_sequence_challenge.dart).
  final bool useTraySequenceChallenge;

  /// Si es true, la pantalla usa el reto específico de las tres
  /// fases del eclipse con la tira fotográfica.
  final bool useEclipseSequenceChallenge;

  /// Activa la máquina de mecanizaciones aritméticas.
  final bool useArithmeticMachineChallenge;

  /// Activa el reto específico de enfoque del telescopio.
  final bool useTelescopeFocusChallenge;
  final bool usePlantCollectionChallenge;
  final bool useFirstAidChallenge;
  final bool useAtomicEnergyChallenge;
  final bool useAreaCarpetChallenge;
  final bool useAquariumCareChallenge;

  const LaboratoryChallengeConfig({
    required this.kind,
    required this.instruction,
    required this.apparatusEmoji,
    required this.apparatusLabel,
    required this.steps,
    required this.color,
    this.backgroundAsset,
    this.apparatusFraction,
    this.stationFractions,
    this.useNumericSequenceChallenge = false,
    this.useTraySequenceChallenge = false,
    this.useEclipseSequenceChallenge = false,
    this.useArithmeticMachineChallenge = false,
    this.useTelescopeFocusChallenge = false,
    this.usePlantCollectionChallenge = false,
    this.useFirstAidChallenge = false,
    this.useAtomicEnergyChallenge = false,
    this.useAreaCarpetChallenge = false,
    this.useAquariumCareChallenge = false,
  });

  bool get usesCustomBackground => backgroundAsset != null;

  static LaboratoryChallengeConfig fromQuestion(String rawText) {
    final text = _normalize(rawText);

    if (_has(text, ['cuidar un pequeno acuario', 'cuidado del acuario', 'acuario'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Ajusta la temperatura, el agua y el alimento del acuario',
        apparatusEmoji: '🐠',
        apparatusLabel: 'Acuario',
        steps: ['Temperatura', 'Agua', 'Alimento'],
        color: Color(0xFF45E6B0),
        useAquariumCareChallenge: true,
      );
    }

    // Debe ir antes del reto genérico de área que aparece más abajo.
    if (_has(text, ['area de un cuarto', 'alfombrarse', 'alfombrar'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Toca las casillas para cubrir el cuarto con alfombra',
        apparatusEmoji: '📐',
        apparatusLabel: 'Plano del cuarto',
        steps: ['Largo', 'Ancho', 'Área'],
        color: Color(0xFF29B6F6),
        useAreaCarpetChallenge: true,
      );
    }

    if (text.contains('energia atomica') ||
        text.contains('atomo') ||
        text.contains('atómica')) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Construye el átomo con las cantidades solicitadas',
        apparatusEmoji: '⚛️',
        apparatusLabel: 'Modelo atómico',
        steps: ['Protón', 'Neutrón', 'Electrón'],
        color: Color(0xFF9D70FF),
        useAtomicEnergyChallenge: true,
      );
    }

    if (text.contains('primeros auxilios') ||
        text.contains('practicar primeros auxilios')) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.medical,
        instruction: 'Aplica correctamente el vendaje y comprueba la circulación',
        apparatusEmoji: '🩹',
        apparatusLabel: 'Primeros auxilios',
        steps: ['Elegir', 'Proteger', 'Comprobar'],
        color: Color(0xFFFF526D),
        useFirstAidChallenge: true,
      );
    }

    if (text.contains('colecciones de plantas') ||
        text.contains('coleccion de plantas') ||
        text.contains('herbario')) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Toca la prensa para procesar tres muestras de hojas',
        apparatusEmoji: '🌿',
        apparatusLabel: 'Herbario',
        steps: ['Recolectar', 'Observar', 'Clasificar'],
        color: Color(0xFF4DE39A),
        usePlantCollectionChallenge: true,
      );
    }

    // Debe evaluarse antes de los retos genéricos de telescopio.
    if ((text.contains('telescopio') && text.contains('regalo')) ||
        text.contains('enfoque del telescopio') ||
        text.contains('enfocar el telescopio')) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Gira la perilla hasta enfocar la estrella',
        apparatusEmoji: '🔭',
        apparatusLabel: 'Telescopio',
        steps: ['Enfocar'],
        color: Color(0xFF55E8FF),
        useTelescopeFocusChallenge: true,
      );
    }

    // Esta condición debe estar antes de los retos numéricos genéricos.
    if (_has(text, [
      'mecanizaciones aritmeticas',
      'mecanizacion aritmetica',
      'ejecutar mecanizaciones',
      'mecanizaciones',
      'aritmeticas',
    ])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Elige una operación y confirma con la palanca',
        apparatusEmoji: '⚙️',
        apparatusLabel: 'Máquina',
        steps: ['+2', '×2', '−2'],
        color: Color(0xFF29B6F6),
        useArithmeticMachineChallenge: true,
      );
    }

    // --- "Completa la secuencia": ver NumericSequenceChallengeComponent ---
    if (_has(text, ['rompecabezas numerico', 'secuencia numerica'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Arrastra una pieza al espacio vacío',
        apparatusEmoji: '🧪',
        apparatusLabel: 'Banda',
        steps: ['🧪 Encajar'],
        color: Color(0xFF29B6F6),
        useNumericSequenceChallenge: true,
      );
    }

    if (_has(text, ['primeros auxilios'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.medical,
        instruction: 'Une cada herramienta con el botiquín, en el orden que tú elijas',
        apparatusEmoji: '🩺',
        apparatusLabel: 'Botiquín',
        steps: ['🛡️ Proteger', '📞 Avisar', '🩹 Auxiliar'],
        color: Color(0xFFFF4D6D),
      );
    }
    // --- "Charola con espacios en secuencia": ver TraySequenceChallengeComponent ---
    if (_has(text, ['operacion medica', 'analisis de sangre'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.medical,
        instruction: 'Une cada paso del procedimiento con la charola',
        apparatusEmoji: '🔬',
        apparatusLabel: 'Charola',
        steps: ['🧤 Guantes', '🧪 Muestra', '🔬 Analizar'],
        color: Color(0xFFFF4D6D),
        useTraySequenceChallenge: true,
      );
    }
    if (_has(text, ['eclipse'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Ordena las fases del eclipse',
        apparatusEmoji: '🔭',
        apparatusLabel: 'Telescopio',
        steps: ['☀️ Inicio', '🌘 Parcial', '🌑 Total'],
        color: Color(0xFFB388FF),
        useEclipseSequenceChallenge: true,
      );
    }
    if (_has(text, ['telescopio', 'estrellas'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Une cada pieza para preparar el observatorio',
        apparatusEmoji: '🔭',
        apparatusLabel: 'Telescopio',
        steps: ['🔭 Apuntar', '🎯 Enfocar', '✨ Observar'],
        color: Color(0xFFB388FF),
      );
    }
    if (_has(text, ['energia atomica'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Une cada partícula para construir el átomo',
        apparatusEmoji: '⚛️',
        apparatusLabel: 'Modelo',
        steps: ['🔴 Protón', '⚪ Neutrón', '🔵 Electrón'],
        color: Color(0xFFB388FF),
      );
    }
    if (_has(text, ['rocas'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.astronomy,
        instruction: 'Une cada roca con la bandeja de clasificación',
        apparatusEmoji: '🪨',
        apparatusLabel: 'Bandeja',
        steps: ['🪨 Observar', '⚖️ Comparar', '🗂️ Clasificar'],
        color: Color(0xFFB388FF),
      );
    }
    if (_has(text, ['abejas'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Sigue a la abeja y únela con el panal',
        apparatusEmoji: '🍯',
        apparatusLabel: 'Panal',
        steps: ['🌼 Flor', '🐝 Abeja', '🍯 Panal'],
        color: Color(0xFF3DDC97),
      );
    }
    if (_has(text, ['acuario'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Une cada cuidado con el acuario',
        apparatusEmoji: '🐠',
        apparatusLabel: 'Acuario',
        steps: ['🌡️ Temperatura', '💧 Agua', '🐟 Alimentar'],
        color: Color(0xFF3DDC97),
      );
    }
    if (_has(text, ['plantas'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Une cada muestra con el herbario',
        apparatusEmoji: '🌿',
        apparatusLabel: 'Herbario',
        steps: ['🌿 Recolectar', '🔍 Observar', '🏷️ Clasificar'],
        color: Color(0xFF3DDC97),
      );
    }
    if (_has(text, ['organismos', 'libros'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.biology,
        instruction: 'Une cada parte con el microscopio',
        apparatusEmoji: '🔬',
        apparatusLabel: 'Microscopio',
        steps: ['🫁 Sistema', '🧬 Célula', '🔬 Función'],
        color: Color(0xFF3DDC97),
      );
    }
    if (_has(text, ['porcentajes'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Une cada pieza para completar la secuencia',
        apparatusEmoji: '🧮',
        apparatusLabel: 'Calculadora',
        steps: ['25%', '50%', '75%'],
        color: Color(0xFF29B6F6),
      );
    }
    if (_has(text, ['area de un cuarto', 'alfombrarse'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Une cada herramienta para construir la fórmula',
        apparatusEmoji: '📐',
        apparatusLabel: 'Plano',
        steps: ['📏 Largo', '📐 Ancho', '✖️ Multiplicar'],
        color: Color(0xFF29B6F6),
      );
    }
    if (_has(text, ['logaritmos', 'raices'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Une cada pieza para seguir la ruta de cálculo',
        apparatusEmoji: '🧮',
        apparatusLabel: 'Tabla',
        steps: ['📖 Consultar', '🔎 Localizar', '🧮 Resolver'],
        color: Color(0xFF29B6F6),
      );
    }
    if (_has(text, ['regla de calculo'])) {
      return const LaboratoryChallengeConfig(
        kind: LaboratoryChallengeKind.numeric,
        instruction: 'Une cada pieza para ajustar la regla de cálculo',
        apparatusEmoji: '📏',
        apparatusLabel: 'Regla',
        steps: ['📏 Alinear', '↔️ Deslizar', '🎯 Leer'],
        color: Color(0xFF29B6F6),
      );
    }

    return const LaboratoryChallengeConfig(
      kind: LaboratoryChallengeKind.numeric,
      instruction: 'Une cada pieza para completar el patrón',
      apparatusEmoji: '🧪',
      apparatusLabel: 'Matraz',
      steps: ['2', '4', '8'],
      color: Color(0xFF29B6F6),
    );
  }

  static bool _has(String text, List<String> words) => words.any(text.contains);

  static String _normalize(String value) => value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u');
}

class LaboratoryChallengeComponent extends PositionComponent {
  final LaboratoryChallengeConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  static const double _apparatusY = 128;
  static const double _pipsY = _apparatusY + 92;
  static const double _gridStartY = _pipsY + 40;
  static const double _cardHeight = 100;
  static const double _cardGapY = 18;

  _HoloTarget? _apparatus;
  _ProgressPips? _pips;
  _ConnectorField? _connectors;
  TextBoxComponent? _hintMessage;
  final List<_StationNode> _pieces = [];

  int _consumed = 0;
  bool _touchedAny = false;
  bool _locked = false;

  final DateTime _startedAt = DateTime.now();

  LaboratoryChallengeComponent({
    required this.config,
    required this.onFinish,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topCenter);

  Vector2 get _apparatusPosition {
    if (config.usesCustomBackground && config.apparatusFraction != null) {
      final f = config.apparatusFraction!;
      return Vector2(size.x * f.x, size.y * f.y);
    }
    return Vector2(size.x / 2, _apparatusY);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (config.usesCustomBackground) {
      await _loadCustomBackgroundLayout();
    } else {
      await _loadProceduralLayout();
    }
  }

  Future<void> _loadCustomBackgroundLayout() async {
    final sprite = await Sprite.load(config.backgroundAsset!);
    add(SpriteComponent(
      sprite: sprite,
      position: Vector2.zero(),
      size: size,
    ));

    _apparatus = _HoloTarget(
      emoji: '',
      label: '',
      color: config.color,
      position: _apparatusPosition,
      showRing: true,
      showGlyphs: false,
    );
    add(_apparatus!);

    final fractions = config.stationFractions ?? const [];
    for (var i = 0; i < config.steps.length && i < fractions.length; i++) {
      final f = fractions[i];
      final piece = _StationNode(
        stationNumber: i + 1,
        label: config.steps[i],
        color: config.color,
        position: Vector2(size.x * f.x, size.y * f.y),
        targetPositionProvider: () => _apparatusPosition,
        onTouched: () => _touchedAny = true,
        onDropped: _onPieceDropped,
        transparentSkin: true,
      );
      _pieces.add(piece);
      add(piece);
    }

    add(_GhostButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x - 60, size.y - 30),
      width: 90,
      onPressed: () => _finish(reason: 'skipped'),
    ));
  }

  Future<void> _loadProceduralLayout() async {
    add(_AmbientIcons(
      color: config.color,
      icons: const ['⚕️', '🧪', '🔬', '⚗️', '✦'],
      size: size,
    ));

    add(TextBoxComponent(
      text: config.instruction,
      position: Vector2(size.x / 2, 2),
      size: Vector2(size.x - 24, 52),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFDCEFFF),
          fontSize: 15,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
      ),
    ));

    _connectors = _ConnectorField(
      stationsProvider: () => _pieces,
      targetProvider: () => _apparatusPosition,
      color: config.color,
      size: size,
    );
    add(_connectors!);

    _apparatus = _HoloTarget(
      emoji: config.apparatusEmoji,
      label: config.apparatusLabel,
      color: config.color,
      position: _apparatusPosition,
    );
    add(_apparatus!);

    _pips = _ProgressPips(
      total: config.steps.length,
      color: config.color,
      position: Vector2(size.x / 2, _pipsY),
    );
    add(_pips!);

    _layoutGrid();

    add(_GhostButton(
      text: '💡 Pista',
      color: config.color,
      position: Vector2(size.x / 2 - 58, _gridStartY + _rowsNeeded() * (_cardHeight + _cardGapY) + 26),
      width: 100,
      onPressed: _showHint,
    ));

    add(_GhostButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 58, _gridStartY + _rowsNeeded() * (_cardHeight + _cardGapY) + 26),
      width: 100,
      onPressed: () => _finish(reason: 'skipped'),
    ));
  }

  int _rowsNeeded() => (config.steps.length / 2).ceil();

  void _layoutGrid() {
    for (final piece in _pieces) {
      piece.removeFromParent();
    }
    _pieces.clear();

    const columns = 2;
    const cardWidth = 150.0;
    const gapX = 16.0;
    final total = config.steps.length;
    final rows = (total / columns).ceil();

    for (var i = 0; i < total; i++) {
      final row = i ~/ columns;
      final itemsInRow = min(columns, total - row * columns);
      final rowWidth = itemsInRow * cardWidth + (itemsInRow - 1) * gapX;
      final rowStartX = size.x / 2 - rowWidth / 2;
      final col = i % columns;

      final x = rowStartX + col * (cardWidth + gapX) + cardWidth / 2;
      final y = _gridStartY + row * (_cardHeight + _cardGapY) + _cardHeight / 2;

      final piece = _StationNode(
        stationNumber: i + 1,
        label: config.steps[i],
        color: config.color,
        position: Vector2(x, y),
        targetPositionProvider: () => _apparatusPosition,
        onTouched: () => _touchedAny = true,
        onDropped: _onPieceDropped,
      );
      _pieces.add(piece);
      add(piece);
    }
  }

  void _showHint() {
    if (_pieces.isEmpty) {
      _apparatus?.react();
      return;
    }

    final piece = _pieces.first;
    piece.showHint(_apparatusPosition);
    _apparatus?.react();

    _hintMessage?.removeFromParent();
    final message = TextBoxComponent(
      text: '↑ ARRASTRA LA ESTACIÓN QUE BRILLA AL ${config.apparatusLabel.toUpperCase()}',
      position: Vector2(size.x / 2, _pipsY + 18),
      size: Vector2(size.x - 34, 38),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
          color: config.color,
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
    _hintMessage = message;
    add(message);
  }

  void _onPieceDropped(_StationNode piece) {
    if (_locked) return;

    _consumed++;
    _touchedAny = true;
    _pips?.setFilled(_consumed);

    _apparatus?.react();
    add(BurstParticles(position: _apparatusPosition, color: config.color));

    _pieces.remove(piece);

    if (_consumed >= config.steps.length) {
      add(FloatingPraise(
        position: _apparatusPosition - Vector2(0, 66),
        text: '¡Actividad completada!',
        color: config.color,
      ));
      _finish(reason: 'completed');
    }
  }

  int _currentLevel() {
    if (_consumed >= config.steps.length) return 4;
    if (_consumed >= max(1, config.steps.length - 1)) return 3;
    if (_consumed > 0) return 2;
    if (_touchedAny) return 1;
    return 0;
  }

  void _finish({required String reason}) {
    if (_locked) return;
    _locked = true;

    final level = _currentLevel();
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;

    onFinish(level, <String, dynamic>{
      'activityKind': config.kind.name,
      'piecesCompleted': _consumed,
      'piecesTotal': config.steps.length,
      'touchedAny': _touchedAny,
      'completionTimeSeconds': elapsed,
      'endReason': reason,
    });
  }
}

class _AmbientIcons extends PositionComponent {
  final Color color;
  final List<String> icons;
  final Random _rng = Random();
  late List<Offset> _points;
  late List<String> _glyphs;

  _AmbientIcons({required this.color, required this.icons, required Vector2 size})
      : super(position: Vector2.zero(), size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    const count = 7;
    _points = List.generate(count, (_) => Offset(_rng.nextDouble() * size.x, _rng.nextDouble() * size.y));
    _glyphs = List.generate(count, (_) => icons[_rng.nextInt(icons.length)]);
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _points.length; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: _glyphs[i],
          style: TextStyle(fontSize: 22, color: color.withOpacity(0.07)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, _points[i]);
    }
  }
}

class _ConnectorField extends PositionComponent {
  final List<_StationNode> Function() stationsProvider;
  final Vector2 Function() targetProvider;
  final Color color;
  double _t = 0;

  _ConnectorField({
    required this.stationsProvider,
    required this.targetProvider,
    required this.color,
    required Vector2 size,
  }) : super(position: Vector2.zero(), size: size);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
  }

  @override
  void render(Canvas canvas) {
    final target = targetProvider();

    for (final station in stationsProvider()) {
      if (station.isConsumed || station.isDragging) continue;

      final start = station.position;
      final control = Offset(
        (start.x + target.x) / 2,
        min(start.y, target.y) - 30,
      );

      final path = Path()
        ..moveTo(start.x, start.y)
        ..quadraticBezierTo(control.dx, control.dy, target.x, target.y);

      canvas.drawPath(
        path,
        Paint()
          ..color = color.withOpacity(0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );

      for (final metric in path.computeMetrics()) {
        final len = metric.length;
        final offset = len * ((_t * 0.32) % 1);
        final tangent = metric.getTangentForOffset(offset);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            3.4,
            Paint()..color = color.withOpacity(0.85),
          );
        }
      }
    }
  }
}

class _HoloTarget extends PositionComponent {
  final String emoji;
  final String label;
  final Color color;
  final bool showRing;
  final bool showGlyphs;

  static const double _radius = 54;
  double _rotation = 0;

  _HoloTarget({
    required this.emoji,
    required this.label,
    required this.color,
    required Vector2 position,
    this.showRing = true,
    this.showGlyphs = true,
  }) : super(position: position, size: Vector2.all(_radius * 2 + 44), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (!showGlyphs) return;

    add(TextComponent(
      text: emoji,
      position: Vector2(size.x / 2, size.y / 2 - 4),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 40)),
    ));

    add(TextComponent(
      text: label.toUpperCase(),
      position: Vector2(size.x / 2, size.y / 2 + _radius + 12),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rotation += dt * 0.6;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    final glowPaint = Paint()
      ..color = color.withOpacity(showRing ? 0.22 : 0.28)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, showRing ? 16 : 20);
    canvas.drawCircle(center, _radius + (showRing ? 8 : 16), glowPaint);

    if (!showRing) return;

    canvas.drawCircle(center, _radius, Paint()..color = const Color(0xFF0B1626));
    canvas.drawCircle(center, _radius, Paint()..color = color.withOpacity(0.10));

    canvas.drawCircle(
      center,
      _radius - 8,
      Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final dashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashCount = 22;
    const sweep = (2 * pi / dashCount) * 0.5;
    for (int i = 0; i < dashCount; i++) {
      final start = _rotation + i * (2 * pi / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: _radius),
        start,
        sweep,
        false,
        dashPaint,
      );
    }
  }

  void react() {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.18), EffectController(duration: 0.14, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.32, curve: Curves.elasticOut)),
    ]));
  }
}

class _ProgressPips extends PositionComponent {
  final int total;
  final Color color;
  int _filled = 0;

  _ProgressPips({required this.total, required this.color, required Vector2 position})
      : super(position: position, size: Vector2(total * 30.0, 22), anchor: Anchor.center);

  void setFilled(int filled) {
    _filled = filled.clamp(0, total);
  }

  @override
  void render(Canvas canvas) {
    if (total <= 0) return;
    const dotRadius = 9.0;
    final spacing = size.x / total;

    if (total > 1) {
      canvas.drawLine(
        Offset(spacing / 2, size.y / 2),
        Offset(size.x - spacing / 2, size.y / 2),
        Paint()
          ..color = color.withOpacity(0.25)
          ..strokeWidth = 2,
      );
    }

    for (var i = 0; i < total; i++) {
      final cx = spacing * i + spacing / 2;
      final center = Offset(cx, size.y / 2);
      final isFilled = i < _filled;

      if (isFilled) {
        canvas.drawCircle(
          center,
          dotRadius + 3,
          Paint()
            ..color = color.withOpacity(0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        canvas.drawCircle(center, dotRadius, Paint()..color = color);

        final numberPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        numberPainter.paint(
          canvas,
          center - Offset(numberPainter.width / 2, numberPainter.height / 2),
        );
      } else {
        canvas.drawCircle(center, dotRadius, Paint()..color = const Color(0xFF0F2033));
        canvas.drawCircle(
          center,
          dotRadius,
          Paint()
            ..color = color.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6,
        );
      }
    }
  }
}

class _StationNode extends PositionComponent with DragCallbacks, IdleBreathing {
  final int stationNumber;
  final String label;
  final Color color;
  final void Function(_StationNode piece) onDropped;
  final VoidCallback onTouched;
  final Vector2 Function() targetPositionProvider;

  final bool transparentSkin;

  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _consumed = false;

  static const double _radius = 38;
  static final Vector2 _cardSize = Vector2(150, 100);
  static final Vector2 _hitboxSize = Vector2(96, 96);

  late final String _emojiPart;
  late final String _textPart;

  _StationNode({
    required this.stationNumber,
    required this.label,
    required this.color,
    required Vector2 position,
    required this.onDropped,
    required this.onTouched,
    required this.targetPositionProvider,
    this.transparentSkin = false,
  }) : super(
    position: position,
    size: (transparentSkin ? _hitboxSize : _cardSize).clone(),
    anchor: Anchor.center,
  ) {
    originalPosition = position.clone();

    final parts = label.split(' ');
    if (parts.length > 1 && _looksLikeEmoji(parts.first)) {
      _emojiPart = parts.first;
      _textPart = parts.sublist(1).join(' ');
    } else {
      _emojiPart = '';
      _textPart = label;
    }
  }

  static bool _looksLikeEmoji(String value) => value.runes.any((r) => r > 0x2100);

  Color get _accent => color;

  bool get isConsumed => _consumed;
  bool get isDragging => _isDragging;

  @override
  bool get isIdleAnimated => !_isDragging && !_consumed && !transparentSkin;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (transparentSkin) return;

    final circleCenterY = size.y / 2 - 16;

    if (_emojiPart.isNotEmpty) {
      add(TextComponent(
        text: _emojiPart,
        position: Vector2(size.x / 2, circleCenterY),
        anchor: Anchor.center,
        textRenderer: TextPaint(style: const TextStyle(fontSize: 24)),
      ));
    } else {
      add(TextComponent(
        text: _textPart,
        position: Vector2(size.x / 2, circleCenterY),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(color: _accent, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ));
    }

    if (_emojiPart.isNotEmpty) {
      add(TextComponent(
        text: _textPart,
        position: Vector2(size.x / 2, circleCenterY + _radius + 14),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
          style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 11.5, fontWeight: FontWeight.w700),
        ),
      ));
    }

    add(TextComponent(
      text: 'ESTACIÓN $stationNumber',
      position: Vector2(size.x / 2, circleCenterY + _radius + (_emojiPart.isNotEmpty ? 32 : 14)),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(color: _accent.withOpacity(0.75), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 1.1),
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    if (transparentSkin) {
      final center = Offset(size.x / 2, size.y / 2);
      canvas.drawCircle(
        center,
        size.x / 2,
        Paint()
          ..color = _accent.withOpacity(_consumed ? 0.0 : 0.14)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
      return;
    }

    final center = Offset(size.x / 2, size.y / 2 - 16);

    canvas.drawCircle(
      center,
      _radius + 10,
      Paint()
        ..color = _accent.withOpacity(_consumed ? 0.5 : 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    canvas.drawCircle(center, _radius, Paint()..color = const Color(0xFF0F2033));
    canvas.drawCircle(center, _radius, Paint()..color = _accent.withOpacity(0.10));

    canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = _accent.withOpacity(_consumed ? 1.0 : 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  void showHint(Vector2 targetPosition) {
    if (_consumed || _isDragging) return;

    final direction = targetPosition - position;
    if (direction.length > 0) {
      direction.normalize();
      final offset = direction * 32.0;

      add(SequenceEffect([
        MoveEffect.by(
          offset,
          EffectController(duration: 0.28, curve: Curves.easeOut),
        ),
        MoveEffect.by(
          -offset,
          EffectController(duration: 0.34, curve: Curves.easeInOut),
        ),
      ]));
    }

    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.16), EffectController(duration: 0.18, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.20, curve: Curves.easeIn)),
      ScaleEffect.to(Vector2.all(1.16), EffectController(duration: 0.18, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.24, curve: Curves.easeIn)),
    ]));
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_consumed) return;
    _isDragging = true;
    onTouched();
    scale = Vector2.all(1.12);
    priority = 5;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || _consumed) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging || _consumed) return;
    _isDragging = false;

    final target = targetPositionProvider();
    final distance = position.distanceTo(target);

    if (distance < 100) {
      _consumed = true;
      scale = Vector2.all(1);
      playSuccessBounce();
      position.setFrom(target);
      onDropped(this);
    } else {
      scale = Vector2.all(1);
      position.setFrom(originalPosition);
    }
  }
}

class _GhostButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  _GhostButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
    double width = 100,
  }) : super(position: position, size: Vector2(width, 36), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(color: color.withOpacity(0.95), fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF0F2033).withOpacity(0.7));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}