import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_alumni_provider.dart';
import '../providers/university_careers_provider.dart';
import '../components/university_alumni_card.dart';
import '../components/university_alumni_form.dart';
import '../components/university_bottom_navigation_bar.dart';
import '../components/university_empty_state.dart';
import '../components/university_premium_fab.dart';

class ManageAlumniScreen extends StatefulWidget {
  const ManageAlumniScreen({super.key});

  @override
  State<ManageAlumniScreen> createState() => _ManageAlumniScreenState();
}

class _ManageAlumniScreenState extends State<ManageAlumniScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);
  String _searchQuery = '';
  String? _selectedCareerId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UniversityAlumniProvider>().fetchAlumni();
        context.read<UniversityAlumniProvider>().fetchPendingStories();
        context.read<UniversityCareersProvider>().fetchCareers();
      }
    });
  }

  void _showAlumniForm(BuildContext context, {dynamic alumni}) {
    context.read<UniversityAlumniProvider>().resetForm(alumni: alumni);

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
        child: UniversityAlumniForm(
          alumni: alumni,
          onSuccess: () {
            Navigator.pop(sheetCtx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  alumni == null ? '¡Egresado registrado con éxito!' : 'Datos actualizados correctamente',
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

  void _deleteAlumni(BuildContext context, String id) async {
    final provider = context.read<UniversityAlumniProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('¿Eliminar Egresado?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Esta acción desvinculará al egresado de la institución.'),
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
      await provider.deleteAlumni(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alumniProvider = context.watch<UniversityAlumniProvider>();
    final careersProvider = context.watch<UniversityCareersProvider>();
    
    final filteredAlumni = alumniProvider.alumni.where((a) {
      final matchesSearch = a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.currentJob.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.company.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCareer = _selectedCareerId == null || a.careerId == _selectedCareerId;
      return matchesSearch && matchesCareer;
    }).toList();

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

    Widget directoryContent;

    if (alumniProvider.state == UniversityAlumniState.loading && alumniProvider.alumni.isEmpty) {
      directoryContent = const Center(child: CircularProgressIndicator(color: _primaryColor));
    } else if (alumniProvider.state == UniversityAlumniState.error && alumniProvider.alumni.isEmpty) {
      directoryContent = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              SizedBox(height: 16.h),
              Text(
                alumniProvider.errorMessage ?? 'Ocurrió un error inesperado',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => alumniProvider.fetchAlumni(),
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
    } else if (filteredAlumni.isEmpty) {
      directoryContent = _buildEmptyState(context);
    } else {
      directoryContent = RefreshIndicator(
        onRefresh: () => alumniProvider.fetchAlumni(),
        color: _primaryColor,
        child: crossAxisCount == 1
            ? ListView.builder(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8.h, horizontalPadding, 80.h),
                itemCount: filteredAlumni.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => UniversityAlumniCard(
                  alumni: filteredAlumni[index],
                  onEdit: () => _showAlumniForm(context, alumni: filteredAlumni[index]),
                  onDelete: () => _deleteAlumni(context, filteredAlumni[index].id),
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16.h, horizontalPadding, 80.h),
                itemCount: filteredAlumni.length,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: (width >= 1200) ? 1.6 : 1.45,
                ),
                itemBuilder: (context, index) => UniversityAlumniCard(
                  alumni: filteredAlumni[index],
                  margin: EdgeInsets.zero,
                  onEdit: () => _showAlumniForm(context, alumni: filteredAlumni[index]),
                  onDelete: () => _deleteAlumni(context, filteredAlumni[index].id),
                ),
              ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Gestión de Egresados', 
            style: TextStyle(color: isDark ? Colors.white : _accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: _primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: _primaryColor,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            tabs: [
              const Tab(
                icon: Icon(Icons.people_alt_rounded),
                text: 'Directorio',
              ),
              Tab(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rate_review_rounded),
                    if (alumniProvider.pendingStories.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.amber[700],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '${alumniProvider.pendingStories.length}',
                          style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                text: 'Por Aprobar',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                _buildFilters(careersProvider),
                Expanded(
                  child: directoryContent,
                ),
              ],
            ),
            _buildPendingStoriesTab(context, alumniProvider),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: UniversityPremiumFab(
          label: 'Registrar Egresado',
          onPressed: () => _showAlumniForm(context),
        ),
        bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildPendingStoriesTab(BuildContext context, UniversityAlumniProvider provider) {
    if (provider.isLoadingStories && provider.pendingStories.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor));
    }

    if (provider.pendingStories.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => provider.fetchPendingStories(),
        color: _primaryColor,
        child: ListView(
          children: [
            SizedBox(height: 80.h),
            UniversityEmptyState(
              title: 'No hay historias pendientes de aprobación',
              imagePath: 'assets/images/egresados.png',
              fallbackIcon: Icons.mark_chat_read_rounded,
            ),
          ],
        ),
      );
    }

    final double width = MediaQuery.of(context).size.width;
    final int gridColumns = width >= 800 ? 2 : 1;
    final double horizontalPadding = width >= 800 ? 24.w : 20.w;

    return RefreshIndicator(
      onRefresh: () => provider.fetchPendingStories(),
      color: _primaryColor,
      child: gridColumns == 1
          ? ListView.builder(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 16.h, horizontalPadding, 80.h),
              itemCount: provider.pendingStories.length,
              itemBuilder: (context, index) {
                final story = provider.pendingStories[index];
                return _buildStoryModerationCard(context, provider, story);
              },
            )
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 16.h, horizontalPadding, 80.h),
              itemCount: provider.pendingStories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final story = provider.pendingStories[index];
                return _buildStoryModerationCard(context, provider, story);
              },
            ),
    );
  }

  Widget _buildStoryModerationCard(BuildContext context, UniversityAlumniProvider provider, dynamic story) {
    final String title = story['title'] ?? 'Historia sin título';
    final String content = story['content'] ?? '';
    final String authorName = story['alumniName'] ?? story['alumni_name'] ?? 'Egresado';
    final String storyId = story['id'] ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F30) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, color: _primaryColor, size: 20.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : _accentColor,
                      ),
                    ),
                    Text(
                      'Egresado(a)',
                      style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.white54 : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3B2E15) : Colors.amber[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'PENDIENTE',
                  style: TextStyle(
                    color: isDark ? Colors.amber[400] : Colors.amber[900],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
              color: isDark ? Colors.white : _accentColor,
            ),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.white70 : Colors.grey[800],
                  height: 1.3,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final success = await provider.rejectStory(storyId);
                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Historia rechazada'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Rechazar'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(0, 38.h),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(width: 12.w),
              ElevatedButton.icon(
                onPressed: () async {
                  final success = await provider.approveStory(storyId);
                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Historia aprobada y publicada!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Aprobar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 38.h),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(UniversityCareersProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 720;

    final Widget searchField = TextField(
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, puesto...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF8F9FE),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    );

    final Widget dropdownField = DropdownButtonFormField<String>(
      isExpanded: true,
      value: _selectedCareerId,
      hint: const Text('Filtrar por Carrera', overflow: TextOverflow.ellipsis),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF8F9FE),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Todas las carreras')),
        ...provider.careers.map((c) => DropdownMenuItem(
          value: c.id, 
          child: Text(
            c.name, 
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ],
      onChanged: (val) => setState(() => _selectedCareerId = val),
    );

    return Container(
      color: isDark ? const Color(0xFF0F1020) : Colors.white,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 3, child: searchField),
                SizedBox(width: 16.w),
                Expanded(flex: 2, child: dropdownField),
              ],
            )
          : Column(
              children: [
                searchField,
                SizedBox(height: 10.h),
                dropdownField,
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return UniversityEmptyState(
      title: 'No hay egresados registrados aún',
      imagePath: 'assets/images/egresados.png',
      fallbackIcon: Icons.people_alt_rounded,
    );
  }
}
