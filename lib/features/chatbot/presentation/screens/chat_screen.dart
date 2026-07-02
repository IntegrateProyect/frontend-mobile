// features/chatbot/presentation/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../components/chat_bubble.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller   = TextEditingController();
  final _scrollCtrl   = ScrollController();
  bool  _searchMode   = false;   // toggle RAG

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    await context.read<ChatbotProvider>().sendMessage(
      text,
      search: _searchMode,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();

    // Scroll cuando llega respuesta
    if (!provider.isLoading) _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oriéntate+ Chat'),
        actions: [
          // Toggle RAG
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 18,
                  color: _searchMode
                      ? const Color(0xFF311B92)
                      : Colors.grey,
                ),
                Switch(
                  value: _searchMode,
                  activeColor: const Color(0xFF311B92),
                  onChanged: (v) => setState(() => _searchMode = v),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner RAG activo
          if (_searchMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: const Color(0xFFEDE7F6),
              child: const Text(
                '🔍 Búsqueda de carreras activada',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF311B92),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Lista de mensajes
          Expanded(
            child: provider.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller:  _scrollCtrl,
              padding:     const EdgeInsets.all(16),
              itemCount:   provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];
                // Si es el último mensaje del bot + hubo fuentes, mostralas
                final isLastBot = index == provider.messages.length - 1 &&
                    msg.sender == MessageSender.bot;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatBubble(message: msg),
                    if (isLastBot && provider.lastSources.isNotEmpty)
                      _buildSourcesChips(provider),
                  ],
                );
              },
            ),
          ),

          // Indicador de carga
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(
                color: Color(0xFF311B92),
                backgroundColor: Color(0xFFEDE7F6),
              ),
            ),

          _buildInputArea(provider.isLoading),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFFCBB8FF)),
          SizedBox(height: 16),
          Text(
            '¡Hola! Soy Oriéntate+\n¿En qué puedo ayudarte hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcesChips(ChatbotProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: provider.lastSources.take(4).map((src) {
          return Chip(
            label: Text(
              src.careerName,
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: src.isClusterAlternative
                ? const Color(0xFFF3E5F5)
                : const Color(0xFFE8EAF6),
            avatar: Icon(
              src.isClusterAlternative
                  ? Icons.auto_awesome
                  : Icons.school_outlined,
              size: 14,
              color: const Color(0xFF311B92),
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  enabled:    !isLoading,
                  maxLines:   null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border:   InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical:   10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF311B92),
              child: isLoading
                  ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                  color:       Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : IconButton(
                icon:    const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}