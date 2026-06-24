import 'package:flutter/material.dart';

class RequestSupportScreen extends StatelessWidget {
  const RequestSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Apoyo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Escribe tu duda para un orientador profesional.'),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe en qué necesitas ayuda...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enviar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}
