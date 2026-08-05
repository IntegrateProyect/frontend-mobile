import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'components/game_completion_overlay.dart';
import 'components/telescope_focus_challenge_components.dart';

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

  late final FocusedStar _star;
  late final InvisibleFocusDial _dial;
  late final FocusProgress _progress;

  double _focus = 0;
  bool _locked = false;
  final DateTime _startedAt = DateTime.now();

  TelescopeFocusChallengeComponent({required this.config, required this.onFinish, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _focus = config.initialFocus;
    await _addBackground();
    _addStar();
    _addProgress();
    _addDial();
    _addButtons();
  }

  Future<void> _addBackground() async {
    try {
      final sprite = await Sprite.load(config.backgroundAsset);
      add(SpriteComponent(sprite: sprite, size: size.clone(), priority: -100));
    } catch (e) {
      add(RectangleComponent(size: size.clone(), priority: -100, paint: Paint()..color = const Color(0xFF020B24)));
    }
  }

  void _addStar() {
    _star = FocusedStar(position: Vector2(size.x * 0.716, size.y * 0.232), size: Vector2.all(size.x * 0.115), focus: _focus);
    add(_star);
  }

  void _addProgress() {
    _progress = FocusProgress(position: Vector2(size.x * 0.500, size.y * 0.582), size: Vector2(size.x * 0.178, 24), focus: _focus);
    add(_progress);
  }

  void _addDial() {
    _dial = InvisibleFocusDial(
      position: Vector2(size.x * 0.500, size.y * 0.790),
      size: Vector2.all(size.x * 0.400),
      initialFocus: _focus,
      correctStart: config.correctStart,
      correctEnd: config.correctEnd,
      onFocusChanged: (val) {
        _focus = val;
        _star.focus = (val / config.correctEnd).clamp(0.0, 1.0);
        _progress.focus = val;
      },
      onAdjustmentFinished: () {
        if (_focus >= config.correctStart && _focus <= config.correctEnd) _showCompletion();
      },
    );
    add(_dial);
  }

  void _showCompletion() {
    if (_locked) return;
    _locked = true;
    _dial.lock();
    add(GameCompletionOverlay(
      size: size.clone(),
      characterAsset: 'joven_telescopio.png',
      title: '¡Wow, genial!',
      message: 'Lograste enfocar la estrella y aprendiste a ajustar un telescopio.',
      themeColor: const Color(0xFF65F5B5),
      onContinue: () => _finish('completed'),
    ));
  }

  void _addButtons() {
    add(FocusButton(text: 'Saltar', color: const Color(0xFF90A4AE), position: Vector2(size.x / 2, size.y - 35), onPressed: () => _finish('skipped')));
  }

  void _finish(String reason) {
    onFinish(reason == 'completed' ? 4 : 1, {
      'challengeType': 'telescopeFocus',
      'time': DateTime.now().difference(_startedAt).inSeconds,
    });
  }
}
