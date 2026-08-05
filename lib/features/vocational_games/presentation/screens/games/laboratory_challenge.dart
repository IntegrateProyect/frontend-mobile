import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/laboratory_challenge_components.dart';

enum LaboratoryChallengeKind { numeric, astronomy, biology, medical }

class LaboratoryChallengeConfig {
  final LaboratoryChallengeKind kind;
  final String instruction;
  final String apparatusEmoji;
  final String apparatusLabel;
  final List<String> steps;
  final Color color;
  final String? backgroundAsset;
  final Vector2? apparatusFraction;
  final List<Vector2>? stationFractions;

  final bool useNumericSequenceChallenge;
  final bool useTraySequenceChallenge;
  final bool useEclipseSequenceChallenge;
  final bool useArithmeticMachineChallenge;
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

    if (text.contains('energia atomica') || text.contains('atomo')) {
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

    if (text.contains('primeros auxilios')) {
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

    if (text.contains('herbario') || text.contains('coleccion de plantas')) {
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
  static String _normalize(String value) => value.toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
}

class LaboratoryChallengeComponent extends PositionComponent {
  final LaboratoryChallengeConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  HoloTarget? _apparatus;
  ProgressPips? _pips;
  final List<StationNode> _pieces = [];
  int _consumed = 0;
  bool _touchedAny = false;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  LaboratoryChallengeComponent({required this.config, required this.onFinish, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(AmbientIcons(color: config.color, icons: const ['⚕️', '🧪', '🔬'], size: size));
    
    _apparatus = HoloTarget(emoji: config.apparatusEmoji, label: config.apparatusLabel, color: config.color, position: Vector2(size.x / 2, 128));
    add(_apparatus!);

    _pips = ProgressPips(total: config.steps.length, color: config.color, position: Vector2(size.x / 2, 220));
    add(_pips!);

    _layoutGrid();

    add(GhostButton(text: 'Saltar', color: const Color(0xFF90A4AE), position: Vector2(size.x / 2, size.y - 40), onPressed: () => _finish('skipped')));
  }

  void _layoutGrid() {
    for (var i = 0; i < config.steps.length; i++) {
      final piece = StationNode(
        stationNumber: i + 1,
        label: config.steps[i],
        color: config.color,
        position: Vector2(size.x / 2, 300 + (i * 110)),
        targetPositionProvider: () => Vector2(size.x / 2, 128),
        onTouched: () => _touchedAny = true,
        onDropped: (node) => _onPieceDropped(node),
      );
      _pieces.add(piece);
      add(piece);
    }
  }

  void _onPieceDropped(StationNode piece) {
    if (_locked) return;
    _consumed++;
    _pips?.setFilled(_consumed);
    _apparatus?.react();
    _pieces.remove(piece);
    if (_consumed >= config.steps.length) _finish('completed');
  }

  void _finish(String reason) {
    if (_locked) return;
    _locked = true;
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(reason == 'completed' ? 4 : 1, {
      'activityKind': config.kind.name,
      'endReason': reason,
      'time': elapsed,
    });
  }
}
