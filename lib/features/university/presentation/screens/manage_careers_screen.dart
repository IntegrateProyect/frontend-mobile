import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_careers_provider.dart';
import '../components/university_career_card.dart';
import '../components/university_career_form.dart';
import '../components/university_bottom_navigation_bar.dart';
import '../components/university_empty_state.dart';
import '../components/university_premium_fab.dart';
import '../components/premium_upgrade_dialog.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

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
    final authProvider = context.watch<AuthProvider>();
    final isPremium = authProvider.user?.isPremium ?? false;
 
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = (width >= 1200)
        ? 3
        : (width >= 720)
            ? 2
            : 1;

    final double horizontalPadding = (width >= 1200)
        ? 40.w
        : (width >= 720)
            ? 24.w
            : 20.w;

    Widget bodyContent;

    if (provider.state == UniversityCareersState.loading && provider.careers.isEmpty) {
      bodyContent = const Center(child: CircularProgressIndicator(color: _primaryColor));
    } else if (provider.state == UniversityCareersState.error && provider.careers.isEmpty) {
      bodyContent = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              SizedBox(height: 16.h),
              Text(
                provider.errorMessage ?? 'Ocurrió un error inesperado',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => provider.fetchCareers(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (provider.careers.isEmpty) {
      bodyContent = _buildEmptyState(context);
    } else {
      bodyContent = RefreshIndicator(
        onRefresh: () => provider.fetchCareers(),
        color: _primaryColor,
        child: crossAxisCount == 1
            ? ListView.builder(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8.h, horizontalPadding, 80.h),
                itemCount: provider.careers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => UniversityCareerCard(
                  career: provider.careers[index],
                  onDelete: () => _deleteCareer(context, provider.careers[index].id),
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16.h, horizontalPadding, 80.h),
                itemCount: provider.careers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: (width >= 1200) ? 1.55 : 1.4,
                ),
                itemBuilder: (context, index) => UniversityCareerCard(
                  career: provider.careers[index],
                  margin: EdgeInsets.zero,
                  onDelete: () => _deleteCareer(context, provider.careers[index].id),
                ),
              ),
      );
    }
 
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Oferta Académica',
          style: TextStyle(
            color: isDark ? Colors.white : _accentColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        automaticallyImplyLeading: false, 
      ),
      body: bodyContent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: UniversityPremiumFab(
        label: 'Vincular Carrera',
        onPressed: () {
          if (!isPremium && provider.careers.length >= 3) {
            showPremiumUpgradeDialog(context, feature: 'carreras asociadas');
          } else {
            _showAddCareerDialog(context);
          }
        },
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return UniversityEmptyState(
      title: 'Sin carreras registradas aún',
      imagePath: 'assets/images/oferta_academica.png',
      fallbackIcon: Icons.school_rounded,
    );
  }
}
