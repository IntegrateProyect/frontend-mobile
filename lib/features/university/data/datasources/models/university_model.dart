
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

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Universidad sin nombre',
      location: json['location']?.toString() ?? 'Catálogo nacional RENOES',
      logoUrl: json['logoUrl']?.toString(),
      availableCareers: json['availableCareers'] != null 
          ? List<String>.from(json['availableCareers']) 
          : [],
      representativeUserId: json['representativeUserId']?.toString(),
      isRegistered: json['isRegistered'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'availableCareers': availableCareers,
      'representativeUserId': representativeUserId,
      'isRegistered': isRegistered,
    };
  }
}
