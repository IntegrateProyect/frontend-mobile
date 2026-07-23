import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class AtomicEnergyConfig {
  final String backgroundAsset;
  final int targetProtons;
  final int targetNeutrons;
  final int targetElectrons;

  const AtomicEnergyConfig({
    required this.backgroundAsset,
    required this.targetProtons,
    required this.targetNeutrons,
    required this.targetElectrons,
  });

  static const defaultConfig = AtomicEnergyConfig(
    backgroundAsset: 'energiaatomica.png',
    targetProtons: 2,
    targetNeutrons: 2,
    targetElectrons: 3,
  );
}

class AtomicEnergyChallengeComponent extends PositionComponent {
  final AtomicEnergyConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  late final TextComponent _protonCounter;
  late final TextComponent _neutronCounter;
  late final TextComponent _electronCounter;
  late final _NucleusParticles _nucleus;
  late final _OrbitElectrons _electrons;
  PositionComponent? _message;

  int _protons = 0;
  int _neutrons = 0;
  int _electronCount = 0;
  int _touches = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  AtomicEnergyChallengeComponent({
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
    _addCounters();

    _nucleus = _NucleusParticles(
      position: Vector2(size.x * 0.5, size.y * 0.525),
      size: Vector2.all(size.x * 0.20),
      protons: 0,
      neutrons: 0,
    );
    add(_nucleus);

    _electrons = _OrbitElectrons(
      size: size.clone(),
      count: 0,
    );
    add(_electrons);

    _addParticleButton(
      position: Vector2(size.x * 0.188, size.y * 0.785),
      color: const Color(0xFFFF4E4E),
      onPressed: _addProton,
    );
    _addParticleButton(
      position: Vector2(size.x * 0.500, size.y * 0.785),
      color: const Color(0xFFF2F4F8),
      onPressed: _addNeutron,
    );
    _addParticleButton(
      position: Vector2(size.x * 0.812, size.y * 0.785),
      color: const Color(0xFF16A8FF),
      onPressed: _addElectron,
    );

    _addBottomButtons();
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
        paint: Paint()..color = const Color(0xFF030D2C),
      ));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Construye el átomo agregando las cantidades solicitadas de protones, neutrones y electrones.',
      position: Vector2(size.x / 2, size.y * 0.022),
      size: Vector2(size.x - 48, 62),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 230,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE8E4FF),
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    ));
  }

  void _addCounters() {
    _protonCounter = _counter(Vector2(size.x * 0.278, size.y * 0.302));
    _neutronCounter = _counter(Vector2(size.x * 0.505, size.y * 0.302));
    _electronCounter = _counter(Vector2(size.x * 0.790, size.y * 0.302));
    add(_protonCounter);
    add(_neutronCounter);
    add(_electronCounter);
    _updateCounters();
  }

  TextComponent _counter(Vector2 position) => TextComponent(
    text: '0/0',
    position: position,
    anchor: Anchor.center,
    priority: 210,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFF4F6FF),
        fontSize: 13,
        fontWeight: FontWeight.w900,
      ),
    ),
  );

  void _addParticleButton({
    required Vector2 position,
    required Color color,
    required VoidCallback onPressed,
  }) {
    add(_AtomButton(
      position: position,
      size: Vector2.all(size.x * 0.235),
      color: color,
      onPressed: () {
        if (_locked) return;
        _touches++;
        add(_TouchRipple(position: position.clone(), color: color));
        onPressed();
      },
    ));
  }

  void _addProton() {
    if (_protons >= config.targetProtons) {
      _showMessage('Ya agregaste todos los protones solicitados.', const Color(0xFFFF6B78));
      return;
    }
    _protons++;
    _nucleus.protons = _protons;
    _afterParticleAdded();
  }

  void _addNeutron() {
    if (_neutrons >= config.targetNeutrons) {
      _showMessage('Ya agregaste todos los neutrones solicitados.', const Color(0xFFFF6B78));
      return;
    }
    _neutrons++;
    _nucleus.neutrons = _neutrons;
    _afterParticleAdded();
  }

  void _addElectron() {
    if (_electronCount >= config.targetElectrons) {
      _showMessage('Las tres posiciones de la órbita ya están ocupadas.', const Color(0xFFFF6B78));
      return;
    }
    _electronCount++;
    _electrons.count = _electronCount;
    _afterParticleAdded();
  }

  void _afterParticleAdded() {
    _message?.removeFromParent();
    _message = null;
    _updateCounters();
    if (_isComplete) {
      _showMessage('¡Átomo completado! El núcleo y las órbitas tienen las cantidades correctas.', const Color(0xFF67E8FF));
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!_locked) _finish('completed');
      });
    }
  }

  void _updateCounters() {
    _protonCounter.text = '$_protons/${config.targetProtons}';
    _neutronCounter.text = '$_neutrons/${config.targetNeutrons}';
    _electronCounter.text = '$_electronCount/${config.targetElectrons}';
  }

  bool get _isComplete =>
      _protons == config.targetProtons &&
          _neutrons == config.targetNeutrons &&
          _electronCount == config.targetElectrons;

  void _showHint() {
    if (_locked) return;
    String text;
    if (_protons < config.targetProtons) {
      text = 'El núcleo necesita partículas con carga positiva. Revisa el color asociado al protón.';
    } else if (_neutrons < config.targetNeutrons) {
      text = 'El núcleo también necesita partículas sin carga eléctrica.';
    } else {
      text = 'Observa los círculos vacíos en las órbitas: cada uno necesita una partícula negativa.';
    }
    _showMessage(text, const Color(0xFFB78CFF));
  }

  void _showMessage(String text, Color color) {
    _message?.removeFromParent();
    final banner = _AtomMessage(
      text: text,
      color: color,
      position: Vector2(size.x / 2, size.y * 0.895),
      size: Vector2(size.x - 66, 58),
    );
    _message = banner;
    add(banner);
  }

  void _addBottomButtons() {
    add(_SmallAtomButton(
      text: '💡 Pista',
      color: const Color(0xFFB78CFF),
      position: Vector2(size.x / 2 - 62, size.y - 38),
      width: 108,
      onPressed: _showHint,
    ));
    add(_SmallAtomButton(
      text: 'Saltar',
      color: const Color(0xFF90A4AE),
      position: Vector2(size.x / 2 + 62, size.y - 38),
      width: 108,
      onPressed: () => _finish('skipped'),
    ));
  }

  int _level() {
    final added = _protons + _neutrons + _electronCount;
    if (_isComplete) return 4;
    if (added >= 5) return 3;
    if (added >= 2) return 2;
    if (_touches > 0) return 1;
    return 0;
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(_level(), <String, dynamic>{
      'activityKind': 'science',
      'challengeType': 'atomicEnergy',
      'protons': _protons,
      'neutrons': _neutrons,
      'electrons': _electronCount,
      'touches': _touches,
      'completionTimeSeconds': elapsed,
      'endReason': reason,
    });
  }
}

class _NucleusParticles extends PositionComponent {
  int protons;
  int neutrons;
  _NucleusParticles({required Vector2 position, required Vector2 size, required this.protons, required this.neutrons})
      : super(position: position, size: size, anchor: Anchor.center, priority: 160);

  @override
  void render(Canvas canvas) {
    final particles = <Color>[
      ...List<Color>.filled(protons, const Color(0xFFFF514E)),
      ...List<Color>.filled(neutrons, const Color(0xFFF2F4F8)),
    ];
    const offsets = <Offset>[
      Offset(-16, -12), Offset(16, 12), Offset(15, -13), Offset(-15, 14),
    ];
    final center = Offset(size.x / 2, size.y / 2);
    for (var i = 0; i < particles.length && i < offsets.length; i++) {
      final p = center + offsets[i];
      canvas.drawCircle(p, 15, Paint()..color = particles[i]);
      canvas.drawCircle(p - const Offset(4, 5), 4, Paint()..color = Colors.white.withOpacity(0.75));
    }
  }
}

class _OrbitElectrons extends PositionComponent {
  int count;
  _OrbitElectrons({required Vector2 size, required this.count}) : super(size: size, priority: 165);

  @override
  void render(Canvas canvas) {
    final slots = <Offset>[
      Offset(size.x * 0.728, size.y * 0.398),
      Offset(size.x * 0.262, size.y * 0.585),
      Offset(size.x * 0.740, size.y * 0.585),
    ];
    for (var i = 0; i < count && i < slots.length; i++) {
      canvas.drawCircle(slots[i], 12, Paint()..color = const Color(0xFF119DFF));
      canvas.drawCircle(slots[i] - const Offset(3, 4), 3.5, Paint()..color = Colors.white.withOpacity(0.82));
    }
  }
}

class _AtomButton extends PositionComponent with TapCallbacks {
  final Color color;
  final VoidCallback onPressed;
  _AtomButton({required Vector2 position, required Vector2 size, required this.color, required this.onPressed})
      : super(position: position, size: size, anchor: Anchor.center, priority: 190);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _TouchRipple extends PositionComponent {
  final Color color;
  double _age = 0;
  _TouchRipple({required Vector2 position, required this.color})
      : super(position: position, size: Vector2.all(1), anchor: Anchor.center, priority: 250);

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= 0.45) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_age / 0.45).clamp(0.0, 1.0);
    canvas.drawCircle(Offset.zero, 22 + 34 * t, Paint()..color = color.withOpacity((1 - t) * 0.55)..style = PaintingStyle.stroke..strokeWidth = 4 * (1 - t));
  }
}

class _AtomMessage extends PositionComponent {
  final String text;
  final Color color;
  _AtomMessage({required this.text, required this.color, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center, priority: 330);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextBoxComponent(text: text, position: size / 2, size: Vector2(size.x - 22, size.y - 8), anchor: Anchor.center, align: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800, height: 1.15))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(16));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF0B1233));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.75)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }
}

class _SmallAtomButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _SmallAtomButton({required this.text, required this.color, required Vector2 position, required double width, required this.onPressed})
      : super(position: position, size: Vector2(width, 36), anchor: Anchor.center, priority: 320);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(TextComponent(text: text, position: size / 2, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800))));
  }

  @override
  void render(Canvas canvas) {
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(shape, Paint()..color = const Color(0xFF0B1233));
    canvas.drawRRect(shape, Paint()..color = color.withOpacity(0.70)..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}