import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/university_alumni_provider.dart';
import '../providers/university_careers_provider.dart';
import '../components/university_alumni_card.dart';
import '../components/university_alumni_form.dart';
import '../components/university_bottom_navigation_bar.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text('Gestión de Egresados', 
          style: TextStyle(color: _accentColor, fontSize: 18.sp, fontWeight: FontWeight.w900)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildFilters(careersProvider),
          Expanded(
            child: alumniProvider.isLoading && alumniProvider.alumni.isEmpty
                ? const Center(child: CircularProgressIndicator(color: _primaryColor))
                : filteredAlumni.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => alumniProvider.fetchAlumni(),
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                          itemCount: filteredAlumni.length,
                          itemBuilder: (context, index) => UniversityAlumniCard(
                            alumni: filteredAlumni[index],
                            onEdit: () => _showAlumniForm(context, alumni: filteredAlumni[index]),
                            onDelete: () => _deleteAlumni(context, filteredAlumni[index].id),
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingActionButton(
          backgroundColor: _primaryColor,
          onPressed: () => _showAlumniForm(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 4),
    );
  }

  Widget _buildFilters(UniversityCareersProvider provider) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, puesto o empresa...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FE),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<String>(
            value: _selectedCareerId,
            hint: const Text('Filtrar por Carrera'),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FE),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas las carreras')),
              ...provider.careers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
            ],
            onChanged: (val) => setState(() => _selectedCareerId = val),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text('No se encontraron egresados', 
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _showAlumniForm(context),
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white),
            child: const Text('Registrar Primer Egresado'),
          ),
        ],
      ),
    );
  }
}
