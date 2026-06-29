import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const GameResultScreen({
    super.key,
    required this.result,
  });

  static const Color primaryColor = Color(0xFF4B1D7A);
  static const Color purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    final scores = _extractScores(result);
    final top = scores.isNotEmpty ? scores.entries.first : null;

    final title = top == null
        ? 'Resultado Vocacional'
        : _resultTitle(top.key.toString());

    final percentage = top == null ? 0 : _normalizePercent(top.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tus Resultados',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _buildHeroCard(title, percentage),
          const SizedBox(height: 18),
          _buildSectionTitle('Fortalezas Detectadas', 'Ver todas >'),
          const SizedBox(height: 10),
          _strengthCard(
            icon: Icons.psychology_outlined,
            title: 'Pensamiento Lógico',
            text: 'Capacidad para organizar ideas y resolver problemas.',
          ),
          _strengthCard(
            icon: Icons.groups_outlined,
            title: 'Colaboración',
            text: 'Habilidad natural para trabajar en equipo.',
          ),
          _strengthCard(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Atención al Detalle',
            text: 'Alta precisión en tareas técnicas y metodológicas.',
          ),
          const SizedBox(height: 18),
          const Text(
            'Intereses Principales',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: scores.entries.take(4).map((entry) {
              return _interestChip(entry.key.toString());
            }).toList(),
          ),
          const SizedBox(height: 18),
          _clarityCard(percentage),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Ver carreras recomendadas  ›',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(String title, int percentage) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFD946EF), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            child: Icon(Icons.track_changes, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Resultado Principal',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu perfil destaca por habilidades, intereses y pensamiento vocacional.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'COMPATIBILIDAD\n$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),
                ),
                const Icon(Icons.track_changes, color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: purple,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _strengthCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _cleanName(text),
        style: const TextStyle(
          color: purple,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _clarityCard(int percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_border, color: primaryColor),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Claridad Vocacional',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              color: primaryColor,
              backgroundColor: const Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '¡Excelente! Tus respuestas muestran una dirección muy clara hacia áreas relacionadas con este perfil.',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _extractScores(Map<String, dynamic> result) {
    final scores = result['scores'] ?? result['score'] ?? result;

    if (scores is Map && scores.isNotEmpty) {
      final map = Map<String, dynamic>.from(scores);

      final entries = map.entries.toList()
        ..sort((a, b) {
          final av = int.tryParse(a.value.toString()) ?? 0;
          final bv = int.tryParse(b.value.toString()) ?? 0;
          return bv.compareTo(av);
        });

      return Map.fromEntries(entries);
    }

    return {};
  }

  int _normalizePercent(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    if (number > 100) return 100;
    if (number < 0) return 0;
    return number;
  }

  String _resultTitle(String key) {
    final clean = _cleanName(key);

    if (clean.contains('SERVICIO') || clean.contains('SOCIAL')) {
      return 'Servicio Social y Humanidades';
    }

    if (clean.contains('PERSUASIVO')) {
      return 'Liderazgo y Comunicación';
    }

    if (clean.contains('MUSICAL')) {
      return 'Arte Musical';
    }

    if (clean.contains('CALCULO')) {
      return 'Ingeniería y STEM';
    }

    return clean;
  }

  String _cleanName(String text) {
    return text
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .toUpperCase();
  }
}