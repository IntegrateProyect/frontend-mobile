import '../../../domain/entities/vocational_mini_game_entity.dart';

class GameOptionLabels {
  const GameOptionLabels._();

  /// Genera la etiqueta corta de una opción combinando:
  /// - el nivel de interés detectado en el texto original de la opción
  /// - la categoría vocacional real de la pregunta (música, arte,
  ///   mecánica, etc.), obtenida con GameMapper.detectCategory
  static String fromOriginal({
    required String originalText,
    required VocationalCategory category,
  }) {
    final level = _detectLevel(originalText);
    return _labelsFor(category)[level];
  }

  static int _detectLevel(String originalText) {
    final text = _normalize(originalText);

    if (text.contains('me desagrada mucho') ||
        text.contains('no me gusta nada') ||
        text.contains('muy desagradable')) {
      return 0;
    }

    if (text.contains('no me gusta') ||
        text.contains('me desagrada')) {
      return 1;
    }

    if (text.contains('me es indiferente') ||
        text.contains('indiferente') ||
        text.contains('neutral')) {
      return 2;
    }

    if (text.contains('me gusta mucho') ||
        text.contains('me encanta') ||
        text.contains('muy interesante')) {
      return 4;
    }

    if (text.contains('me gusta') ||
        text.contains('interesante')) {
      return 3;
    }

    return 2;
  }

  /// 5 verbos (nivel 0 a 4) por cada categoría vocacional, para
  /// que la palabra tenga relación directa con el tema real
  /// de la pregunta, sin importar en qué pantalla se muestre.
  static List<String> _labelsFor(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return const [
          'Descartar',
          'Dudar',
          'Calcular',
          'Resolver',
          'Dominar',
        ];
      case VocationalCategory.fisico:
        return const [
          'Descartar',
          'Observar',
          'Explorar',
          'Investigar',
          'Descubrir',
        ];
      case VocationalCategory.biologico:
        return const [
          'Descartar',
          'Observar',
          'Cuidar',
          'Analizar',
          'Investigar',
        ];
      case VocationalCategory.mecanico:
        return const [
          'Guardar',
          'Revisar',
          'Probar',
          'Instalar',
          'Completar',
        ];
      case VocationalCategory.social:
        return const [
          'No intervenir',
          'Escuchar',
          'Orientar',
          'Acompañar',
          'Ayudar',
        ];
      case VocationalCategory.literario:
        return const [
          'Descartar',
          'Hojear',
          'Leer',
          'Redactar',
          'Escribir',
        ];
      case VocationalCategory.persuasivo:
        return const [
          'Callar',
          'Opinar',
          'Argumentar',
          'Convencer',
          'Liderar',
        ];
      case VocationalCategory.artistico:
        return const [
          'Descartar',
          'Esbozar',
          'Combinar',
          'Diseñar',
          'Crear',
        ];
      case VocationalCategory.musical:
        return const [
          'Descartar',
          'Escuchar',
          'Ensayar',
          'Interpretar',
          'Componer',
        ];
    }
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }
}