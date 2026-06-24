
import '../../../domain/entities/career_entity.dart';

class CareerModel extends CareerEntity {
  CareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.fields,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fields: List<String>.from(json['fields'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fields': fields,
    };
  }
}
