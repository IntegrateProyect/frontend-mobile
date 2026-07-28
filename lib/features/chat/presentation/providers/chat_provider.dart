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
  bool _isConnecting = false;

  List<ChatContactEntity> get contacts => _contacts;
  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  ChatProvider({required this.repository}) {
    repository.onMessageReceived().listen((message) {
      debugPrint('XXX CHAT PROVIDER: New message received: ${message.text}');

      if (message.senderId == _activeChatPartnerId || message.receiverId == _activeChatPartnerId) {
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

    // La conexión real ahora se refleja desde eventos del socket (onConnect/onDisconnect),
    // no desde que repository.connect() haya simplemente retornado.
    repository.onConnectionChanged.listen((connected) {
      debugPrint('XXX CHAT PROVIDER: Estado de conexión actualizado -> $connected');
      _isConnected = connected;
      notifyListeners();
    });
  }

  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;

    final apiUrl = dotenv.env['API_URL'] ?? 'https://orientate-backend.shop/api/v1';
    final socketUrl = apiUrl.replaceAll('/api/v1', '');
    // Nota: ya NO se hace conversión wss/puerto aquí; eso vive solo en el repositorio.

    try {
      await repository.connect(socketUrl);
      // No seteamos _isConnected aquí: se actualizará vía onConnectionChanged
      // cuando el socket realmente dispare 'connect'.
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Connection failed: $e');
      _isConnected = false;
      notifyListeners();
    } finally {
      _isConnecting = false;
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

    final tempMessage = ChatMessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUserId,
      receiverId: receiverId,
      text: text,
      isRead: false,
      createdAt: DateTime.now(),
    );

    _messages.add(tempMessage);
    notifyListeners();

    // El repositorio ahora encola el mensaje internamente si el socket no está listo,
    // así que ya no es necesario esperar a connect() antes de llamar a sendMessage.
    if (!_isConnected) {
      debugPrint('XXX CHAT PROVIDER: No conectado. Disparando connect() en paralelo...');
      connect();
    }
    repository.sendMessage(receiverId, text);
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