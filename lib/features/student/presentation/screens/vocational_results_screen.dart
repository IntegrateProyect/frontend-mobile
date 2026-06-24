import 'package:flutter/material.dart';

class VocationalResultsScreen extends StatelessWidget {
  const VocationalResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Resultados')),
      body: const Center(child: Text('Lista de resultados de tests vocacionales')),
    );
  }
}
