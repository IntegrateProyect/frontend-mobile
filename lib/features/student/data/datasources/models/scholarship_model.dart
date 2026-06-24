
import '../../../domain/entities/scholarship_entity.dart';

class ScholarshipModel extends ScholarshipEntity {
  ScholarshipModel({
    required super.id,
    required super.title,
    required super.provider,
    required super.description,
    super.amount,
  });

  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      provider: json['provider'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'provider': provider,
      'description': description,
      'amount': amount,
    };
  }
}
