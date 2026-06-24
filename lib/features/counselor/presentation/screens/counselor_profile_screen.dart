import 'package:flutter/material.dart';

class CounselorProfileScreen extends StatelessWidget {
  const CounselorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Orientador')),
      body: const Center(child: Text('Información del Orientador')),
    );
  }
}
