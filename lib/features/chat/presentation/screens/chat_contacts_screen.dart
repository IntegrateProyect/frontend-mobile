import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import 'package:go_router/go_router.dart';

class ChatContactsScreen extends StatefulWidget {
  const ChatContactsScreen({super.key});

  @override
  State<ChatContactsScreen> createState() => _ChatContactsScreenState();
}

class _ChatContactsScreenState extends State<ChatContactsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      provider.connect(); // Asegura conexión para recibir nuevos mensajes
      provider.loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.contacts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.loadContacts(),
              child: ListView(
                children: [
                  SizedBox(height: 200, child: Center(child: Text('No tienes conversaciones activas.'))),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadContacts(),
            child: ListView.builder(
              itemCount: provider.contacts.length,
              itemBuilder: (context, index) {
                final contact = provider.contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF311B92).withOpacity(0.1),
                    child: Text(contact.contactName.isNotEmpty ? contact.contactName[0] : '?',
                      style: const TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold)),
                  ),
                  title: Text(contact.contactName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    contact.lastMessageText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(contact.lastMessageCreatedAt),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (contact.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF311B92),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${contact.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    context.push(
                      AppRoutes.realChat.path,
                      extra: {
                        'contactId': contact.contactId,
                        'contactName': contact.contactName,
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
