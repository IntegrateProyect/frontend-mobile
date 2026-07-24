import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';

class EclipseSequenceConfig {
  final String backgroundAsset;
  final List<String> cardAssets;
  final List<Vector2> slotFractions;
  final List<Vector2> cardFractions;
  final List<Vector2> cardSizeFractions;
  final List<String> hintMessages;
  final double placedScale;
  final double dropDistance;

  EclipseSequenceConfig({
    required this.backgroundAsset,
    required this.cardAssets,
    required this.slotFractions,
    required this.cardFractions,
    required this.cardSizeFractions,
    required this.hintMessages,
    required this.placedScale,
    required this.dropDistance,
  });

  static final EclipseSequenceConfig defaultConfig =
  EclipseSequenceConfig(
    backgroundAsset: 'faseeclipse.png',
    cardAssets: const [
      'Sol.png',
      'Eclipseparcial.png',
      'Eclipsetotal.png',
    ],
    slotFractions: [
      Vector2(0.185, 0.545),
      Vector2(0.500, 0.545),
      Vector2(0.810, 0.545),
    ],
    cardFractions: [
      Vector2(0.180, 0.742),
      Vector2(0.500, 0.742),
      Vector2(0.815, 0.742),
    ],
    cardSizeFractions: [
      Vector2(0.285, 0.168),
      Vector2(0.285, 0.168),
      Vector2(0.285, 0.168),
    ],
    hintMessages: const [
      '☀️ Primero coloca el Sol en el primer espacio',
      '🌘 Después coloca el eclipse parcial en el segundo espacio',
      '🌑 Finalmente coloca el eclipse total en el último espacio',
    ],
    placedScale: 0.64,
    dropDistance: 170,
  );
}

class EclipseSequenceChallengeComponent extends PositionComponent {
  static const List<String> _factMessages = [
    '☀️ ¿Sabías que? El Sol nunca debe observarse directamente sin protección solar certificada.',
    '🌘 ¿Sabías que? En un eclipse parcial, la Luna cubre solamente una parte del disco solar.',
    '🌑 ¿Sabías que? Durante un eclipse total puede observarse la corona, la atmósfera exterior del Sol.',
  ];

  final EclipseSequenceConfig config;
  final void Function(int level, Map<String, dynamic> meta) onFinish;

  final List<_DraggableEclipseCard> _cards = [];
  final List<Vector2> _slotPositions = [];
  PositionComponent? _hintBanner;

  int _placedCards = 0;
  int _attempts = 0;
  bool _touchedAny = false;
  bool _locked = false;
  bool _completionShown = false;

  final DateTime _startedAt = DateTime.now();

  EclipseSequenceChallengeComponent({
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
    _validateConfiguration();
    await _addBackground();
    _addInstruction();
    _calculateSlotPositions();
    await _addCards();
    _addButtons();
  }

  void _validateConfiguration() {
    final total = config.cardAssets.length;
    if (total == 0 ||
        config.slotFractions.length != total ||
        config.cardFractions.length != total ||
        config.cardSizeFractions.length != total ||
        config.hintMessages.length != total) {
      throw ArgumentError(
        'Cada tarjeta necesita una posición, un tamaño, un destino y una pista.',
      );
    }
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
          paint: Paint()..color = const Color(0xFF010B26),
        ),
      );
    }
  }

  void _addInstruction() {
    add(
      TextBoxComponent(
        text: 'Arrastra las fases a la tira fotográfica en este orden: Sol, eclipse parcial y eclipse total.',
        position: Vector2(size.x / 2, size.y * 0.045),
        size: Vector2(size.x - 54, 58),
        anchor: Anchor.topCenter,
        align: Anchor.topCenter,
        priority: 150,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFE9E1FF),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  void _calculateSlotPositions() {
    _slotPositions.clear();
    for (final fraction in config.slotFractions) {
      _slotPositions.add(
        Vector2(size.x * fraction.x, size.y * fraction.y),
      );
    }
  }

  Future<void> _addCards() async {
    for (var index = 0; index < config.cardAssets.length; index++) {
      final positionFraction = config.cardFractions[index];
      final sizeFraction = config.cardSizeFractions[index];
      final card = _DraggableEclipseCard(
        assetName: config.cardAssets[index],
        cardIndex: index,
        position: Vector2(
          size.x * positionFraction.x,
          size.y * positionFraction.y,
        ),
        size: Vector2(
          size.x * sizeFraction.x,
          size.y * sizeFraction.y,
        ),
        placedScale: config.placedScale,
        dropDistance: config.dropDistance,
        targetPositionProvider: () => _slotPosition(index),
        onTouched: () => _touchedAny = true,
        onAttempt: () => _attempts++,
        onDropped: _onCardDropped,
      );
      _cards.add(card);
      add(card);
    }
  }

  Vector2 _slotPosition(int index) {
    final safeIndex = index.clamp(0, _slotPositions.length - 1).toInt();
    return _slotPositions[safeIndex].clone();
  }

  void _addButtons() {
    add(
      _EclipseButton(
        text: '💡 Pista',
        color: const Color(0xFFB388FF),
        position: Vector2(size.x / 2 - 62, size.y - 40),
        width: 108,
        onPressed: _showHint,
      ),
    );
    add(
      _EclipseButton(
        text: 'Saltar',
        color: const Color(0xFF90A4AE),
        position: Vector2(size.x / 2 + 62, size.y - 40),
        width: 108,
        onPressed: () => _finish(reason: 'skipped'),
      ),
    );
  }

  void _showHint() {
    if (_locked) return;
    _hintBanner?.removeFromParent();
    _hintBanner = null;

    _DraggableEclipseCard? nextCard;
    for (final card in _cards) {
      if (!card.isPlaced) {
        nextCard = card;
        break;
      }
    }
    if (nextCard == null) return;

    final banner = _EclipseHintBanner(
      text: config.hintMessages[nextCard.cardIndex],
      position: Vector2(size.x / 2, size.y * 0.185),
      size: Vector2(size.x - 72, 62),
    );
    _hintBanner = banner;
    add(banner);
    nextCard.showHint();
  }

  void _onCardDropped(_DraggableEclipseCard card) {
    if (_locked || card.wasCounted) return;
    card.markAsCounted();
    _placedCards++;
    add(
      BurstParticles(
        position: _slotPosition(card.cardIndex),
        color: _colorForCard(card.cardIndex),
      ),
    );

    _showFact(card.cardIndex);

    if (_placedCards >= config.cardAssets.length) {
      for (final eclipseCard in _cards) {
        eclipseCard.lock();
      }
      add(
        TimerComponent(
          period: 3.2,
          removeOnFinish: true,
          onTick: _showCompletionModal,
        ),
      );
    }
  }

  void _showFact(int cardIndex) {
    _hintBanner?.removeFromParent();
    _hintBanner = null;

    final safeIndex = cardIndex.clamp(0, _factMessages.length - 1).toInt();
    final banner = _EclipseHintBanner(
      text: _factMessages[safeIndex],
      position: Vector2(size.x / 2, size.y * 0.185),
      size: Vector2(size.x - 62, 70),
      color: _colorForCard(safeIndex),
      duration: 3,
    );
    _hintBanner = banner;
    add(banner);
  }

  void _showCompletionModal() {
    if (_locked || _completionShown) return;
    _completionShown = true;
    _hintBanner?.removeFromParent();
    _hintBanner = null;

    add(
      _EclipseCompletionModal(
        imageAsset: 'adolescente_eclipse.png',
        position: Vector2.zero(),
        size: size.clone(),
        onContinue: () => _finish(reason: 'completed'),
      ),
    );
  }

  Color _colorForCard(int index) {
    if (index == 0) return const Color(0xFFFFC247);
    if (index == 1) return const Color(0xFFB388FF);
    return const Color(0xFF42A5F5);
  }

  int _currentLevel() {
    final total = config.cardAssets.length;
    if (_placedCards >= total) return 4;
    if (_placedCards >= total - 1) return 3;
    if (_placedCards > 0) return 2;
    if (_touchedAny) return 1;
    return 0;
  }

  void _finish({required String reason}) {
    if (_locked) return;
    _locked = true;
    _hintBanner?.removeFromParent();
    _hintBanner = null;
    for (final card in _cards) {
      card.lock();
    }
    final elapsed = DateTime.now().difference(_startedAt).inSeconds;
    onFinish(
      _currentLevel(),
      <String, dynamic>{
        'activityKind': 'astronomy',
        'challengeType': 'eclipseSequence',
        'cardsPlaced': _placedCards,
        'cardsTotal': config.cardAssets.length,
        'attempts': _attempts,
        'touchedAny': _touchedAny,
        'completionTimeSeconds': elapsed,
        'endReason': reason,
      },
    );
  }
}

class _DraggableEclipseCard extends SpriteComponent with DragCallbacks {
  final String assetName;
  final int cardIndex;
  final double placedScale;
  final double dropDistance;
  final Vector2 Function() targetPositionProvider;
  final VoidCallback onTouched;
  final VoidCallback onAttempt;
  final void Function(_DraggableEclipseCard card) onDropped;

  late final Vector2 originalPosition;
  bool _isDragging = false;
  bool _isPlaced = false;
  bool _locked = false;
  bool _wasCounted = false;

  _DraggableEclipseCard({
    required this.assetName,
    required this.cardIndex,
    required this.placedScale,
    required this.dropDistance,
    required Vector2 position,
    required Vector2 size,
    required this.targetPositionProvider,
    required this.onTouched,
    required this.onAttempt,
    required this.onDropped,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 20,
  ) {
    originalPosition = position.clone();
  }

  bool get isPlaced => _isPlaced;
  bool get wasCounted => _wasCounted;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(assetName);
  }

  void markAsCounted() => _wasCounted = true;

  void lock() {
    _locked = true;
    _isDragging = false;
    if (!_isPlaced) scale = Vector2.all(1);
  }

  void showHint() {
    if (_locked || _isPlaced || _isDragging) return;
    add(
      ScaleEffect.to(
        Vector2.all(1.08),
        EffectController(
          duration: 0.22,
          reverseDuration: 0.22,
          alternate: true,
          repeatCount: 3,
        ),
        onComplete: () {
          if (!_isPlaced && !_isDragging) scale = Vector2.all(1);
        },
      ),
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_locked || _isPlaced) return;
    _isDragging = true;
    priority = 100;
    scale = Vector2.all(1);
    onTouched();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_isDragging || _locked || _isPlaced) return;
    position.add(event.localDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging || _locked || _isPlaced) return;
    _isDragging = false;
    onAttempt();
    final target = targetPositionProvider();
    if (position.distanceTo(target) <= dropDistance) {
      _isPlaced = true;
      position.setFrom(target);
      scale = Vector2.all(placedScale);
      priority = 30;
      onDropped(this);
    } else {
      _returnToStart();
    }
  }

  void _returnToStart() {
    position.setFrom(originalPosition);
    scale = Vector2.all(1);
    priority = 20;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_locked || _isPlaced) return;
    _isDragging = false;
    _returnToStart();
  }
}

class _EclipseHintBanner extends PositionComponent {
  final String text;
  final Color color;
  final double duration;

  _EclipseHintBanner({
    required this.text,
    required Vector2 position,
    required Vector2 size,
    this.color = const Color(0xFFB388FF),
    this.duration = 4,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 300,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      TextBoxComponent(
        text: text,
        position: size / 2,
        size: Vector2(size.x - 28, size.y - 12),
        anchor: Anchor.center,
        align: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFF1E9FF),
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
    );
    add(
      TimerComponent(
        period: duration,
        removeOnFinish: true,
        onTick: removeFromParent,
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
      Paint()..color = const Color(0xFF16163B).withOpacity(0.96),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}

class _EclipseCompletionModal extends PositionComponent with TapCallbacks {
  final String imageAsset;
  final VoidCallback onContinue;

  _EclipseCompletionModal({
    required this.imageAsset,
    required Vector2 position,
    required Vector2 size,
    required this.onContinue,
  }) : super(
    position: position,
    size: size,
    priority: 1000,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final modalSize = Vector2(size.x - 52, 330);
    final modalTopLeft = Vector2(
      (size.x - modalSize.x) / 2,
      (size.y - modalSize.y) / 2,
    );

    add(
      _EclipseCompletionBackground(
        position: modalTopLeft,
        size: modalSize,
      ),
    );

    try {
      final character = await Sprite.load(imageAsset);
      add(
        SpriteComponent(
          sprite: character,
          position: modalTopLeft + Vector2(91, 170),
          size: Vector2(135, 275),
          anchor: Anchor.center,
          priority: 2,
        ),
      );
    } catch (error) {
      debugPrint('No se pudo cargar $imageAsset: $error');
    }

    add(
      TextBoxComponent(
        text: '¡Felicidades!',
        position: modalTopLeft + Vector2(145, 60),
        size: Vector2(modalSize.x - 165, 52),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFB388FF),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        priority: 3,
      ),
    );

    add(
      TextBoxComponent(
        text:
        'Aprendiste a reconocer las fases de un eclipse y colocarlas en su secuencia.',
        position: modalTopLeft + Vector2(145, 112),
        size: Vector2(modalSize.x - 165, 95),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFF4F0FF),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        priority: 3,
      ),
    );

    add(
      _EclipseContinueButton(
        position: Vector2(
          modalTopLeft.x + modalSize.x - 112,
          modalTopLeft.y + modalSize.y - 52,
        ),
        onPressed: onContinue,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF01071B).withOpacity(0.84),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }
}

class _EclipseCompletionBackground extends PositionComponent {
  _EclipseCompletionBackground({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, priority: 1);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(28),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF17163B),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFFB388FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
  }
}

class _EclipseContinueButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;

  _EclipseContinueButton({
    required Vector2 position,
    required this.onPressed,
  }) : super(
    position: position,
    size: Vector2(170, 52),
    anchor: Anchor.center,
    priority: 5,
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
            color: Color(0xFF100B25),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.y / 2),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFFB388FF),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}

class _EclipseButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  _EclipseButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
    double width = 100,
  }) : super(
    position: position,
    size: Vector2(width, 36),
    anchor: Anchor.center,
    priority: 250,
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
            color: color.withOpacity(0.98),
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
      Paint()..color = const Color(0xFF101731).withOpacity(0.90),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withOpacity(0.65)
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