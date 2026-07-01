import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/features/counselor/presentation/providers/counselor_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {
  int _selectedIndex = 0;
  static const Color primaryColor = Color(0xFF311B92);

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
    final authProvider = context.watch<AuthProvider>();
    
    // Obtenemos la imagen del usuario autenticado (S3 avatarUrl o photoUrl antiguo)
    final String? avatarUrl = authProvider.user?.effectivePhotoUrl ?? provider.profile?.profileImageUrl;

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
            icon: Icon(Icons.chat_bubble_outline_rounded, color: Colors.grey[700]),
            onPressed: () => context.push(AppRoutes.chatContacts.path),
          ),
          IconButton(
            icon: Badge(
              backgroundColor: Colors.redAccent,
              label: Text(provider.consultations.length.toString()),
              child: Icon(Icons.notifications_none_outlined, color: Colors.grey[700]),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 8.w),
            child: GestureDetector(
              onTap: () {
                // Aquí podrías navegar al perfil del orientador si existe la ruta
              },
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.grey[500], size: 20.sp)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: provider.isLoading && provider.groups.isEmpty
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildBody(provider),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Resumen'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Grupos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Alumnos'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reportes'),
        ],
      ),
    );
  }

  Widget _buildBody(CounselorProvider provider) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab(provider);
      case 1:
        return _buildGroupsTab(provider);
      case 2:
        return _buildStudentsTab(provider);
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64.sp, color: Colors.grey[300]),
              SizedBox(height: 16.h),
              Text('Sección en desarrollo', style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ],
          ),
        );
    }
  }

  Widget _buildDashboardTab(CounselorProvider provider) {
    return RefreshIndicator(
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
            _buildMiniStatsRow(provider),
            SizedBox(height: 32.h),
            _buildSectionHeader('Alertas Prioritarias', hasDot: provider.consultations.isNotEmpty, trailing: 'Ver todas'),
            SizedBox(height: 16.h),
            if (provider.consultations.isEmpty)
              const Center(child: Text('No hay alertas pendientes', style: TextStyle(color: Colors.grey)))
            else
              ...provider.consultations.take(3).map((alert) => _buildAlertItem(alert.studentName, alert.message, 'Hace poco')),
            SizedBox(height: 32.h),
            _buildSectionHeader('Herramientas y Acciones'),
            SizedBox(height: 16.h),
            _buildQuickActionsGrid(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsTab(CounselorProvider provider) {
    if (provider.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 80.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text('No tienes grupos creados', style: TextStyle(fontSize: 16.sp, color: Colors.grey[600], fontWeight: FontWeight.w600)),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => _showCreateGroupDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Crear mi primer grupo'),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadDashboardData(),
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: provider.groups.length,
        itemBuilder: (context, index) {
          final group = provider.groups[index] as Map<String, dynamic>;
          return _buildGroupCard(group);
        },
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Icon(Icons.groups_rounded, color: primaryColor, size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group['name'] ?? 'Sin nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: const Color(0xFF1D1B4B))),
                    Text('Código: ${group['accessCode'] ?? '---'}', style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: primaryColor),
                onPressed: () => _showEditGroupDialog(context, group),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey[50]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Creado: ${group['createdAt']?.toString().split('T')[0] ?? '---'}', style: TextStyle(fontSize: 11.sp, color: Colors.grey[500])),
              TextButton(
                onPressed: () => _showGroupDetails(group['id']),
                child: Text('Ver Detalle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMexicoDate(String? isoString) {
    if (isoString == null) return 'N/A';
    try {
      final date = DateTime.parse(isoString).toUtc().subtract(const Duration(hours: 6));
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (e) {
      return isoString;
    }
  }

  void _showGroupDetails(String groupId) async {
    final provider = context.read<CounselorProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final details = await provider.getGroupDetails(groupId);
    if (mounted) Navigator.pop(context);

    if (details != null && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles del Grupo', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900)),
              SizedBox(height: 16.h),
              _buildDetailItem('Nombre', details['name']),
              _buildDetailItem('Código de Acceso', details['accessCode']),
              _buildDetailItem('Fecha de Creación', _formatMexicoDate(details['createdAt'])),
              _buildDetailItem('Última Actualización', _formatMexicoDate(details['updatedAt'])),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                  child: const Text('Cerrar'),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value?.toString() ?? 'N/A', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']);
    final codeController = TextEditingController(text: group['accessCode']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24.h, left: 24.w, right: 24.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Editar Grupo', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900)),
              SizedBox(height: 24.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre del grupo', prefixIcon: const Icon(Icons.edit_outlined), filled: true, fillColor: const Color(0xFFF8F9FE), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none)),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Código de acceso', prefixIcon: const Icon(Icons.vpn_key_outlined), filled: true, fillColor: const Color(0xFFF8F9FE), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none)),
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
                  onPressed: () async {
                    final success = await context.read<CounselorProvider>().updateGroup(group['id'], name: nameController.text, accessCode: codeController.text);
                    if (success && mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grupo actualizado correctamente'), backgroundColor: Colors.green));
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentsTab(CounselorProvider provider) {
    if (provider.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_outlined, size: 80.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text('No hay alumnos registrados aún', style: TextStyle(fontSize: 16.sp, color: Colors.grey[600], fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Text('Comparte el código de grupo para que se unan.', style: TextStyle(fontSize: 13.sp, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadDashboardData(),
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: provider.students.length,
        itemBuilder: (context, index) {
          final student = provider.students[index];
          return _buildStudentCard(student);
        },
      ),
    );
  }

  Widget _buildStudentCard(StudentProfileEntity student) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: const Color(0xFF1D1B4B))),
                    if (student.groupName != null)
                      Text('Grupo: ${student.groupName}', style: TextStyle(fontSize: 11.sp, color: primaryColor, fontWeight: FontWeight.w600)),
                    Text(student.email, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10.r)),
                child: Text(
                  '${student.vocationalClarity * 10}% Claridad',
                  style: TextStyle(color: Colors.green[700], fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey[50]),
          Row(
            children: [
              Icon(Icons.star_outline_rounded, size: 14.sp, color: Colors.orange),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  student.interests.isNotEmpty ? student.interests.join(' • ') : 'Sin intereses definidos',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp, color: primaryColor),
                onPressed: () {
                  context.push(
                    AppRoutes.realChat.path,
                    extra: {
                      'contactId': student.id,
                      'contactName': student.name,
                    },
                  );
                },
                visualDensity: VisualDensity.compact,
                tooltip: 'Enviar mensaje',
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRoutes.studentFile.path,
                    extra: {
                      'studentId': student.id,
                      'studentName': student.name,
                    },
                  );
                },
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: Text('Ver Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatsRow(CounselorProvider provider) {
    return Container(
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
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.w,
      children: [
        _buildQuickAction('Mapa Vocacional', Icons.map_outlined, () => context.push(AppRoutes.vocationalMap.path), highlight: true),
        _buildQuickAction('Crear Grupo', Icons.group_add_outlined, () => _showCreateGroupDialog(context)),
        _buildQuickAction('Ver Reportes', Icons.description_outlined, () {}),
      ],
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

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap, {bool highlight = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFF5F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: highlight ? const Color(0xFFDED9FF) : Colors.grey[100]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF311B92), size: 28.sp),
            SizedBox(height: 8.h),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: const Color(0xFF1D1B4B)))
          ]
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24.h,
          left: 24.w,
          right: 24.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.group_add_outlined, color: const Color(0xFF311B92), size: 24.sp),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Crear Nuevo Grupo',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Define un nombre y un código único para que tus alumnos puedan unirse.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del grupo',
                  hintText: 'Ej. 6to Semestre A',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código de acceso',
                  hintText: 'Ej. ORIENTA2024',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  helperText: 'Este código es el que compartirás con tus alumnos.',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF311B92),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty && codeController.text.isNotEmpty) {
                      final success = await context.read<CounselorProvider>().createGroup(nameController.text, codeController.text);
                      if (success && mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Grupo creado correctamente'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Crear Grupo', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
