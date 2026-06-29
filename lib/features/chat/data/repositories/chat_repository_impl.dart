import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:orientate/core/api/IApi.dart';
import 'package:orientate/core/utils/UserService.dart';
import 'package:orientate/features/chat/domain/entities/chat_contact_entity.dart';
import 'package:orientate/features/chat/domain/entities/chat_message_entity.dart';
import 'package:orientate/features/chat/domain/repositories/chat_repository.dart';
import 'package:orientate/features/chat/data/datasources/models/chat_contact_model.dart';
import 'package:orientate/features/chat/data/datasources/models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final IApi api;
  final UserService userService;
  io.Socket? _socket;
  final _messageController = StreamController<ChatMessageEntity>.broadcast();

  ChatRepositoryImpl({required this.api, required this.userService});

  @override
  Future<void> connect(String url) async {
    final token = await userService.getToken();
    if (token == null) return;

    _socket = io.io(url, io.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .build());

    _socket!.onConnect((_) => print('Connected to Chat Socket'));
    
    _socket!.on('new_message', (data) {
      final message = ChatMessageModel.fromJson(data);
      _messageController.add(message);
    });

    _socket!.on('message_delivered', (data) {
      final message = ChatMessageModel.fromJson(data);
      _messageController.add(message);
    });

    _socket!.connect();
  }

  @override
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  @override
  Future<List<ChatContactEntity>> getContacts() async {
    final token = await userService.getToken();
    final response = await api.getChatContacts(token!);
    final List<dynamic> contactsData = response['data']['contacts'];
    return contactsData.map((json) => ChatContactModel.fromJson(json)).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getHistory(String partnerId) async {
    final token = await userService.getToken();
    final response = await api.getChatHistory(token!, partnerId);
    final List<dynamic> historyData = response['data']['history'];
    return historyData.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  @override
  void sendMessage(String receiverId, String text) {
    _socket?.emit('send_message', {
      'receiverId': receiverId,
      'text': text,
    });
  }

  @override
  Stream<ChatMessageEntity> onMessageReceived() => _messageController.stream;

  @override
  void markAsRead(String senderId) {
    _socket?.emit('read_messages', {'senderId': senderId});
  }

  @override
  void sendTyping(String receiverId, bool isTyping) {
    _socket?.emit('typing', {
      'receiverId': receiverId,
      'isTyping': isTyping,
    });
  }
}
