import 'package:flutter/material.dart';

class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar Carreras')),
      body: const Center(child: Text('Explorador de carreras profesionales')),
    );
  }
}
