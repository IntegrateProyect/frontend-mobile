import 'package:flutter/material.dart';
import '../components/chat_bubble.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessageEntity> _messages = [
    ChatMessageEntity(
      id: '1',
      text: '¡Hola! Soy tu orientador virtual. ¿En qué puedo ayudarte hoy?',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    ),
  ];

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        ChatMessageEntity(
          id: DateTime.now().toString(),
          text: _controller.text,
          sender: MessageSender.user,
          timestamp: DateTime.now(),
        ),
      );
    });
    
    // Simular respuesta del bot
    final String userText = _controller.text;
    _controller.clear();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessageEntity(
              id: DateTime.now().toString(),
              text: 'He recibido tu mensaje: "$userText". Pronto podré ayudarte con información más detallada sobre carreras y universidades.',
              sender: MessageSender.bot,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat de Orientación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
