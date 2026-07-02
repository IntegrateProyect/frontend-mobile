import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;
  
  List<ChatContactEntity> _contacts = [];
  List<ChatMessageEntity> _messages = [];
  bool _isLoading = false;
  String? _activeChatPartnerId;
  bool _isConnected = false;

  List<ChatContactEntity> get contacts => _contacts;
  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  ChatProvider({required this.repository}) {
    repository.onMessageReceived().listen((message) {
      debugPrint('XXX CHAT PROVIDER: New message received: ${message.text}');
      
      // Si el mensaje es de la conversación actual, lo añadimos
      if (message.senderId == _activeChatPartnerId || message.receiverId == _activeChatPartnerId) {
        // Reemplazar mensaje optimista si existe o añadir nuevo
        final index = _messages.indexWhere((m) => m.id == message.id || (m.text == message.text && m.id.startsWith('temp_')));
        
        if (index != -1) {
          _messages[index] = message;
        } else {
          _messages.add(message);
        }
        notifyListeners();
      }
      loadContacts(); 
    });
  }

  Future<void> connect() async {
    if (_isConnected) return;
    
    String apiUrl = dotenv.env['API_URL'] ?? 'https://orientate-backend.shop/api/v1';
    String socketUrl = apiUrl.replaceAll('/api/v1', '');
    
    try {
      await repository.connect(socketUrl);
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Connection failed: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _contacts = await repository.getContacts();
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Error contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory(String partnerId) async {
    _activeChatPartnerId = partnerId;
    _isLoading = true;
    _messages = [];
    notifyListeners();
    try {
      final history = await repository.getHistory(partnerId);
      _messages = List<ChatMessageEntity>.from(history);
      repository.markAsRead(partnerId);
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Error history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String receiverId, String text, String currentUserId) {
    debugPrint('XXX CHAT PROVIDER: Entrada a sendMessage. Conectado = $_isConnected');
    // ACTUALIZACIÓN OPTIMISTA: Añadir mensaje a la UI de inmediato
    final tempMessage = ChatMessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUserId,
      receiverId: receiverId,
      text: text,
      isRead: false,
      createdAt: DateTime.now(),
    );

    try {
      debugPrint('XXX CHAT PROVIDER: Añadiendo mensaje temporal a la lista');
      _messages.add(tempMessage);
      notifyListeners();
      debugPrint('XXX CHAT PROVIDER: Notificación exitosa.');
    } catch (e, stack) {
      debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN al añadir/notificar: $e\n$stack');
    }

    try {
      if (!_isConnected) {
        debugPrint('XXX CHAT PROVIDER: No conectado. Conectando primero...');
        connect().then((_) {
          try {
            debugPrint('XXX CHAT PROVIDER: Conexión completada. Llamando a repository.sendMessage...');
            repository.sendMessage(receiverId, text);
          } catch (e, stack) {
            debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN en callback sendMessage: $e\n$stack');
          }
        });
      } else {
        debugPrint('XXX CHAT PROVIDER: Ya conectado. Llamando a repository.sendMessage...');
        repository.sendMessage(receiverId, text);
      }
    } catch (e, stack) {
      debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN al llamar al repositorio: $e\n$stack');
    }
  }

  void clearMessages() {
    _messages = [];
    _activeChatPartnerId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    repository.disconnect();
    super.dispose();
  }
}
