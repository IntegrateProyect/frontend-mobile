class GameResultInterpreter {
  static Map<String, dynamic> extractScores(Map<String, dynamic> result) {
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

  static int normalizePercent(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    if (number > 100) return 100;
    if (number < 0) return 0;
    return number;
  }

  static String getResultTitle(String key) {
    final clean = cleanName(key);

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

  static String cleanName(String text) {
    return text
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .toUpperCase();
  }
}
