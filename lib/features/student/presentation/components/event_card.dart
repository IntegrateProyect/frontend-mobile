import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event_entity.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text(event.title),
        subtitle: Text('${DateFormat('dd/MM/yyyy').format(event.date)} - ${event.location}'),
        onTap: onTap,
      ),
    );
  }
}
