class CounselorErrorHelper {
  static String cleanError(Object error) {
    final String message = error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();

    final String normalized = message.toLowerCase();

    if (normalized.contains('cannot post')) {
      return 'El servicio para agendar citas no está disponible.';
    }

    if (normalized.contains('pertenece') ||
        normalized.contains('does not belong') ||
        normalized.contains('not belong')) {
      return 'El alumno seleccionado no pertenece a uno de tus grupos.';
    }

    if (normalized.contains('availability') ||
        normalized.contains('disponibilidad') ||
        normalized.contains('outside')) {
      return 'La fecha y hora están fuera de tu disponibilidad.';
    }

    if (normalized.contains('overlap') ||
        normalized.contains('solapamiento') ||
        normalized.contains('conflict') ||
        normalized.contains('already has')) {
      return 'El orientador o el alumno ya tiene otra cita cercana a ese horario.';
    }

    if (normalized.contains('<!doctype html>') ||
        normalized.contains('<html')) {
      return 'El servidor no pudo procesar la solicitud.';
    }

    return message.isEmpty
        ? 'No fue posible completar la solicitud.'
        : message;
  }

  static int toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
