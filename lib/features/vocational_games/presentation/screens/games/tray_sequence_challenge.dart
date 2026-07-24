import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_fx.dart';

class TraySequenceConfig {
  final String backgroundAsset;
  final String instruction;
  final List<String> itemAssets;
  final List<Vector2> slotFractions;
  final List<Vector2> itemFractions;
  final List<Vector2> itemSizeFractions;
  final List<String> hintMessages;
  final List<String> factMessages;
  final double dropDistance;
  final double placedScale;

  TraySequenceConfig({
    required this.backgroundAsset,
    required this.instruction,
    required this.itemAssets,
    required this.slotFractions,
    required this.itemFractions,
    required this.itemSizeFractions,
    required this.hintMessages,
    required this.factMessages,
    required this.dropDistance,
    required this.placedScale,
  });

  static final TraySequenceConfig analisisSangre =
  TraySequenceConfig(
    backgroundAsset: 'analisissangre.png',
    instruction:
    'Arrastra los elementos a la bandeja en el orden correcto: '
        'primero protégete, después prepara la muestra y al final analízala.',

    itemAssets: const [
      'guantes.png',
      'tubo_sangre.png',
      'microscopio.png',
    ],

    // Centros de los espacios de la charola.
    slotFractions: [
      Vector2(0.22, 0.395),
      Vector2(0.50, 0.395),
      Vector2(0.78, 0.395),
    ],

    // Posiciones iniciales de las tarjetas.
    itemFractions: [
      Vector2(0.190, 0.704),
      Vector2(0.500, 0.704),
      Vector2(0.815, 0.704),
    ],

    // Tamaño de las tarjetas inferiores.
    itemSizeFractions: [
      Vector2(0.290, 0.174),
      Vector2(0.290, 0.174),
      Vector2(0.290, 0.174),
    ],

    // Pista correspondiente a cada tarjeta.
    hintMessages: const [
      'Busca el elemento que protege al paciente, al alumno y a la muestra.',
      'Ahora identifica dónde se conserva la sangre para poder estudiarla.',
      'El último paso requiere observar detalles que no se ven a simple vista.',
    ],

    factMessages: const [
      '🧤 ¿Sabías que? Los guantes se colocan primero porque reducen el '
          'contacto con la sangre y evitan contaminar la muestra.',
      '🧪 ¿Sabías que? El tubo mantiene la muestra protegida y debe '
          'identificarse para evitar confundirla con la de otra persona.',
      '🔬 ¿Sabías que? El microscopio se utiliza al final, cuando la muestra '
          'ya fue obtenida y preparada para observar sus células.',
    ],

    dropDistance: 160,
    placedScale: 0.72,
  );
}

class TraySequenceChallengeComponent
    extends PositionComponent {
  final TraySequenceConfig config;

  final void Function(
      int level,
      Map<String, dynamic> meta,
      ) onFinish;

  final List<_DraggableMedicalCard> _cards = [];
  final List<Vector2> _slotPositions = [];

  PositionComponent? _hintMessage;
  PositionComponent? _instructionMessage;

  int _filledCount = 0;
  bool _touchedAny = false;
  bool _locked = false;
  bool _completionShown = false;

  final DateTime _startedAt = DateTime.now();

  TraySequenceChallengeComponent({
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
    await _addDraggableCards();
    _addButtons();
  }

  void _validateConfiguration() {
    final total = config.itemAssets.length;

    if (total == 0) {
      throw ArgumentError(
        'Debe existir por lo menos una tarjeta.',
      );
    }

    if (config.itemFractions.length != total) {
      throw ArgumentError(
        'itemAssets e itemFractions deben tener la misma cantidad.',
      );
    }

    if (config.itemSizeFractions.length != total) {
      throw ArgumentError(
        'itemAssets e itemSizeFractions deben tener la misma cantidad.',
      );
    }

    if (config.slotFractions.length != total) {
      throw ArgumentError(
        'Debe existir un espacio por cada tarjeta.',
      );
    }

    if (config.hintMessages.length != total) {
      throw ArgumentError(
        'Debe existir una pista por cada tarjeta.',
      );
    }

    if (config.factMessages.length != total) {
      throw ArgumentError(
        'Debe existir un dato educativo por cada tarjeta.',
      );
    }
  }

  void _addInstruction() {
    _instructionMessage = TextBoxComponent(
      text: config.instruction,
      position: Vector2(size.x / 2, size.y * 0.105),
      size: Vector2(size.x - 64, 68),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      priority: 150,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFEAF7FF),
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          height: 1.22,
        ),
      ),
    );
    add(_instructionMessage!);
  }

  Future<void> _addBackground() async {
    try {
      final backgroundSprite = await Sprite.load(
        config.backgroundAsset,
      );

      add(
        SpriteComponent(
          sprite: backgroundSprite,
          position: Vector2.zero(),
          size: size.clone(),
          priority: -100,
        ),
      );
    } catch (error) {
      debugPrint(
        'No se pudo cargar ${config.backgroundAsset}: $error',
      );

      add(
        RectangleComponent(
          position: Vector2.zero(),
          size: size.clone(),
          priority: -100,
          paint: Paint()
            ..color = const Color(0xFF021229),
        ),
      );
    }
  }

  void _calculateSlotPositions() {
    _slotPositions.clear();

    for (final fraction in config.slotFractions) {
      _slotPositions.add(
        Vector2(
          size.x * fraction.x,
          size.y * fraction.y,
        ),
      );
    }
  }

  Future<void> _addDraggableCards() async {
    for (var index = 0;
    index < config.itemAssets.length;
    index++) {
      final positionFraction =
      config.itemFractions[index];

      final sizeFraction =
      config.itemSizeFractions[index];

      final cardPosition = Vector2(
        size.x * positionFraction.x,
        size.y * positionFraction.y,
      );

      final cardSize = Vector2(
        size.x * sizeFraction.x,
        size.y * sizeFraction.y,
      );

      final card = _DraggableMedicalCard(
        assetName: config.itemAssets[index],
        cardIndex: index,
        position: cardPosition,
        size: cardSize,
        placedScale: config.placedScale,
        dropDistance: config.dropDistance,
        targetPositionProvider: () {
          return _slotPositionForCard(index);
        },
        canPlaceProvider: () => index == _filledCount,
        onWrongOrder: () => _showWrongOrderMessage(index),
        onTouched: () {
          _touchedAny = true;
        },
        onDropped: _onCardDropped,
      );

      _cards.add(card);
      add(card);
    }
  }

  Vector2 _slotPositionForCard(int cardIndex) {
    if (_slotPositions.isEmpty) {
      return Vector2.zero();
    }

    final safeIndex = cardIndex
        .clamp(
      0,
      _slotPositions.length - 1,
    )
        .toInt();

    return _slotPositions[safeIndex].clone();
  }

  void _addButtons() {
    add(
      _GhostButton(
        text: '💡 Pista',
        color: const Color(0xFFFF4D6D),
        position: Vector2(
          size.x / 2 - 62,
          size.y - 40,
        ),
        width: 108,
        onPressed: _showHint,
      ),
    );

    add(
      _GhostButton(
        text: 'Saltar',
        color: const Color(0xFF90A4AE),
        position: Vector2(
          size.x / 2 + 62,
          size.y - 40,
        ),
        width: 108,
        onPressed: () {
          _finish(reason: 'skipped');
        },
      ),
    );
  }

  void _showHint() {
    if (_locked) return;

    _hintMessage?.removeFromParent();
    _hintMessage = null;

    _DraggableMedicalCard? nextCard;

    for (final card in _cards) {
      if (!card.isPlaced) {
        nextCard = card;
        break;
      }
    }

    if (nextCard == null) {
      return;
    }

    final hintIndex = nextCard.cardIndex
        .clamp(
      0,
      config.hintMessages.length - 1,
    )
        .toInt();

    _showInformation(
      config.hintMessages[hintIndex],
      color: const Color(0xFFFF4D6D),
      duration: 4,
    );

    nextCard.showHint();
  }

  void _showWrongOrderMessage(int attemptedIndex) {
    if (_locked) return;

    final message = attemptedIndex == 1
        ? 'Antes de manipular la muestra debes proteger tus manos y evitar '
        'contaminar la sangre.'
        : 'El análisis con el microscopio se realiza después de protegerse '
        'y preparar correctamente la muestra.';

    _showInformation(
      '💡 $message',
      color: const Color(0xFFFFB74D),
      duration: 3.8,
    );
  }

  void _showInformation(
      String text, {
        required Color color,
        double duration = 4.5,
      }) {
    _hintMessage?.removeFromParent();
    _hideInstruction();

    final banner = _HintBanner(
      text: text,
      color: color,
      duration: duration,
      // Reemplaza temporalmente a la instrucción; no se dibuja encima.
      position: Vector2(size.x / 2, size.y * 0.135),
      size: Vector2(size.x - 62, 82),
      onDismiss: _restoreInstruction,
    );

    _hintMessage = banner;
    add(banner);
  }

  void _hideInstruction() {
    final instruction = _instructionMessage;
    if (instruction is TextBoxComponent) {
      instruction.text = '';
    }
  }

  void _restoreInstruction() {
    if (_locked) return;
    final instruction = _instructionMessage;
    if (instruction is TextBoxComponent) {
      instruction.text = config.instruction;
    }
    _hintMessage = null;
  }

  void _onCardDropped(
      _DraggableMedicalCard card,
      ) {
    if (_locked || card.wasCounted) {
      return;
    }

    card.markAsCounted();

    _touchedAny = true;
    _filledCount++;

    final targetPosition =
    _slotPositionForCard(card.cardIndex);

    add(
      BurstParticles(
        position: targetPosition,
        color: const Color(0xFF35D69A),
      ),
    );

    _showInformation(
      config.factMessages[card.cardIndex],
      color: const Color(0xFF35D69A),
      duration: 4.5,
    );

    if (_filledCount >= _slotPositions.length) {
      // Muestra la felicitación casi inmediatamente al completar la actividad.
      add(
        TimerComponent(
          period: 0.35,
          removeOnFinish: true,
          onTick: _showCompletionModal,
        ),
      );
    }
  }

  void _showCompletionModal() {
    if (_locked || _completionShown) return;
    _completionShown = true;

    _hintMessage?.removeFromParent();
    _hintMessage = null;
    _hideInstruction();

    for (final card in _cards) {
      card.lock();
    }

    add(
      _ActivityCompletionModal(
        imageAsset: 'adolescente_laboratorio.png',
        position: Vector2.zero(),
        size: size.clone(),
        onContinue: () => _finish(reason: 'completed'),
      ),
    );
  }

  int _currentLevel() {
    final total = _slotPositions.length;

    if (total == 0) return 0;
    if (_filledCount >= total) return 4;
    if (_filledCount >= total - 1) return 3;
    if (_filledCount > 0) return 2;
    if (_touchedAny) return 1;

    return 0;
  }

  void _finish({
    required String reason,
  }) {
    if (_locked) return;

    _locked = true;

    _hintMessage?.removeFromParent();
    _hintMessage = null;

    for (final card in _cards) {
      card.lock();
    }

    final elapsed = DateTime.now()
        .difference(_startedAt)
        .inSeconds;

    onFinish(
      _currentLevel(),
      <String, dynamic>{
        'activityKind': 'medical',
        'slotsFilled': _filledCount,
        'slotsTotal': _slotPositions.length,
        'touchedAny': _touchedAny,
        'completionTimeSeconds': elapsed,
        'endReason': reason,
      },
    );
  }
}

class _DraggableMedicalCard
    extends SpriteComponent
    with DragCallbacks, IdleBreathing {
  final String assetName;
  final int cardIndex;
  final double placedScale;
  final double dropDistance;

  final Vector2 Function() targetPositionProvider;
  final bool Function() canPlaceProvider;
  final VoidCallback onTouched;
  final VoidCallback onWrongOrder;

  final void Function(
      _DraggableMedicalCard card,
      ) onDropped;

  late final Vector2 originalPosition;

  bool _isDragging = false;
  bool _isPlaced = false;
  bool _locked = false;
  bool _wasCounted = false;

  _DraggableMedicalCard({
    required this.assetName,
    required this.cardIndex,
    required this.placedScale,
    required this.dropDistance,
    required Vector2 position,
    required Vector2 size,
    required this.targetPositionProvider,
    required this.canPlaceProvider,
    required this.onTouched,
    required this.onWrongOrder,
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

    try {
      sprite = await Sprite.load(assetName);
    } catch (error) {
      debugPrint(
        'No se pudo cargar $assetName: $error',
      );

      add(
        TextComponent(
          text: _fallbackEmoji(),
          position: size / 2,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 48,
            ),
          ),
        ),
      );
    }
  }

  String _fallbackEmoji() {
    switch (cardIndex) {
      case 0:
        return '🧤';

      case 1:
        return '🧪';

      case 2:
        return '🔬';

      default:
        return '🧰';
    }
  }

  @override
  bool get isIdleAnimated {
    return !_isDragging &&
        !_isPlaced &&
        !_locked;
  }

  void markAsCounted() {
    _wasCounted = true;
  }

  void lock() {
    _locked = true;
    _isDragging = false;

    if (!_isPlaced) {
      scale = Vector2.all(1);
    }
  }

  void showHint() {
    if (_locked || _isPlaced || _isDragging) {
      return;
    }

    add(
      ScaleEffect.to(
        Vector2.all(1.06),
        EffectController(
          duration: 0.22,
          reverseDuration: 0.22,
          alternate: true,
          repeatCount: 3,
        ),
        onComplete: () {
          if (!_isPlaced && !_isDragging) {
            scale = Vector2.all(1);
          }
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateBreathing(dt);
  }

  @override
  void onDragStart(
      DragStartEvent event,
      ) {
    super.onDragStart(event);

    if (_locked || _isPlaced) {
      return;
    }

    _isDragging = true;
    onTouched();

    priority = 100;
    scale = Vector2.all(1);
  }

  @override
  void onDragUpdate(
      DragUpdateEvent event,
      ) {
    super.onDragUpdate(event);

    if (!_isDragging ||
        _locked ||
        _isPlaced) {
      return;
    }

    position.add(event.localDelta);
  }

  @override
  void onDragEnd(
      DragEndEvent event,
      ) {
    super.onDragEnd(event);

    if (!_isDragging ||
        _locked ||
        _isPlaced) {
      return;
    }

    _isDragging = false;

    final targetPosition =
    targetPositionProvider();

    final distance =
    position.distanceTo(targetPosition);

    if (distance <= dropDistance) {
      if (canPlaceProvider()) {
        _placeAtTarget(targetPosition);
      } else {
        _returnToOriginalPosition();
        onWrongOrder();
      }
    } else {
      _returnToOriginalPosition();
    }
  }

  void _placeAtTarget(
      Vector2 targetPosition,
      ) {
    _isPlaced = true;

    position.setFrom(targetPosition);
    scale = Vector2.all(placedScale);
    priority = 30;

    onDropped(this);
  }

  void _returnToOriginalPosition() {
    position.setFrom(originalPosition);
    scale = Vector2.all(1);
    priority = 20;
  }

  @override
  void onDragCancel(
      DragCancelEvent event,
      ) {
    super.onDragCancel(event);

    if (_locked || _isPlaced) {
      return;
    }

    _isDragging = false;
    _returnToOriginalPosition();
  }
}

class _HintBanner extends PositionComponent {
  final String text;
  final Color color;
  final double duration;
  final VoidCallback? onDismiss;
  bool _dismissed = false;

  _HintBanner({
    required this.text,
    this.color = const Color(0xFFFF4D6D),
    this.duration = 4,
    this.onDismiss,
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    anchor: Anchor.center,
    priority: 300,
  );

  @override
  void onRemove() {
    if (!_dismissed) {
      _dismissed = true;
      onDismiss?.call();
    }
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextBoxComponent(
        text: text,
        position: size / 2,
        size: Vector2(
          size.x - 28,
          size.y - 12,
        ),
        anchor: Anchor.center,
        align: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFE1E8),
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

    final rectangle = Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    final roundedRectangle =
    RRect.fromRectAndRadius(
      rectangle,
      const Radius.circular(18),
    );

    canvas.drawRRect(
      roundedRectangle,
      Paint()
        ..color = const Color(0xFF102840)
            .withOpacity(0.96),
    );

    canvas.drawRRect(
      roundedRectangle,
      Paint()
        ..color = color.withOpacity(0.82)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}

class _GhostButton extends PositionComponent
    with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  _GhostButton({
    required this.text,
    required this.color,
    required Vector2 position,
    required this.onPressed,
    double width = 100,
  }) : super(
    position: position,
    size: Vector2(width, 36),
    anchor: Anchor.center,
    priority: 200,
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
            color: color.withOpacity(0.95),
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rectangle = Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    final roundedRectangle =
    RRect.fromRectAndRadius(
      rectangle,
      Radius.circular(size.y / 2),
    );

    canvas.drawRRect(
      roundedRectangle,
      Paint()
        ..color = const Color(0xFF0F2033)
            .withOpacity(0.78),
    );

    canvas.drawRRect(
      roundedRectangle,
      Paint()
        ..color = color.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void onTapDown(
      TapDownEvent event,
      ) {
    super.onTapDown(event);
    onPressed();
  }
}

class _ActivityCompletionModal extends PositionComponent with TapCallbacks {
  final String imageAsset;
  final VoidCallback onContinue;

  _ActivityCompletionModal({
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
      _CompletionCardBackground(
        position: modalTopLeft,
        size: modalSize,
      ),
    );

    try {
      final character = await Sprite.load(imageAsset);
      add(
        SpriteComponent(
          sprite: character,
          position: modalTopLeft + Vector2(90, 160),
          size: Vector2(125, 245),
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
        position: Vector2(
          modalTopLeft.x + 140,
          modalTopLeft.y + 62,
        ),
        size: Vector2(modalSize.x - 165, 58),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF45E6B0),
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        priority: 3,
      ),
    );

    add(
      TextBoxComponent(
        text:
        'Aprendiste a seguir el orden básico de un análisis de sangre: protegerte, preparar la muestra y observarla con seguridad.',
        position: Vector2(
          modalTopLeft.x + 140,
          modalTopLeft.y + 112,
        ),
        size: Vector2(modalSize.x - 160, 105),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFF4F8FC),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        priority: 3,
      ),
    );

    add(
      _ModalContinueButton(
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
      Paint()..color = const Color(0xFF010B1D).withOpacity(0.82),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Consume los toques para impedir que lleguen a Pista o Saltar.
    super.onTapDown(event);
  }
}

class _CompletionCardBackground extends PositionComponent {
  _CompletionCardBackground({
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
      Paint()..color = const Color(0xFF102840),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF45E6B0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
  }
}

class _ModalContinueButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;

  _ModalContinueButton({
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
            color: Color(0xFF02182B),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(26),
    );
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF45E6B0),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }
}
