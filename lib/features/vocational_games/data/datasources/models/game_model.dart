import '../../../domain/entities/game_entity.dart';

class GameModel extends GameEntity {
  const GameModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.type,
  });

  factory GameModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GameModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description:
      (json['description'] ?? '').toString(),
      imageUrl: (
          json['imageUrl'] ??
              json['image_url'] ??
              ''
      ).toString(),
      type: (
          json['type'] ??
              json['category'] ??
              'RIASEC'
      ).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': type,
    };
  }
}