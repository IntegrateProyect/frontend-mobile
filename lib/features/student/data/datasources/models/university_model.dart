import '../../../domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  const UniversityModel({
    required super.id,
    required super.name,
    super.location,
    super.logoUrl,
    super.availableCareers,
    super.representativeUserId,
    super.isRegistered,
  });

  factory UniversityModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final name = _stringValue(
      json['name'],
      fallback: 'Universidad sin nombre',
    );

    final representativeUserId =
    _nullableString(
      json['representativeUserId'],
    );

    return UniversityModel(
      id: _stringValue(
        json['id'] ??
            representativeUserId ??
            name,
      ),
      name: name,
      location: _stringValue(
        json['location'],
        fallback:
        'Catálogo nacional RENOES',
      ),
      logoUrl: _nullableString(
        json['logoUrl'],
      ),
      availableCareers: _stringList(
        json['availableCareers'],
      ),
      representativeUserId:
      representativeUserId,
      isRegistered:
      json['isRegistered'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'availableCareers':
      availableCareers,
      'representativeUserId':
      representativeUserId,
      'isRegistered': isRegistered,
    };
  }

  static String _stringValue(
      dynamic value, {
        String fallback = '',
      }) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static String? _nullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  static List<String> _stringList(
      dynamic value,
      ) {
    if (value is! List) {
      return [];
    }

    return value
        .map((item) => item.toString())
        .toList();
  }
}