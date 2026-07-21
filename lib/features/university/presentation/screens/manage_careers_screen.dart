import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_careers_provider.dart';
import '../components/university_career_card.dart';
import '../components/university_career_form.dart';
import '../components/university_bottom_navigation_bar.dart';

class ManageCareersScreen extends StatefulWidget {
  const ManageCareersScreen({super.key});

  @override
  State<ManageCareersScreen> createState() => _ManageCareersScreenState();
}

class _ManageCareersScreenState extends State<ManageCareersScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UniversityCareersProvider>().fetchCareers();
      }
    });
  }

  void _showAddCareerDialog(BuildContext context) {
    final provider = context.read<UniversityCareersProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        child: UniversityCareerForm(provider: provider),
      ),
    );
  }
 
  void _deleteCareer(BuildContext context, String careerId) async {
    final provider = context.read<UniversityCareersProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('¿Desvincular Carrera?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Esta carrera dejará de aparecer en tu oferta académica.'),
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
      await provider.deleteCareer(careerId);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversityCareersProvider>();
 
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
        title: Text('Oferta Académica', style: TextStyle(color: _accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900)),
        automaticallyImplyLeading: false, 
      ),
      body: provider.isLoading && provider.careers.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : provider.careers.isEmpty
              ? _buildEmptyState(provider)
              : RefreshIndicator(
                  onRefresh: () => provider.fetchCareers(),
                  color: _primaryColor,
                  child: ListView.builder(
                    padding: EdgeInsets.all(24.w),
                    itemCount: provider.careers.length,
                    itemBuilder: (context, index) => UniversityCareerCard(
                      career: provider.careers[index],
                      onDelete: () => _deleteCareer(context, provider.careers[index].id),
                    ),
                  ),
                ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h), 
        child: FloatingActionButton.extended(
          backgroundColor: _primaryColor,
          onPressed: () => _showAddCareerDialog(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Agregar Carrera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildEmptyState(UniversityCareersProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              provider.errorMessage != null ? Icons.error_outline : Icons.school_outlined, 
              size: 64.r, 
              color: provider.errorMessage != null ? Colors.redAccent.withOpacity(0.3) : Colors.grey[300]
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            provider.errorMessage != null ? 'Error de carga' : 'Sin oferta registrada', 
            style: TextStyle(fontSize: 18.sp, color: _accentColor, fontWeight: FontWeight.w900)
          ),
          if (provider.errorMessage != null) ...[
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: () => provider.fetchCareers(),
              icon: const Icon(Icons.refresh, color: _primaryColor),
              label: const Text('Reintentar', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
    );
  }
}
