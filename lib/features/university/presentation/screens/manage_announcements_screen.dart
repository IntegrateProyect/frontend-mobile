import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_provider.dart';
import '../components/university_announcement_card.dart';
import '../components/university_announcement_form.dart';
import '../components/university_bottom_navigation_bar.dart';

class ManageAnnouncementsScreen extends StatefulWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  State<ManageAnnouncementsScreen> createState() => _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState extends State<ManageAnnouncementsScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UniversityProvider>().fetchAnnouncements();
    });
  }

  void _showFormDialog(BuildContext context, {dynamic announcement}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: UniversityAnnouncementForm(
            announcement: announcement,
            onSuccess: () {
              Navigator.pop(sheetCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    announcement == null
                        ? '¡Anuncio publicado con éxito!'
                        : 'Anuncio actualizado correctamente',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteAnnouncement(BuildContext context, String id) async {
    final provider = context.read<UniversityProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('¿Eliminar Anuncio?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Esta acción no se puede deshacer.'),
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
      await provider.deleteAnnouncement(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityProvider>();

    // Manejo de errores (Rate Limit, etc)
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
          'Anuncios y Becas',
          style: TextStyle(
            color: _accentColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: provider.isLoading && provider.announcements.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : provider.announcements.isEmpty
              ? _buildEmptyState(provider)
              : RefreshIndicator(
                  color: _primaryColor,
                  onRefresh: () => provider.fetchAnnouncements(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(24.w),
                    itemCount: provider.announcements.length,
                    itemBuilder: (context, index) {
                      final item = provider.announcements[index];
                      return UniversityAnnouncementCard(
                        announcement: item,
                        onEdit: () => _showFormDialog(context, announcement: item),
                        onDelete: () => _deleteAnnouncement(context, item.id),
                      );
                    },
                  ),
                ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingActionButton.extended(
          backgroundColor: _primaryColor,
          onPressed: () => _showFormDialog(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Nuevo Anuncio', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildEmptyState(UniversityProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.errorMessage != null ? Icons.error_outline : Icons.campaign_outlined, 
              size: 64.r, 
              color: provider.errorMessage != null ? Colors.redAccent.withOpacity(0.3) : Colors.grey[300]
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            provider.errorMessage != null ? 'Error de conexión' : 'Sin comunicados',
            style: TextStyle(fontSize: 18.sp, color: _accentColor, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8.h),
          Text(
            provider.errorMessage != null 
                ? 'No se pudieron cargar los datos. Intenta más tarde.' 
                : 'Informa a los alumnos sobre becas e inscripciones.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (provider.errorMessage != null) ...[
            SizedBox(height: 20.h),
            TextButton.icon(
              onPressed: () => provider.fetchAnnouncements(),
              icon: const Icon(Icons.refresh, color: _primaryColor),
              label: const Text('Reintentar', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
    );
  }
}
