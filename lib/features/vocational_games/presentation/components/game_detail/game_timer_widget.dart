import 'dart:async';
import 'package:flutter/material.dart';

class GameTimerWidget extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onTimeExpired;
  final ValueChanged<int>? onTick;

  const GameTimerWidget({
    super.key,
    required this.totalSeconds,
    required this.onTimeExpired,
    this.onTick,
  });

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.totalSeconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant GameTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalSeconds != widget.totalSeconds) {
      _timer?.cancel();
      _secondsLeft = widget.totalSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
        widget.onTick?.call(_secondsLeft);
      } else {
        _timer?.cancel();
        widget.onTimeExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsLeft / widget.totalSeconds;
    final color = _secondsLeft <= 10 ? Colors.redAccent : const Color(0xFF311B92);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tiempo restante',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            Text(
              '${_secondsLeft}s',
              style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
