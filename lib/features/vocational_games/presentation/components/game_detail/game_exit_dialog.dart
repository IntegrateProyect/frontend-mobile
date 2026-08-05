import 'package:flutter/material.dart';

class GameExitDialog extends StatelessWidget {
  const GameExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Salir del juego?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Tu progreso actual se guardará y podrás continuar después.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Continuar jugando'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('Salir ahora'),
        ),
      ],
    );
  }
}
