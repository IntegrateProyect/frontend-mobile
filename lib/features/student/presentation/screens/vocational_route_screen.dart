import 'package:flutter/material.dart';

class VocationalRouteScreen extends StatelessWidget {
  const VocationalRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Ruta Vocacional')),
      body: const Center(child: Text('Visualización del camino vocacional personalizado')),
    );
  }
}
