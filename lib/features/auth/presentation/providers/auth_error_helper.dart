class AuthErrorHelper {
  static String cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '').trim();
  }

  static String normalizeError(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

  static bool isProfileNotFoundError(String normalizedError) {
    return normalizedError.contains('404') ||
        normalizedError.contains('perfil vocacional no encontrado') ||
        normalizedError.contains('no se encontro el perfil vocacional') ||
        normalizedError.contains('no existe el perfil vocacional') ||
        normalizedError.contains('student profile not found') ||
        normalizedError.contains('vocational profile not found') ||
        (normalizedError.contains('perfil') && normalizedError.contains('no se encontro')) ||
        (normalizedError.contains('perfil') && normalizedError.contains('no encontrado'));
  }
}
