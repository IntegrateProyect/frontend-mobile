import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
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
    if (_socket?.connected == true) return;

    final token = await userService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('XXX CHAT: Error - No hay token para conectar');
      return;
    }

    // El servidor requiere el token sin "Bearer "
    final cleanToken = token.replaceFirst('Bearer ', '').trim();
    debugPrint('XXX CHAT: Intentando conectar a $url');

    _socket = io.io(url, io.OptionBuilder()
      .setTransports(['websocket', 'polling'])
      .setAuth({'token': cleanToken})
      .enableForceNew()
      .setReconnectionAttempts(10)
      .setReconnectionDelay(3000)
      .build());

    _socket!.onConnect((_) => debugPrint('XXX CHAT: ¡Conectado al Socket!'));
    _socket!.onConnectError((data) => debugPrint('XXX CHAT: Error de conexión: $data'));
    _socket!.onError((data) => debugPrint('XXX CHAT: Error de servidor: $data'));
    
    // Escuchar mensajes de otros (Receptor)
    _socket!.on('new_message', (data) {
      debugPrint('XXX CHAT: Nuevo mensaje recibido: $data');
      _handleIncoming(data);
    });

    // Confirmación de que MI mensaje se guardó (Emisor)
    _socket!.on('message_delivered', (data) {
      debugPrint('XXX CHAT: Confirmación de entrega recibida');
      final msgData = (data is Map && data.containsKey('message')) ? data['message'] : data;
      _handleIncoming(msgData);
    });

    _socket!.connect();
  }

  void _handleIncoming(dynamic data) {
    if (data == null) return;
    try {
      final message = ChatMessageModel.fromJson(data);
      _messageController.add(message);
    } catch (e) {
      debugPrint('XXX CHAT: Error al procesar mensaje: $e');
    }
  }

  @override
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  Future<List<ChatContactEntity>> getContacts() async {
    final token = await userService.getToken();
    final response = await api.getChatContacts(token!);
    final dynamic data = response['data'] ?? response;
    final List<dynamic> contactsData = data['contacts'] ?? [];
    return contactsData.map((json) => ChatContactModel.fromJson(json)).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getHistory(String partnerId) async {
    final token = await userService.getToken();
    final response = await api.getChatHistory(token!, partnerId);
    final dynamic data = response['data'] ?? response;
    final List<dynamic> historyData = data['history'] ?? [];
    return historyData.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  @override
  void sendMessage(String receiverId, String text) {
    if (_socket == null || !_socket!.connected) {
      debugPrint('XXX CHAT: Socket no listo. Intentando conectar...');
      _socket?.connect();
      return;
    }
    
    debugPrint('XXX CHAT: Emitiendo event send_message a $receiverId con texto: "$text"');
    _socket!.emit('send_message', {
      'receiverId': receiverId,
      'text': text,
    });
  }

  @override
  Stream<ChatMessageEntity> onMessageReceived() => _messageController.stream;

  @override
  void markAsRead(String senderId) {
    if (_socket?.connected == true) {
      _socket!.emit('read_messages', {'senderId': senderId});
    }
  }

  @override
  void sendTyping(String receiverId, bool isTyping) {
    if (_socket?.connected == true) {
      _socket!.emit('typing', {
        'receiverId': receiverId,
        'isTyping': isTyping,
      });
    }
  }
}
