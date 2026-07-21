class StudentCounselorEntity {
  final String id;
  final String name;
  final String email;

  const StudentCounselorEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory StudentCounselorEntity.fromJson(
      Map<String, dynamic> json,
      ) {
    return StudentCounselorEntity(
      id: _parseString(json['id']),
      name: _parseString(
        json['name'] ??
            json['fullName'] ??
            json['nombre'],
        fallback: 'Por asignar',
      ),
      email: _parseString(json['email']),
    );
  }

  static String _parseString(
      dynamic value, {
        String fallback = '',
      }) {
    final text = value?.toString().trim() ?? '';

    if (text.isEmpty ||
        text.toLowerCase() == 'null' ||
        text.toLowerCase() == 'undefined') {
      return fallback;
    }

    return text;
  }
}