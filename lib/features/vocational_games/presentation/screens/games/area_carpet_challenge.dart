import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';
import 'components/game_completion_overlay.dart';
import 'components/area_carpet_challenge_components.dart';

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

  final List<CarpetTile> _tiles = [];
  TextComponent? _counter;
  AreaProgressPips? _progressPips;
  TextBoxComponent? _result;
  PositionComponent? _message;

  int _covered = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

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
      add(SpriteComponent(sprite: background, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF020C2A)));
    }
  }

  void _addInstruction() {
    add(TextBoxComponent(
      text: 'Toca cada casilla del cuarto para cubrirla con alfombra.',
      position: Vector2(size.x / 2, 16),
      size: Vector2(size.x - 50, 46),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE8F5FF), fontSize: 13.5, fontWeight: FontWeight.bold)),
    ));
  }

  void _addGrid() {
    final origin = Vector2(size.x * 0.1937, size.y * 0.3413);
    final gridSize = Vector2(size.x * 0.6279, size.y * 0.2914);
    final cellSize = Vector2(gridSize.x / config.columns, gridSize.y / config.rows);

    for (var row = 0; row < config.rows; row++) {
      for (var col = 0; col < config.columns; col++) {
        add(CarpetTile(
          position: origin + Vector2(col * cellSize.x, row * cellSize.y),
          size: cellSize,
          onCovered: _onTileCovered,
        ));
      }
    }
  }

  void _addMeasurements() {
    add(MeasurementLabel(text: '${config.rows} m', position: Vector2(size.x * 0.0915, size.y * 0.4870), size: Vector2(size.x * 0.115, 38)));
    add(MeasurementLabel(text: '${config.columns} m', position: Vector2(size.x * 0.4930, size.y * 0.6900), size: Vector2(size.x * 0.170, 38)));
  }

  void _addCounter() {
    _counter = TextComponent(
      text: '0 / $total casillas',
      position: Vector2(size.x / 2, size.y * 0.135),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFFFA726), fontSize: 14, fontWeight: FontWeight.w900)),
    );
    add(_counter!);
  }

  void _addProgressPips() {
    _progressPips = AreaProgressPips(position: Vector2(size.x * 0.3509, size.y * 0.1685), size: Vector2(size.x * 0.2981, size.y * 0.1387), total: total);
    add(_progressPips!);
  }

  void _addResult() {
    _result = TextBoxComponent(
      text: 'Área cubierta: 0 m²',
      position: Vector2(size.x / 2, size.y * 0.804),
      size: Vector2(size.x * 0.70, 48),
      anchor: Anchor.center,
      align: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFFE8F5FF), fontSize: 14, fontWeight: FontWeight.w900)),
    );
    add(_result!);
  }

  void _onTileCovered(CarpetTile tile) {
    if (_locked || tile.covered) return;
    tile.cover();
    _covered++;
    _counter?.text = '$_covered / $total casillas';
    _progressPips?.covered = _covered;
    _result?.text = 'Área cubierta: $_covered m²';

    add(BurstParticles(position: tile.position + tile.size / 2, color: const Color(0xFFFFA726)));

    if (_covered >= total) _showCompletion();
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'carpet_area_girl.png',
      title: '¡Cuarto terminado!',
      message: 'Has cubierto correctamente toda la superficie.\n${config.columns}m x ${config.rows}m = $total m²',
      themeColor: const Color(0xFFFFA726),
      onContinue: () => _finish('completed'),
    ));
  }

  void _addButtons() {
    add(AreaButton(text: 'Saltar', color: const Color(0xFF90A4AE), position: Vector2(size.x / 2, size.y - 38), onPressed: () => _finish('skipped')));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'carpetArea',
      'covered': _covered,
      'total': total,
      'time': DateTime.now().difference(_startedAt).inSeconds,
      'endReason': reason,
    });
  }
}
