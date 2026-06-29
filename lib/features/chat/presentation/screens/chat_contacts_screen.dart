import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../../../../core/routes/AppRoutes.dart';

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
      context.read<ChatProvider>().loadContacts();
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
            return const Center(
              child: Text('No tienes conversaciones activas.'),
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
                    child: Text(contact.contactName[0]),
                  ),
                  title: Text(contact.contactName),
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
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${contact.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.realChat.path,
                      arguments: {
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
