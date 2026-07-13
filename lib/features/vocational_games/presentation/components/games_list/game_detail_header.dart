import 'package:flutter/material.dart';

class GameDetailHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final int secondsLeft;

  const GameDetailHeader({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.secondsLeft,
  });

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    final progress = total == 0
        ? 0.0
        : ((currentIndex + 1) / total)
        .clamp(0.0, 1.0)
        .toDouble();

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Reto ${currentIndex + 1} de $total',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '00:${secondsLeft.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            color: primaryColor,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}