import 'auth_role_helper.dart';

class AuthValidators {
  static String? validateName(String name) {
    final value = name.trim();

    if (value.isEmpty) {
      return 'El nombre completo es obligatorio';
    }

    final lettersCount = value.replaceAll(' ', '').length;

    if (lettersCount < 3) {
      return 'El nombre debe tener mínimo 3 letras';
    }

    final nameRegex = RegExp(
      r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]+$',
    );

    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solamente puede contener letras y espacios';
    }

    return null;
  }

  static String? validateEmail(String email) {
    final value = email.trim();

    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido. Ejemplo: usuario@correo.com';
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }

    return null;
  }

  static String? validateRole(String role) {
    final value = AuthRoleHelper.normalizeRole(role);

    const validRoles = [
      'estudiante',
      'orientador',
      'universidad',
      'alumni',
      'admin',
    ];

    if (value.isEmpty) {
      return 'Debes seleccionar un rol';
    }

    if (!validRoles.contains(value)) {
      return 'El rol seleccionado no es válido';
    }

    return null;
  }

  static String? validateStudentProfile(Map<String, dynamic>? profile) {
    if (profile == null) {
      return 'Faltan los datos del perfil vocacional';
    }

    final subjectsLiked = profile['subjectsLiked'];
    final subjectsDisliked = profile['subjectsDisliked'];
    final interests = profile['interests'];
    final skills = profile['skills'];
    final vocationalClarity = profile['vocationalClarity'];

    if (subjectsLiked is! List || subjectsLiked.isEmpty) {
      return 'Selecciona al menos una materia que te gusta';
    }

    if (subjectsDisliked is! List || subjectsDisliked.isEmpty) {
      return 'Selecciona al menos una materia que no te gusta';
    }

    if (interests is! List || interests.isEmpty) {
      return 'Selecciona al menos un área de interés';
    }

    if (skills is! List || skills.isEmpty) {
      return 'Selecciona al menos una habilidad';
    }

    if (vocationalClarity is! int || vocationalClarity < 1 || vocationalClarity > 10) {
      return 'La claridad vocacional debe estar entre 1 y 10';
    }

    return null;
  }

  static String? validateGroupCode(String? accessCode) {
    final value = accessCode?.trim() ?? '';

    if (value.isEmpty) {
      return 'Ingresa el código del grupo';
    }

    if (value.length < 4) {
      return 'El código del grupo debe tener mínimo 4 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(value)) {
      return 'El código solo puede tener letras, números, guion o guion bajo';
    }

    return null;
  }
}
