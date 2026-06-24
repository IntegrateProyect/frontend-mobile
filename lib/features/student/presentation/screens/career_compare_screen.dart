import 'package:flutter/material.dart';

class CareerCompareScreen extends StatelessWidget {
  const CareerCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comparar Carreras')),
      body: const Center(child: Text('Comparador de carreras')),
    );
  }
}
