class AuthRoleHelper {
  static String normalizeRole(String role) {
    final value = role.trim().toLowerCase();

    /*
     * En la interfaz se utiliza "egresado",
     * pero el backend utiliza "alumni".
     */
    if (value == 'egresado') {
      return 'alumni';
    }

    if (value == 'student') {
      return 'estudiante';
    }

    if (value == 'counselor') {
      return 'orientador';
    }

    if (value == 'university') {
      return 'universidad';
    }

    return value;
  }
}
