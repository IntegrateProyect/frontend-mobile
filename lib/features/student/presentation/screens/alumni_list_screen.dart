import 'package:flutter/material.dart';

class AlumniListScreen extends StatelessWidget {
  const AlumniListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Casos de Éxito')),
      body: const Center(child: Text('Listado de egresados (Alumni)')),
    );
  }
}
