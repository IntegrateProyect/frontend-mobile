import 'package:flutter/material.dart';

import '../../../domain/entities/game_question_entity.dart';
import 'game_detail_header.dart';
import 'interactive_question_game.dart';

class GameQuestionContent extends StatelessWidget {
  final GameQuestionEntity question;
  final String miniGameKey;
  final int currentIndex;
  final int totalQuestions;
  final int secondsLeft;
  final bool isSending;
  final InteractiveAnswerCallback onAnswerSelected;

  const GameQuestionContent({
    super.key,
    required this.question,
    required this.miniGameKey,
    required this.currentIndex,
    required this.totalQuestions,
    required this.secondsLeft,
    required this.isSending,
    required this.onAnswerSelected,
  });

  static const Color darkText =
  Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          12,
        ),
        child: Column(
          children: [
            GameDetailHeader(
              currentIndex: currentIndex,
              total: totalQuestions,
              secondsLeft: secondsLeft,
            ),
            const SizedBox(height: 14),
            Text(
              question.text,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: darkText,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: InteractiveQuestionGame(
                question: question,
                miniGameKey: miniGameKey,
                disabled: isSending,
                onSelected: onAnswerSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}