// features/chatbot/presentation/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../components/chat_bubble.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _lightPurple = Color(0xFFEDE7F6);
  static const Color _textColor = Color(0xFF1D1B4B);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _searchMode = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    final provider = context.read<ChatbotProvider>();

    if (provider.isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();
    _controller.clear();

    // Muestra inmediatamente el mensaje escrito por el alumno.
    final sending = provider.sendMessage(
      text,
      search: _searchMode,
    );

    _scrollToBottom();

    // Espera la respuesta del backend.
    await sending;

    if (!mounted) {
      return;
    }

    /*
     * Si el backend responde 401, el ChatbotProvider marca
     * sessionExpired = true.
     *
     * No se compara el texto del error porque la documentación
     * indica que ese mensaje puede cambiar.
     */
    if (provider.sessionExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ??
                'Tu sesión expiró. Inicia sesión nuevamente.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.go('/login');
      return;
    }

    _scrollToBottom();
  }

  void _clearConversation() {
    final provider = context.read<ChatbotProvider>();

    if (provider.messages.isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Limpiar conversación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          content: const Text(
            '¿Quieres eliminar los mensajes mostrados en esta pantalla?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
              onPressed: () {
                provider.clearConversation();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Limpiar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();

    /*
     * Cuando se agrega un mensaje o termina la carga,
     * desplaza la conversación hacia abajo.
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _textColor,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 4,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _lightPurple,
              child: Icon(
                Icons.auto_awesome,
                color: _primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oriéntate+ Chat',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  Text(
                    'Asistente vocacional',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Limpiar conversación',
            onPressed: provider.messages.isEmpty
                ? null
                : _clearConversation,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildSearchSection(),

            Expanded(
              child: provider.messages.isEmpty
                  ? _buildEmptyState()
                  : _buildMessages(provider),
            ),

            if (provider.isLoading) _buildLoadingIndicator(),

            if (provider.error != null &&
                !provider.sessionExpired &&
                !provider.isLoading)
              _buildErrorBanner(provider.error!),

            _buildInputArea(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: _searchMode
              ? _lightPurple
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _searchMode
                ? _primaryColor.withOpacity(0.25)
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _searchMode
                  ? Icons.travel_explore_rounded
                  : Icons.search_rounded,
              size: 21,
              color: _searchMode
                  ? _primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscar carreras',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _searchMode
                          ? _primaryColor
                          : _textColor,
                    ),
                  ),
                  Text(
                    _searchMode
                        ? 'El chatbot buscará carreras relacionadas'
                        : 'Actívalo para recibir opciones de carreras',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _searchMode,
              activeThumbColor: _primaryColor,
              activeTrackColor: _primaryColor.withOpacity(0.35),
              onChanged: (value) {
                setState(() {
                  _searchMode = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(ChatbotProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 20),
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final message = provider.messages[index];

        final isLastMessage =
            index == provider.messages.length - 1;

        final isLastBotMessage =
            isLastMessage &&
                message.sender == MessageSender.bot;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatBubble(message: message),

            /*
             * Las fuentes solamente se colocan debajo de la
             * última respuesta del chatbot.
             *
             * Las fuentes con isClusterAlternative = true
             * corresponden a alternativas encontradas por K-Means.
             */
            if (isLastBotMessage &&
                provider.lastSources.isNotEmpty)
              _buildSources(provider),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: _lightPurple,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _primaryColor.withOpacity(0.12),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 42,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Hola! Soy Oriéntate+',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuéntame qué materias te gustan, cuáles son tus habilidades o qué buscas en una carrera.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSuggestion(
              icon: Icons.psychology_outlined,
              text: 'No sé qué carrera estudiar',
            ),
            const SizedBox(height: 10),
            _buildSuggestion(
              icon: Icons.water_drop_outlined,
              text: 'Me interesa resolver problemas del agua',
            ),
            const SizedBox(height: 10),
            _buildSuggestion(
              icon: Icons.computer_outlined,
              text: 'Me gustan la tecnología y las matemáticas',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestion({
    required IconData icon,
    required String text,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          _controller.text = text;
          _controller.selection = TextSelection.collapsed(
            offset: text.length,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _primaryColor.withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: _primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: _textColor,
                  ),
                ),
              ),
              const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSources(ChatbotProvider provider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _primaryColor.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 17,
                color: _primaryColor,
              ),
              SizedBox(width: 7),
              Text(
                'Carreras relacionadas',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: provider.lastSources.take(5).map((source) {
              final isClusterAlternative =
                  source.isClusterAlternative;

              return Tooltip(
                message: isClusterAlternative
                    ? 'Alternativa relacionada'
                    : source.universidad,
                child: Chip(
                  avatar: Icon(
                    isClusterAlternative
                        ? Icons.auto_awesome_rounded
                        : Icons.school_outlined,
                    size: 15,
                    color: _primaryColor,
                  ),
                  label: Text(
                    source.careerName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: _textColor,
                    ),
                  ),
                  backgroundColor: isClusterAlternative
                      ? const Color(0xFFF3E5F5)
                      : const Color(0xFFE8EAF6),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      color: Colors.white,
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: _primaryColor,
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Oriéntate+ está escribiendo...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: 18,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatbotProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 48,
                maxHeight: 130,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                ),
              ),
              child: TextField(
                controller: _controller,
                enabled: !provider.isLoading,
                minLines: 1,
                maxLines: 5,
                textCapitalization:
                TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) {
                  /*
                   * En campos multilínea el botón del teclado
                   * puede agregar una nueva línea.
                   *
                   * El envío principal se realiza con el botón.
                   */
                },
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Material(
            color: provider.isLoading
                ? Colors.grey[400]
                : _primaryColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: provider.isLoading
                  ? null
                  : _handleSend,
              child: SizedBox(
                width: 48,
                height: 48,
                child: provider.isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}