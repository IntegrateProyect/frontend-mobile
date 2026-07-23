import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_announcements_provider.dart';
import '../components/university_announcement_card.dart';
import '../components/university_announcement_form.dart';
import '../components/university_bottom_navigation_bar.dart';
import '../components/university_empty_state.dart';
import '../components/university_premium_fab.dart';
import '../components/premium_upgrade_dialog.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

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
      if (mounted) {
        context.read<UniversityAnnouncementsProvider>().fetchAnnouncements();
      }
    });
  }

  void _showFormDialog(BuildContext context, {dynamic announcement}) {
    context.read<UniversityAnnouncementsProvider>().resetForm(announcement: announcement);

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
    final provider = context.read<UniversityAnnouncementsProvider>();
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
    final provider = context.watch<UniversityAnnouncementsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isPremium = authProvider.user?.isPremium ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Anuncios y Becas',
          style: TextStyle(color: _accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900),
        ),
        automaticallyImplyLeading: false,
      ),
      body: provider.isLoading && provider.announcements.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : provider.announcements.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  color: _primaryColor,
                  onRefresh: () => provider.fetchAnnouncements(),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 80.h),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: UniversityPremiumFab(
        label: 'Nuevo Anuncio',
        onPressed: () {
          if (!isPremium && provider.announcements.length >= 1) {
            showPremiumUpgradeDialog(context, feature: 'anuncios publicados');
          } else {
            _showFormDialog(context);
          }
        },
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return UniversityEmptyState(
      title: 'Sin comunicados activos aún',
      imagePath: 'assets/images/anuncios_becas.png',
      fallbackIcon: Icons.campaign_rounded,
    );
  }
}
