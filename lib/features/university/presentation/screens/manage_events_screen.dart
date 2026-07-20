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
        content: const Text('Esta acción no se puede deshacer y el evento dejará de ser visible para los estudiantes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
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

    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        provider.clearError();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Calendario de Eventos',
          style: TextStyle(
            color: _accentColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: provider.isLoading && provider.events.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : provider.events.isEmpty
              ? _buildEmptyState(provider)
              : RefreshIndicator(
                  color: _primaryColor,
                  onRefresh: () => provider.fetchEvents(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    itemCount: provider.events.length,
                    itemBuilder: (context, index) {
                      final event = provider.events[index];
                      return UniversityEventCard(
                        event: event,
                        onEdit: () => _showEventFormDialog(context, event: event),
                        onDelete: () => _deleteEvent(context, event.id),
                      );
                    },
                  ),
                ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingActionButton.extended(
          backgroundColor: _primaryColor,
          onPressed: () => _showEventFormDialog(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Crear Evento', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildEmptyState(UniversityEventsProvider provider) {
    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.r, color: Colors.redAccent.withOpacity(0.3)),
            SizedBox(height: 16.h),
            const Text('Error al cargar eventos', style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => provider.fetchEvents(),
              child: const Text('Reintentar'),
            )
          ],
        ),
      );
    }
    return const UniversityEmptyState(
      icon: Icons.event_busy_rounded,
      title: 'Sin eventos programados',
      description: 'Organiza ferias vocacionales o charlas informativas para atraer nuevos talentos.',
    );
  }
}
