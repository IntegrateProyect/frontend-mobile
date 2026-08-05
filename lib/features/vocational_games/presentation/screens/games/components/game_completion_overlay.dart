import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameCompletionOverlay extends PositionComponent {
  final String title;
  final String message;
  final String buttonText;
  final String? characterAsset;
  final VoidCallback onContinue;
  final Color themeColor;

  GameCompletionOverlay({
    required Vector2 size,
    required this.onContinue,
    this.title = '¡Felicidades!',
    this.message = '¡Excelente trabajo! Has completado esta actividad con éxito.',
    this.buttonText = 'Continuar',
    this.characterAsset,
    this.themeColor = const Color(0xFF55F0A4),
  }) : super(size: size, position: Vector2.zero(), priority: 1000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final panelSize = Vector2(size.x * 0.85, size.y * 0.5);
    final panel = _CompletionPanel(
      position: size / 2,
      size: panelSize,
      themeColor: themeColor,
    );
    add(panel);

    if (characterAsset != null) {
      try {
        final sprite = await Sprite.load(characterAsset!);
        panel.add(SpriteComponent(
          sprite: sprite,
          position: Vector2(panelSize.x * 0.25, panelSize.y * 0.5),
          size: Vector2(panelSize.x * 0.4, panelSize.y * 0.8),
          anchor: Anchor.center,
        ));
      } catch (e) {
        debugPrint('Error loading character asset: $e');
      }
    }

    panel.add(TextBoxComponent(
      text: title,
      position: Vector2(panelSize.x * 0.65, panelSize.y * 0.2),
      size: Vector2(panelSize.x * 0.6, 50),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: TextStyle(color: themeColor, fontSize: 24, fontWeight: FontWeight.w900)),
    ));

    panel.add(TextBoxComponent(
      text: message,
      position: Vector2(panelSize.x * 0.65, panelSize.y * 0.4),
      size: Vector2(panelSize.x * 0.55, panelSize.y * 0.4),
      anchor: Anchor.topCenter,
      align: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3)),
    ));

    panel.add(_CompletionButton(
      text: buttonText,
      color: themeColor,
      position: Vector2(panelSize.x * 0.65, panelSize.y * 0.8),
      size: Vector2(panelSize.x * 0.5, 45),
      onPressed: onContinue,
    ));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = Colors.black.withOpacity(0.8));
  }
}

class _CompletionPanel extends PositionComponent {
  final Color themeColor;
  _CompletionPanel({required Vector2 position, required Vector2 size, required this.themeColor}) 
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(24));
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF0D1B2A));
    canvas.drawRRect(rect, Paint()..color = themeColor..style = PaintingStyle.stroke..strokeWidth = 2);
  }
}

class _CompletionButton extends PositionComponent with TapCallbacks {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  _CompletionButton({required this.text, required this.color, required Vector2 position, required Vector2 size, required this.onPressed}) 
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.x, size.y), Radius.circular(size.y / 2));
    canvas.drawRRect(rect, Paint()..color = color);
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2));
  }

  @override
  void onTapDown(TapDownEvent event) => onPressed();
}
