import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Universidad')),
      body: const Center(child: Text('Detalle de la universidad seleccionada')),
    );
  }
}
