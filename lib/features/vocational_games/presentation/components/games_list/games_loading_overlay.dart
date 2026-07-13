import 'package:flutter/material.dart';

class GamesLoadingOverlay extends StatelessWidget {
  final bool visible;

  const GamesLoadingOverlay({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return const Positioned.fill(
      child: ColoredBox(
        color: Colors.black26,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}