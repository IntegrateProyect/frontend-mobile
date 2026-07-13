import 'package:flutter/material.dart';

class GameDragToken extends StatelessWidget {
  const GameDragToken({super.key});

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: 1,
      feedback: const Material(
        color: Colors.transparent,
        child: _Token(
          size: 70,
          dragging: true,
        ),
      ),
      childWhenDragging: const Opacity(
        opacity: 0.25,
        child: _Token(size: 64),
      ),
      child: const _Token(size: 64),
    );
  }
}

class _Token extends StatelessWidget {
  final double size;
  final bool dragging;

  const _Token({
    required this.size,
    this.dragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: dragging ? 1.12 : 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: GameDragToken.primaryColor,
          boxShadow: [
            BoxShadow(
              color: GameDragToken.primaryColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.touch_app,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }
}