import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/game_completion_overlay.dart';
import 'components/atomic_energy_challenge_components.dart';

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
  late final NucleusParticles _nucleus;
  late final OrbitElectrons _electrons;
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

    _nucleus = NucleusParticles(
      position: Vector2(size.x * 0.5, size.y * 0.525),
      size: Vector2.all(size.x * 0.20),
      protons: 0,
      neutrons: 0,
    );
    add(_nucleus);

    _electrons = OrbitElectrons(
      size: size.clone(),
      count: 0,
    );
    add(_electrons);

    _addParticleButton(Vector2(size.x * 0.188, size.y * 0.785), const Color(0xFFFF4E4E), _addProton);
    _addParticleButton(Vector2(size.x * 0.500, size.y * 0.785), const Color(0xFFF2F4F8), _addNeutron);
    _addParticleButton(Vector2(size.x * 0.812, size.y * 0.785), const Color(0xFF16A8FF), _addElectron);

    _addBottomButtons();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF030D2C)));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Construye el átomo agregando las cantidades solicitadas.',
      position: Vector2(size.x / 2, 16),
      size: Vector2(size.x - 48, 62),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE8E4FF), fontSize: 13, fontWeight: FontWeight.bold)),
    ));
  }

  void _addCounters() {
    _protonCounter = _counter(Vector2(size.x * 0.278, size.y * 0.302));
    _neutronCounter = _counter(Vector2(size.x * 0.505, size.y * 0.302));
    _electronCounter = _counter(Vector2(size.x * 0.790, size.y * 0.302));
    addAll([_protonCounter, _neutronCounter, _electronCounter]);
    _updateCounters();
  }

  TextComponent _counter(Vector2 pos) => TextComponent(text: '0/0', position: pos, anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)));

  void _addParticleButton(Vector2 pos, Color color, VoidCallback action) {
    add(AtomButton(
      position: pos,
      size: Vector2.all(size.x * 0.235),
      color: color,
      onPressed: () {
        if (_locked) return;
        _touches++;
        add(TouchRipple(position: pos.clone(), color: color));
        action();
      },
    ));
  }

  void _addProton() { if (_protons < config.targetProtons) { _protons++; _nucleus.protons = _protons; _checkCompletion(); } }
  void _addNeutron() { if (_neutrons < config.targetNeutrons) { _neutrons++; _nucleus.neutrons = _neutrons; _checkCompletion(); } }
  void _addElectron() { if (_electronCount < config.targetElectrons) { _electronCount++; _electrons.count = _electronCount; _checkCompletion(); } }

  void _checkCompletion() {
    _updateCounters();
    if (_protons == config.targetProtons && _neutrons == config.targetNeutrons && _electronCount == config.targetElectrons) {
      _showCompletion();
    }
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'atomic_energy_girl.png',
      title: '¡Estructura Atómica Lograda!',
      message: 'Has construido correctamente el núcleo y las órbitas del átomo.',
      themeColor: const Color(0xFF67E8FF),
      onContinue: () => _finish('completed'),
    ));
  }

  void _updateCounters() {
    _protonCounter.text = '$_protons/${config.targetProtons}';
    _neutronCounter.text = '$_neutrons/${config.targetNeutrons}';
    _electronCounter.text = '$_electronCount/${config.targetElectrons}';
  }

  void _addBottomButtons() {
    add(SmallAtomButton(text: 'Saltar', color: const Color(0xFF90A4AE), position: Vector2(size.x / 2, size.y - 38), width: 108, onPressed: () => _finish('skipped')));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'atomicEnergy',
      'time': DateTime.now().difference(_startedAt).inSeconds,
    });
  }
}
