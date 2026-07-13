import 'package:flutter/material.dart';

class GamesEmptyState extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Future<void> Function() onRetry;

  const GamesEmptyState({
    super.key,
    required this.isLoading,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 150),
        const Icon(
          Icons.sports_esports_outlined,
          size: 70,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            message ?? 'No hay minijuegos disponibles.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
            onRetry();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF311B92),
            foregroundColor: Colors.white,
          ),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }
}