import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/counselor_provider.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounselorProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    const Color primaryColor = Color(0xFF311B92);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Oriéntate+',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 22.sp),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.grey[700]), onPressed: () {}),
          IconButton(
            icon: Badge(
              backgroundColor: Colors.redAccent,
              label: Text(provider.consultations.length.toString()),
              child: Icon(Icons.notifications_none_outlined, color: Colors.grey[700]),
            ),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 8.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.grey[200],
              backgroundImage: provider.profile?.profileImageUrl != null 
                ? NetworkImage(provider.profile!.profileImageUrl!) 
                : const NetworkImage('https://i.pravatar.cc/150?u=counselor'),
            ),
          ),
        ],
      ),
      body: provider.isLoading && provider.groups.isEmpty
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: () => provider.loadDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Resumen General', trailing: 'Actualizado hoy'),
                    SizedBox(height: 16.h),
                    
                    Row(
                      children: [
                        Expanded(child: _buildMainStatCard('ALUMNOS TOTALES', provider.totalStudentsCount.toString(), Icons.people_outline, Colors.blue, 'Inscritos en el ciclo')),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildMainStatCard('ACTIVOS', provider.activeStudentsCount.toString(), Icons.trending_up, Colors.purple, 'Participación mensual')),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildMainStatCard('SIN AVANCE', provider.lowProgressCount.toString(), Icons.person_off_outlined, Colors.grey, 'Últimos 15 días')),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildMainStatCard('INDECISIÓN ALTA', provider.highIndecisionCount.toString(), Icons.error_outline, Colors.red, 'Riesgo de abandono')),
                      ],
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniStat(provider.solicitudesCount.toString(), 'SOLICITUDES'),
                          Container(height: 20.h, width: 1.w, color: Colors.grey[100]),
                          _buildMiniStat(provider.groupsCount.toString(), 'GRUPOS'),
                          Container(height: 20.h, width: 1.w, color: Colors.grey[100]),
                          _buildMiniStat(provider.reportesCount.toString(), 'REPORTES'),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),
                    _buildSectionHeader('Alertas Prioritarias', hasDot: provider.consultations.isNotEmpty, trailing: 'Ver todas'),
                    SizedBox(height: 16.h),
                    
                    if (provider.consultations.isEmpty)
                      const Center(child: Text('No hay alertas pendientes', style: TextStyle(color: Colors.grey)))
                    else
                      ...provider.consultations.take(3).map((alert) => _buildAlertItem(alert.studentName, alert.message, 'Hace poco')),

                    SizedBox(height: 32.h),
                    _buildSectionHeader('Accesos Directos'),
                    SizedBox(height: 16.h),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.w,
                      children: [
                        _buildQuickAction('Crear Grupo', Icons.add_circle_outline, () => _showCreateGroupDialog(context)),
                        _buildQuickAction('Nueva Sesión', Icons.assignment_ind_outlined, () {}),
                      ],
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Grupos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Alumnos'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reportes'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing, bool hasDot = false}) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D1B4B))),
        if (hasDot) ...[
          SizedBox(width: 8.w),
          Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
        ],
        const Spacer(),
        if (trailing != null) Text(trailing, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF311B92), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMainStatCard(String label, String value, IconData icon, Color color, String sub) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: color, size: 22.sp), Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900))]),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: Colors.grey[800])),
          Text(sub, style: TextStyle(fontSize: 9.sp, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(children: [Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: Colors.grey))]);
  }

  Widget _buildAlertItem(String name, String sub, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: Colors.grey[100]!)),
      child: Row(children: [CircleAvatar(radius: 20.r, child: Text(name.isNotEmpty ? name[0] : '?')), SizedBox(width: 12.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey))])), Icon(Icons.chevron_right, color: Colors.grey[300])]),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Colors.grey[100]!)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: const Color(0xFF311B92), size: 28.sp), SizedBox(height: 8.h), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController(); // Nuevo campo para el código de acceso

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('Nuevo Grupo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del grupo', hintText: 'Ej. 6to A')),
            SizedBox(height: 12.h),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Código de acceso', hintText: 'Ej. ORIENTA2024')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF311B92), foregroundColor: Colors.white),
            onPressed: () async {
              if (nameController.text.isNotEmpty && codeController.text.isNotEmpty) {
                final success = await context.read<CounselorProvider>().createGroup(nameController.text, codeController.text);
                if (success && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grupo creado correctamente')));
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<CounselorProvider>().errorMessage ?? 'Error')));
                }
              }
            }, 
            child: const Text('Crear')
          ),
        ],
      ),
    );
  }
}
