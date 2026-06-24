import '../../../domain/entities/chat_message_entity.dart';
import '../models/chat_message_model.dart';

class ChatMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) {
    return ChatMessageEntity(
      id: model.id,
      text: model.text,
      sender: model.sender,
      timestamp: model.timestamp,
    );
  }

  static ChatMessageModel fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      sender: entity.sender,
      timestamp: entity.timestamp,
    );
  }
}
