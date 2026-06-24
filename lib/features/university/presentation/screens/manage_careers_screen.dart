import 'package:flutter/material.dart';

class ManageCareersScreen extends StatelessWidget {
  const ManageCareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Carreras')),
      body: const Center(child: Text('Lista de carreras de la universidad')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
