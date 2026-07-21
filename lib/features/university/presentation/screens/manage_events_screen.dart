import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/university_event_entity.dart';
import '../providers/university_events_provider.dart';
import '../providers/university_careers_provider.dart';
import '../components/university_event_card.dart';
import '../components/university_event_form.dart';
import '../components/university_empty_state.dart';
import '../components/university_bottom_navigation_bar.dart';
import '../components/university_premium_fab.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UniversityEventsProvider>().fetchEvents();
        context.read<UniversityCareersProvider>().fetchCareers();
      }
    });
  }

  void _showEventFormDialog(BuildContext context, {UniversityEventEntity? event}) {
    context.read<UniversityEventsProvider>().resetForm(event: event);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
        ),
        child: UniversityEventForm(
          event: event,
          onSuccess: () {
            Navigator.pop(sheetCtx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  event == null ? '¡Evento publicado con éxito!' : 'Evento actualizado correctamente',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteEvent(BuildContext context, String eventId) async {
    final provider = context.read<UniversityEventsProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('¿Eliminar Evento?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Esta acción no se puede deshacer y el evento dejará de ser visible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.deleteEvent(eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityEventsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Calendario de Eventos', style: TextStyle(color: _accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900)),
        automaticallyImplyLeading: false,
      ),
      body: provider.isLoading && provider.events.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : provider.events.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  color: _primaryColor,
                  onRefresh: () => provider.fetchEvents(),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 80.h),
                    itemCount: provider.events.length,
                    itemBuilder: (context, index) => UniversityEventCard(
                      event: provider.events[index],
                      onEdit: () => _showEventFormDialog(context, event: provider.events[index]),
                      onDelete: () => _deleteEvent(context, provider.events[index].id),
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: UniversityPremiumFab(
        label: 'Publicar Evento',
        onPressed: () => _showEventFormDialog(context),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return UniversityEmptyState(
      title: 'No hay eventos agendados aún',
      imagePath: 'assets/images/eventos_universitarios.png',
      fallbackIcon: Icons.calendar_month_rounded,
    );
  }
}
