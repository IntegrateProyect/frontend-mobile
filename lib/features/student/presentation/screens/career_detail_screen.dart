import 'package:flutter/material.dart';

class CareerDetailScreen extends StatelessWidget {
  const CareerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Carrera')),
      body: const Center(child: Text('Detalle de la carrera seleccionada')),
    );
  }
}
