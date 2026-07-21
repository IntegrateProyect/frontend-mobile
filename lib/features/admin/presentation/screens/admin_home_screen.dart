import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/admin/presentation/providers/admin_provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AdminProvider>().fetchStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color bgColor = Color(0xFFF8F9FE);
    final adminProvider = context.watch<AdminProvider>();
    final stats = adminProvider.stats;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Oriéntate+',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[700], size: 26.sp),
            onPressed: () {},
          ),
          IconButton(
            icon: Badge(
              backgroundColor: Colors.redAccent,
              label: const Text('5'),
              child: Icon(Icons.notifications_none_outlined, color: Colors.grey[700], size: 26.sp),
            ),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 8.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.grey[200],
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin_user'),
            ),
          ),
        ],
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: () => adminProvider.fetchStats(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, Administrador',
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D1B4B)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Supervisión global del sistema y usuarios.',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 24.h),

                    // --- SECCIÓN: RESUMEN GENERAL ---
                    _buildSectionHeader('Resumen General', trailing: 'Actualizado ahora'),
                    SizedBox(height: 16.h),
                    
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('ESTUDIANTES', stats?.totalStudents.toString() ?? '0', Icons.school_outlined, Colors.blue, 'Inscritos')),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildStatCard('ORIENTADORES', stats?.totalCounselors.toString() ?? '0', Icons.people_alt_outlined, Colors.purple, 'Activos')),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('UNIVERSIDADES', stats?.totalUniversities.toString() ?? '0', Icons.account_balance_outlined, Colors.green, 'Validadas')),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildStatCard('ALUMNI', stats?.totalAlumni.toString() ?? '0', Icons.workspace_premium_outlined, Colors.orange, 'Egresados')),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // --- SECCIÓN: ALERTAS PRIORITARIAS ---
                    _buildSectionHeader('Alertas del Sistema', hasDot: true, trailing: 'Ver todas'),
                    SizedBox(height: 12.h),
                    _buildAlertItem('Nueva Universidad', 'UVM - Pendiente de validación', 'Hace 5 min', Icons.domain_verification),
                    _buildAlertItem('Reporte de Error', 'Incidencia en Auth Service', 'Hace 2 horas', Icons.report_problem_outlined),
                    _buildAlertItem('Nuevo Orientador', 'Dr. Arriaga - Por validar', 'Hace 5 horas', Icons.person_add_alt),

                    SizedBox(height: 32.h),

                    // --- SECCIÓN: ACCESOS DIRECTOS ---
                    _buildSectionHeader('Accesos Directos'),
                    SizedBox(height: 16.h),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.w,
                      children: [
                        _buildQuickAction('Control Usuarios', Icons.manage_accounts_outlined, () => context.push('/admin-users')),
                        _buildQuickAction('Validar Códigos', Icons.verified_user_outlined, () {}),
                        _buildQuickAction('Configuración', Icons.settings_outlined, () {}),
                        _buildQuickAction('Cerrar Sesión', Icons.logout, () async {
                          await context.read<AuthProvider>().logout();
                          if (mounted) context.go('/login');
                        }),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // --- SECCIÓN: ACTIVIDAD RECIENTE ---
                    _buildSectionHeader('Actividad Reciente'),
                    SizedBox(height: 16.h),
                    _buildRecentActivityCard(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Usuarios'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_outlined), label: 'Instituciones'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Sistema'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing, bool hasDot = false, VoidCallback? onTrailingTap}) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D1B4B))),
        if (hasDot) ...[
          SizedBox(width: 8.w),
          Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
        ],
        const Spacer(),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing,
              style: TextStyle(fontSize: 11.sp, color: Colors.blue[600], fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, String sub) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22.sp),
              Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B))),
            ],
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: Colors.grey[800])),
          Text(sub, style: TextStyle(fontSize: 9.sp, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String sub, String time, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.blue[700], size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: const Color(0xFF1D1B4B))),
                Text(sub, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(fontSize: 10.sp, color: Colors.grey[400])),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[300]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(color: Color(0xFFF5F3FF), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF311B92), size: 26.sp),
            ),
            SizedBox(height: 10.h),
            Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D1B4B))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildActivityItem('Sincronización', 'Gateway AWS actualizado', 'HOY - 09:30 AM', isLast: false),
          _buildActivityItem('Backup', 'Sistema replicado con éxito', 'AYER - 04:15 PM', isLast: false),
          _buildActivityItem('Mantenimiento', 'Limpieza de logs completada', 'AYER - 11:00 AM', isLast: true),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String desc, String time, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10.w, height: 10.w,
                decoration: const BoxDecoration(color: Color(0xFF42A5F5), shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2.w, color: Colors.grey[100])),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: const Color(0xFF1D1B4B))),
                SizedBox(height: 2.h),
                Text(desc, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500])),
                SizedBox(height: 4.h),
                Text(time, style: TextStyle(fontSize: 10.sp, color: Colors.grey[400], fontWeight: FontWeight.bold)),
                if (!isLast) SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
