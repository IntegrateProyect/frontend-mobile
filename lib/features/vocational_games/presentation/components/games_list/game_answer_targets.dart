import 'package:flutter/material.dart';

import '../../../domain/entities/game_question_entity.dart';

class GameAnswerTargets extends StatelessWidget {
  final GameQuestionEntity question;
  final bool disabled;
  final ValueChanged<GameQuestionOptionEntity> onSelected;

  const GameAnswerTargets({
    super.key,
    required this.question,
    required this.disabled,
    required this.onSelected,
  });

  static const Color darkText = Color(0xFF1D1B4B);

  static const List<IconData> _likertIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  static const List<Color> _likertColors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightGreen,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    if (question.options.length == 2) {
      return _buildBinaryTargets();
    }

    return _buildLikertTargets();
  }

  Widget _buildBinaryTargets() {
    return Row(
      children: List.generate(
        question.options.length,
            (index) {
          final option = question.options[index];
          final positive = index == 0;

          return Expanded(
            child: DragTarget<int>(
              onWillAccept: (_) => !disabled,
              onAccept: (_) => onSelected(option),
              builder: (
                  context,
                  candidateData,
                  rejectedData,
                  ) {
                final hovering = candidateData.isNotEmpty;
                final color = positive
                    ? Colors.green
                    : Colors.red;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  height: hovering ? 154 : 140,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 7,
                  ),
                  decoration: BoxDecoration(
                    color: hovering
                        ? color.withOpacity(0.20)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: color,
                      width: hovering ? 4 : 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        positive
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: color,
                        size: hovering ? 62 : 52,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        option.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLikertTargets() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          question.options.length,
              (index) {
            final option = question.options[index];

            final safeIndex = index < _likertIcons.length
                ? index
                : _likertIcons.length - 1;

            final color = _likertColors[safeIndex];
            final icon = _likertIcons[safeIndex];

            return Expanded(
              child: DragTarget<int>(
                onWillAccept: (_) => !disabled,
                onAccept: (_) => onSelected(option),
                builder: (
                    context,
                    candidateData,
                    rejectedData,
                    ) {
                  final hovering =
                      candidateData.isNotEmpty;

                  return AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: hovering
                          ? color.withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius:
                      BorderRadius.circular(18),
                      border: Border.all(
                        color: hovering
                            ? color
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CircleAvatar(
                          radius: hovering ? 29 : 25,
                          backgroundColor:
                          color.withOpacity(0.18),
                          child: Icon(
                            icon,
                            color: color,
                            size: hovering ? 34 : 30,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 31,
                          child: Text(
                            option.text,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}