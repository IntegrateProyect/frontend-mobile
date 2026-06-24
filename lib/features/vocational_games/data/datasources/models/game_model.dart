import '../../../domain/entities/game_entity.dart';

class GameModel extends GameEntity {
  GameModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.type,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
    };
  }
}
