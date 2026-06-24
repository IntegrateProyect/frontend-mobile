import 'package:flutter/material.dart';

class ScholarshipsScreen extends StatelessWidget {
  const ScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Becas Disponibles')),
      body: const Center(child: Text('Listado de becas')),
    );
  }
}
