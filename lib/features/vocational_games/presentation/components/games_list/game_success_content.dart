import 'package:flutter/material.dart';

import 'game_detail_header.dart';
import 'game_scene.dart';

class GameSuccessContent extends StatelessWidget {
  final String questionText;
  final String answer;
  final int currentIndex;
  final int totalQuestions;
  final int secondsLeft;
  final Animation<double> successAnimation;

  const GameSuccessContent({
    super.key,
    required this.questionText,
    required this.answer,
    required this.currentIndex,
    required this.totalQuestions,
    required this.secondsLeft,
    required this.successAnimation,
  });

  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final scene = GameSceneResolver.fromText(
      questionText,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            GameDetailHeader(
              currentIndex: currentIndex,
              total: totalQuestions,
              secondsLeft: secondsLeft,
            ),
            const SizedBox(height: 30),
            const Text(
              '¡Genial!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu elección: $answer',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SuccessGameScene(
                scene: scene,
                animation: successAnimation,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Continuamos...',
              style: TextStyle(
                color: primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}